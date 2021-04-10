package net.hobbyscience.math;

import java.util.HashSet;

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
        return builder.toString();
    }

    /**
     * Invert a function so when writing out units we don't have to do anything in both directions.
     * @param postfix
     * @return postfix but the function inverse
     */
    public static String invertPostfix( String postfix){
        return postfix;
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
