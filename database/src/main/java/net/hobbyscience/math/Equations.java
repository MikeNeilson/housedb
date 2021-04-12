package net.hobbyscience.math;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

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
        StringBuilder builder = new StringBuilder();
        Token tokens[] = ShuntingYard.convertToRPN(infix, null, null, vars, false);
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


    private static boolean isOperand(String token ){
        switch( token ){
            case "+": // fallthrough
            case "-": // fallthrough
            case "^": // fallthrough
            case "*": // fallthrough
            case "/": // fallthrough
            case "i": //
            case "sqrt": {
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
            case "^": return "sqrt";
            case "*": return "/";
            case "/": return "*";
            case "sqrt": return "^";
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
            case "sqrt": return Double.toString( Math.pow(r1,1.0/r2) );
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
                case "sqrt": {
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

    /**
     * 
     * @param postfix
     * @return a version of the 
     */
    public static String reduce( String postfix ){
        return postfix;
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
