/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

package net.hobbyscience.math;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;
import java.util.stream.Stream;

import db.migration.NoConversionFound;
import net.hobbyscience.database.exceptions.NoInverse;
import net.hobbyscience.database.exceptions.NotImplemented;
import net.objecthunter.exp4j.shuntingyard.ShuntingYard;
import net.objecthunter.exp4j.tokenizer.*;

public class Equations {
    private static HashSet<String> vars = new HashSet<>();
    static {
        vars.add("i");
    }

    /**
     * 
     * @param infix Infix algebraic expression
     * @return a postfix preresentation of the equation
     */
    public static String infixToPostfix( String infix){        
        //System.out.println(infix);        
        //StringBuilder builder = new StringBuilder();
        Token tokens[] = ShuntingYard.convertToRPN(infix, null, null, vars, false);
        return tokensToString(tokens);
    }


    private static boolean isOperand(String token ){
        switch( token ){
            case "+": // fallthrough
            case "-": // fallthrough
            case "^": // fallthrough
            case "*": // fallthrough
            case "/": // fallthrough
            case "i": //
            case "nroot": {
                return true;
            }
            default: {
                return false;
            }
        }
    }

    private static String inverseFor(String operand){
        switch( operand ){
            case "+": return "-";
            case "-": return "+";
            case "^": return "nroot";
            case "*": return "/";
            case "/": return "*";
            case "nroot": return "^";
            default: {
                throw new NoInverse("Cannot find inverser for operator " + operand);
            }
        }
    }

    private static String calc(String left, String right, String operand ){
        double r1 = Double.parseDouble(left);
        double r2 = Double.parseDouble(right);
        switch( operand ){
            case "+": return Double.toString( r1+r2 );
            case "-": return Double.toString( r1-r2 );
            case "^": return Double.toString( Math.pow(r1,r2) );
            case "*": return Double.toString( r1*r2 );
            case "/": return Double.toString( r1/r2 );
            case "nroot": return Double.toString( Math.pow(r1,1.0/r2) );
            default: {
                throw new NotImplemented("Cannot calculate for operator " + operand);
            }
        }
    }

    /**
     * Invert a function so when writing out units we don't have to do anything in both directions.
     * @param postfix
     * @return postfix but the function inverse
     */
    public static String invertPostfix( String postfix){
        Queue<String> lhs = new LinkedList<>();
        Stack<String> rhs = new Stack<>();
        Stack<String> hold = new Stack<>();
        for( String tok: postfix.split("\\s+") ){
            rhs.push(tok);
        }
    
        while( !rhs.empty() ){
            var token = rhs.pop();
            switch( token ){
                case "i":{
                    break;
                }
                case "+": // fallthrough                                    
                case "-": // fallthrough
                case "^": // fallthrough
                case "*": // fallthrough
                case "/": // fallthrough
                case "nroot": {
                    String r = rhs.pop();
                    String l = rhs.pop();
                    if( r.equals("i") ){
                        hold.add(rhs.pop());
                        hold.add(token);
                        rhs.push(l);                        
                    } else if( !isOperand(r) && !isOperand(l) ){
                        lhs.add(calc(l, r, token));
                        lhs.add(inverseFor(token));
                    } else if( !isOperand(r) ) {
                        lhs.add(r);
                        lhs.add(inverseFor(token));
                        rhs.push(l);
                    }
                    break;
                }
                default: {
                    lhs.add(token);
                }
            }
        }
        if( !hold.isEmpty() ){
            lhs.add(inverseFor(hold.pop())); // for now we'll assume only one "var op" will ever be present here.
        }
        StringBuilder builder = new StringBuilder();
        builder.append("i ");
        lhs.forEach( t -> {
            builder.append(t).append(" ");
        });

        return builder.toString().trim();
    }

    private static Deque<Token> stringToTokens(String postfix) {
        Deque<Token> tokens = new ArrayDeque<>(10);
        var tokenizer = new Tokenizer(postfix,null,null,vars,false);
        while(tokenizer.hasNext()){
            tokens.add(tokenizer.nextToken());
        }
        return tokens;
    }

    private static String tokensToString(Token[] tokens) {
        StringBuilder builder = new StringBuilder();
        for( Token tok: tokens ){
            switch(tok.getType()){
                case Token.TOKEN_FUNCTION: { builder.append(((FunctionToken)tok).getFunction().getName()).append(" "); break;}
                case Token.TOKEN_NUMBER: { builder.append(((NumberToken)tok).getValue()).append(" "); break;}
                case Token.TOKEN_VARIABLE: { builder.append( ((VariableToken)tok).getName() ).append(" "); break;  }
                case Token.TOKEN_OPERATOR: { builder.append( ((OperatorToken)tok).getOperator().getSymbol() ).append(" "); break; }
                default: { break;}
            }
        }        
        return builder.toString().trim();
    }


    private static void evaluate(Deque<Token> lhs, final OperatorToken holdOp) {
        Deque<Token> holdStack = new ArrayDeque<>(10);
        Deque<Token> varStack = new ArrayDeque<>(5);
        Deque<Token> regStack = new ArrayDeque<>(2);
                
        Deque<Token>  opStack = new ArrayDeque<>(10);
        
        Token tmp = null;
        // move the lhs stack to the hold stack        
        while ((tmp = lhs.pollLast()) != null ) {
            holdStack.add(tmp);
        }

        // evaluate each element of the hold tack
        while( (tmp = holdStack.pollFirst()) != null ) {
            switch(tmp.getType()) {
                case Token.TOKEN_NUMBER:
                case Token.TOKEN_VARIABLE: {
                    varStack.add(tmp);
                    break;
                }
                case Token.TOKEN_OPERATOR: {
                    
                    if( distribute(holdOp,(OperatorToken)tmp)) {
                        opStack.add(tmp);
                        varStack.add(varStack.peekLast());
                    } else {
                        opStack.add(varStack.peekLast());
                    }
                    break;
                }
            }

            var theOp = holdOp.getOperator();
            int numOperands = theOp.getNumOperands();
            if( varStack.size() >= numOperands ) {
                var allNumber = true;
                for (int i = 0; i < numOperands; i++) {
                    var tmpVar = varStack.pollLast();
                    if( tmpVar.getType() == Token.TOKEN_VARIABLE) {
                        allNumber = false;
                    }
                    regStack.add(tmpVar);
                }

                if( allNumber ) {                    
                    double values[] = regStack.stream()
                                              .map((t)->(NumberToken)t)
                                              .mapToDouble( NumberToken::getValue)
                                              .toArray();
                    regStack.clear();
                    double result = theOp.apply(values);
                    varStack.add(new NumberToken(result));
                } else {
                    opStack.add(holdOp);
                    Token tmpVar = null;
                    while( (tmpVar = regStack.pollLast()) != null) {
                        opStack.add(tmpVar);
                    }
                }               
           }            
        }

        /* unwind the stacks that are left */
        Token regTmp = null;
        while ((regTmp = regStack.pollLast()) != null) {
            opStack.add(regTmp);
        }

        Token varTmp = null;
        while ((varTmp = varStack.pollLast()) != null) {
            opStack.add(varTmp);
        }

        Token opStackTmp = null;
        while( (opStackTmp = opStack.pollLast()) != null ) {
            lhs.add(opStackTmp);
        }

        switch (lhs.peekLast().getType()) {
            case Token.TOKEN_NUMBER:
            case Token.TOKEN_VARIABLE: {
                lhs.add(holdOp);
                break;
            }
            case Token.TOKEN_OPERATOR: {
                // do nothing
                break;
            }
            default: {
                throw new RuntimeException(String.format("Token type %s not implemented",opStackTmp.toString()));
            }
        }

    }


    /**
     * 
     * @param postfix
     * @return a version of the 
     */
    public static String reduce( String postfix ){
        Deque<Token> rhs = stringToTokens(postfix);
        Deque<Token> lhs = new ArrayDeque<>(10);
        

        while( !rhs.isEmpty() ) {
            var token = rhs.pollFirst();
            switch( token.getType() ) {
                case Token.TOKEN_VARIABLE:
                case Token.TOKEN_NUMBER: {
                    lhs.add(token);
                    break;
                }
                case Token.TOKEN_OPERATOR: {
                    // do the stuff
                    var holdOp = (OperatorToken)token;
                    evaluate(lhs,holdOp);                    
                    break;
                }
                default: {
                    throw new RuntimeException("Function Tokens not implemented yet");                    
                }
            }
        }

        return tokensToString(lhs.toArray(new Token[0]));
    }

    private static boolean distribute(OperatorToken holdOp, OperatorToken currentOp) {
        String set = String.format("%s,%s",
                                   holdOp.getOperator().getSymbol(),
                                   currentOp.getOperator().getSymbol());
        switch(set) {
            case "*,+": return true;
            case "*,-": return true;
            case "*,*": return false;
            case "*,/": return false;
            case "/,*": return false;
            case "/,/": return false;
            case "/,+": return true;
            case "/,-": return false;
            case "+,*": return false;
            case "+,/": return false;
            case "+,+": return false;            
            case "+,-": return false;
            case "-,-": return false;            
            case "-,+": return false;
            case "-,*": return false;
            case "-,/": return false;
            default: return false;
        }        
    }

    /**
     * 
     * @param recieving postfix equation in fix the i will be subsituted
     * @param inserting the new "value" of i
     * @return a postfix equation
     */
    public static String combine( String recieving, String inserting){
        return recieving.replace("i", inserting);
    }

}
