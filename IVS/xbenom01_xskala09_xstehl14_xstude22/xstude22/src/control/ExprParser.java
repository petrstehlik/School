/**
 * @author xskala09 
 * @date 20.4.2016
 * @file ExprParser.java
 * @brief Expression parser for calculator
 */

package control;
import java.util.*;

import control.SyntaxError;
import math.*;

/**
 * @brief Expression parser and evaluator for mathematical expressions.
 * @author xskala09
 *
 */
public class ExprParser
{
	private String Expression; /*!< Expression which will be parsed */ 
	private char CurrentChar; /*!< Currently parsed character */
	private int CurrentPosition; /*!< Current position in input stream processing */
	private String Token; /*!< Last found token */
	private TOKENIDS TokenID; /*!< Last found token identifier */
	private Double resultDouble; /*!< Evaluated input string as Double. */
	private String resultString; /*!< Evaluated input string as String. This is returned from parse method */
	private MODE mode; /*!< Parser mode. Represents the final datatype of evaluated expression */
	
	private Arithmetic aritLib = new Arithmetic(); /*!< Instance of arithemetic library class */
	private Goniometric gonLib = new Goniometric(); /*!< Instance of goniometric library class */
	private Logic logicLib = new Logic(); /*!< Instance of logical library class */
	private Utility utilsLib = new Utility(); /*!< Instance of Utility library class. Contains variables and Random method */

	/**
	 * @brief Enumeration representing token identifiers. 
	 */
	private enum TOKENIDS {
		NONE, /*!< Initial token ID. */ 
		SEPARATOR, /*!< Token, which is not a number, variable or function (e.g. parenthesis and operators) */ 
		IMMEDIATE, /*!< Numerical constant */ 
		VARIABLE, /*!< Variable constant (e.g. PI or E) */ 
		FUNCTION, /*!< Function token ID */ 
		UNKNOWN /*!< Unknown token ID */ 
		}

	/**
	 * @brief Enumeration representing defined operators. 
	 */
	private enum OPERATORS {
		ADD, /*!< Plus operator */ 
		SUB, /*!< Minus operator */
		MUL, /*!< Multiply operator */
		DIV, /*!< Divide operator */
		POW, /*!< Power operator */
		FAC, /*!< Factorial operator */
		AND, /*!< Logical AND operator */
		OR, /*!< Logical OR operator */
		XOR, /*!< Logical XOR operator */
		NOT, /*!< Logical NOT operator */
		MOD,/*!< Modulus operator */
		UNKNOWN /*!< + operator */
		} 
	/**
	 * @brief Enumeration representing parser mode.
	 */
	public enum MODE {
		DEFAULT, /*!< Default mode. Numbers are stored as doubles */ 
		BINARY, /*!< Binary mode. Numbers are represented in binary */
		DECIMAL /*!< Decimal mode. Numbers are represented in decimal (integers) */
		}
	
	/**
	 * @brief Enumeration representing parser mode. 
	*/
	public MODE modes;
	
	/**
	 * @brief Constructor.Initializes all internal data needed for parsing
	 */
	public ExprParser(){
		this.Expression = "";
		this.CurrentChar = 0;
		this.Token = "";
		this.TokenID = TOKENIDS.NONE;
		this.CurrentPosition = -1;
		this.resultDouble = 0.0;
		this.resultString = "";
		this.mode = MODE.DEFAULT;
	}

	/**
	 * @brief Debug mode with an expression passed as argument.
	 *        Prints the evaluated expression.
	 * @param expression Mathematical expression to parse
	*/	
	public void debugMode(String expression) throws SyntaxError, MathError, DivisionByZero{
		ExprParser parser = new ExprParser();
		String result = parser.parse(expression);
		System.out.println(result);
	}

	/**
	 * @brief Interactive debug mode. Expression are inserted to the commandline.
	 * 		  Prints the evaluated expression.
	 */
	public void debugMode() throws SyntaxError, MathError, DivisionByZero{
		Scanner userInput = new Scanner(System.in);
		ExprParser parser = new ExprParser();
		String expression = ""; 

		System.out.print("Enter an expression to evaluate.\nType exit or quit to exit the application\n");
		do{
			System.out.print("> ");
			expression = userInput.nextLine(); // Get user input
			if (expression.length() == 0){
				System.out.println("No input given");
			} 
			else if (expression.toLowerCase().equals("quit") || expression.toLowerCase().equals("exit")){ // Exit debug mode
				System.out.println("Got '" + expression + "' command, exiting test mode...");
				userInput.close();
				break;
			}
			else{ // Do the parsing stuff
				String result = parser.parse(expression);
				System.out.println(result);
			}
		}
		while(true);
	}	

	/**
	 * @brief Parse the given expression to tokens and evaluate the expression. Operator
	 *        precedence is supported.
	 * @param expression Mathematical expression to parse
	 * @return Evaluated expression as String
	 * @throws MathError, DivisionByZero 
	 * 
	 */
	public String parse(final String expression) throws SyntaxError, MathError, DivisionByZero{
		if (expression.length() == 0)
			return ""; // This should never happen
		// initialize all variables (needed if parse is called multiple times in one run)
		this.CurrentPosition = -1; // Reset current position
		Expression = expression; // Store expression to attribute
		resultDouble = 0.0;
		readNextChar();
		getNextToken();
		
		resultDouble = parseLogical(); // Logical operations have the lowest priority, parse first.	
		resultString = String.valueOf(resultDouble);
		return resultString;
	}

	/**
	 * @brief Parse the given expression to tokens and evaluate the expression. Operator
	 *        precedence is supported.
	 * @param expression Mathematical expression to parse
	 * @param mode Calculation mode.
	 * @return Evaluated expression as String
	 * @throws MathError, DivisionByZero 
	 * 
	 */
	public String parse(final String expression, MODE mode) throws SyntaxError, MathError, DivisionByZero{
		if (expression.length() == 0)
			return ""; // This should never happen
		
		this.mode = mode; // Set mode only for this run
		// initialize all variables (needed if parse is called multiple times in one run)
		this.CurrentPosition = -1; // Reset current position
		Expression = expression; // Store expression to attribute
		resultDouble = 0.0;
		readNextChar();
		getNextToken();
			
		resultDouble = parseLogical(); // Logical operations have the lowest priority, parse first.
		if (mode == MODE.BINARY){
			int result = resultDouble.intValue();
			resultString = Integer.toBinaryString(result);
		}
		else if (mode == MODE.DECIMAL){
			int result = resultDouble.intValue();
			resultString = Integer.toString(result);
		}
		else
			resultString = String.valueOf(resultDouble);
		this.mode = MODE.DEFAULT; // Reset mode to default
		return resultString;
  }
	
	/**
	 * @brief Convert binary as String to decimal as String
	 * @param bin String representing number in binary
	 * @return String representing number in decimal
	 */
	public String bin2dec(String bin) throws NumberFormatException{
		int integer = Integer.parseInt(bin, 2); // String to Int
		return Integer.toString(integer);
	}
	
	/**
	 * @brief Convert decimal as String to binary as String
	 * @param dec String representing number in decimal
	 * @return String representing number in binary
	 */
	public String dec2bin(String dec) throws NumberFormatException{
		int integer = Integer.parseInt(dec); // String to Int
		return Integer.toBinaryString(integer);	
	}
	
	/**
	 * @brief Parse logical operators (AND, OR, XOR) and MOD. 
	 *   If suitable operator is not found, scan deeper (NOT operator).
	 * @return Evaluated operation
	 */
	double parseLogical() throws SyntaxError, MathError, DivisionByZero{
		OPERATORS operatorID;
		double result = parseNot(); // NOT operator is the next level
		
		operatorID = getIDFromToken(this.Token);
		while (operatorID == OPERATORS.AND ||
			   operatorID == OPERATORS.OR  ||
			   operatorID == OPERATORS.MOD ||
			   operatorID == OPERATORS.XOR){
			getNextToken();
			double secondOperand = parseNot();
			result = calculateExpr(operatorID, result, secondOperand);
			operatorID = getIDFromToken(Token);
	    }
	    return result;
	  }
	
	/**
	 * @brief Parse NOT operators. 
	 *   If suitable operator is not found, scan deeper (Addition, subtraction operations).
	 * @return Evaluated operation
	 */
	double parseNot() throws SyntaxError, MathError, DivisionByZero{
		OPERATORS operatorID;
		double result;
		// NOT is left-asociated -> first get NOT token then operand
		operatorID = getIDFromToken(this.Token);
		if (operatorID == OPERATORS.NOT){
			getNextToken();
			double operand = parseAddSub();
			result = calculateExpr(operatorID, operand, 0.0);
			operatorID = getIDFromToken(Token);
	    }
		else // NOT not found, continue scan
			result = parseAddSub();
	    return result;
	  }
	
	/**
	 * @brief Parse addition and subtraction operations. 
	 *   If suitable operator is not found, scan deeper (Addition, subtraction operations).
	 * @return Evaluated operation
	 */
	double parseAddSub() throws SyntaxError, MathError, DivisionByZero{
		OPERATORS operatorID;
		double result = parseMulDiv();
		
		operatorID = getIDFromToken(this.Token);
		while (operatorID == OPERATORS.ADD || 
				operatorID == OPERATORS.SUB){
			getNextToken();
			double secondOperand = parseMulDiv();
			result = calculateExpr(operatorID, result, secondOperand);
			operatorID = getIDFromToken(Token);
	    }
	    return result;
	  }
	
	/**
	 * @brief Parse multiply and divide operations. 
	 *   If suitable operator is not found, scan deeper (power operation).
	 * @return Evaluated operation
	 */
	double parseMulDiv() throws SyntaxError, MathError, DivisionByZero{
		OPERATORS operatorID;
		double result = parsePow();
		operatorID = getIDFromToken(Token);
		while (operatorID == OPERATORS.MUL || 
	    	   operatorID == OPERATORS.DIV){
			getNextToken();
			double secondOperand = parsePow();
			result = calculateExpr(operatorID, result, secondOperand);
			operatorID = getIDFromToken(Token);
		}
	    return result;
	  }
	
	/**
	 * @brief Parse power operation. 
	 *   If suitable operator is not found, scan deeper (factorial operation).
	 * @return Evaluated operation
	 */
	double parsePow() throws SyntaxError, MathError, DivisionByZero{
		OPERATORS operatorID;
		double result = parseFactorial();
		operatorID = getIDFromToken(Token);

		while (operatorID == OPERATORS.POW){
			getNextToken();
			double secondOperand = parseFactorial();
			result = calculateExpr(operatorID, result, secondOperand);
			operatorID = getIDFromToken(Token);
		}
	    return result;
	  }

	/**
	 * @brief Parse factorial operation. 
	 *   If suitable operator is not found, scan deeper (unary minus operation).
	 * @return Evaluated operation
	 */
	double parseFactorial() throws SyntaxError, MathError, DivisionByZero{
		OPERATORS operatorID;
		double result = parseUnaryMinus();
		// Unary minus is left-associated. First get '-', then operand
		operatorID = getIDFromToken(Token);
		while (operatorID == OPERATORS.FAC){
			getNextToken();
			result = calculateExpr(operatorID, result, 0.0); // Unary minus has one operand, simulate the other with zero
			operatorID = getIDFromToken(Token);
		}
	    return result;
	  }
	
	/**
	 * @brief Parse unary minus operation. 
	 *   If suitable operator is not found, scan deeper (functions).
	 * @return Evaluated operation
	 */
	  double parseUnaryMinus() throws SyntaxError, MathError, DivisionByZero
	  {
	    double result;
		OPERATORS operatorID;
		operatorID = getIDFromToken(Token);
	    if (operatorID == OPERATORS.SUB){ // Minus found
	      getNextToken(); // Get next token and revert sign
	      result = -parseFunction();
	    }
	    else // No unary minus
	    	result = parseFunction();

	    return result;
	    
	  }
	  
		/**
		 * @brief Parse function. 
		 *   If function name is not found, scan deeper (parenthesis).
		 * @return Evaluated function
		 */
	  double parseFunction() throws SyntaxError, MathError, DivisionByZero
	  {
	    double result;

	    if (TokenID == TOKENIDS.FUNCTION){
	      String funcName = Token;
	      getNextToken();
	      double funcArgument;
	      if (funcName.toUpperCase().equals("RAND")) // Random has no arguments, simulate with 0.0
	    	  funcArgument = 0.0;
	      else
	    	  funcArgument = parseParenthesis();
	      result = calcFunction(funcName, funcArgument); // Evaluate function
	    }
	    else
	    	result = parseParenthesis();

	    return result;
	  }
	  
	/**
	 * @brief Parse parenthesis. 
	 *   If no parenthesis found, scan deeper (Immediate or variable operator).
	 * @return Evaluated operation
	 */
	private double parseParenthesis() throws SyntaxError, MathError, DivisionByZero{		
	    if (Token.equals("(")){ // Left bracket found - this is start of new expression
	    	getNextToken(); 
	    	double result = parseAddSub(); // Start parsing from top again
	    	if (Token.equals(")")){ // Parenthesied expression ended
	    		getNextToken();
	    		return result;
	    	} // Missing right bracket - syntax error
	    	throw new SyntaxError();
	    }
	    return parseImmediate(); // No parenthesis found, lower the searching level
	}
	

	/**
	 * @brief Parse number or variable operators. 
	 *   If no immediate or variable is found, throw syntax error
	 * @return Evaluated immediate or variable
	 */
	double parseImmediate() throws SyntaxError{
		double result = 0.0;
		switch (TokenID){
			case IMMEDIATE:
				// Immediate found
				try{
					if (this.mode == MODE.BINARY) // Parse as binary
						result = Integer.parseInt(Token, 2);
					else if (this.mode == MODE.DECIMAL) // Parse as decimal
						result = Integer.parseInt(Token);
					else // Parse as double
						result = Double.parseDouble(Token);
				}catch(NumberFormatException e){
					throw new SyntaxError();
				}
				getNextToken();
				break;
		   case VARIABLE:
			   // Immediate found, evaluate it (independently on mode)
			   result = calcVariable(Token);
			   getNextToken();
			   break;
		   default:
			   throw new SyntaxError();

	    }
	    return result;
	  }
	  
	/**
	 * @brief Apply the given operator on operands.
	 *         If invalid operator is used, throw Syntax Error
	 * @return Operation result
	 * @throws SyntaxError, MathError, DivisionByZero
	 */
	double calculateExpr(OPERATORS operator, double left, double right) throws SyntaxError, MathError, DivisionByZero{
			switch(operator){
		    	case ADD: return aritLib.add(left, right);
		    	case SUB: return aritLib.sub(left,right);
		    	case MUL: return aritLib.mul(left, right);
		    	case DIV: return aritLib.div(left, right);
		    	case POW: return aritLib.pow(left, right);
		    	case FAC: return aritLib.fac((int)left);
		    	case AND: return logicLib.and((int)left, (int)right);
		    	case OR: return logicLib.or((int)left, (int)right);
		    	case NOT: return logicLib.not((int)left);
		    	case XOR: return logicLib.xor((int)left, (int)right);
		    	case MOD: return aritLib.Modulus((int)left, (int)right);

		    	default: throw new SyntaxError();
			}
	}
	
	/**
	 * @brief Evaluate passed function.
	 *        If invalid function name is used, throw Syntax Error
	 * @return Evaluated function
	 * @throws SyntaxError, MathError, DivisionByZero
	 */
	double calcFunction(String funcName, double funcArg) throws SyntaxError, MathError{
			switch(funcName.toUpperCase()){
				case "SQRT": return aritLib.sqrt(funcArg);
				case "LOG": return aritLib.log(funcArg);
				case "SIN": return gonLib.sin(funcArg);
				case "COS": return gonLib.cos(funcArg); 
				case "TG": return gonLib.tg(funcArg); 
				case "CTG": return gonLib.ctg(funcArg);
				case "RAND": return utilsLib.Random();
				default: throw new SyntaxError();
			}
	}

	/**
	 * @brief Evaluate variable.
	 *        If invalid variable name is used, throw Syntax Error
	 * @return Evaluated variable
	 * @throws SyntaxError
	 */
	double calcVariable(String varName) throws SyntaxError{
		String varNameUpper = varName.toUpperCase();
		
		switch(varNameUpper){
			case "E": return utilsLib.E;
			case "PI": return utilsLib.PI;
		}
		throw new SyntaxError();
	}

	  
	/**
	 * @brief Get token identifier from its String representation
	 *        If unknown operator is found, retusn OPERATORS.UNKNOWN
	 * @return Token identifier
	 */
	private OPERATORS getIDFromToken(String token){
		switch(token){
			case "+": return OPERATORS.ADD;
		    case "-": return OPERATORS.SUB;	
		    case "*": return OPERATORS.MUL;	
		    case "/": return OPERATORS.DIV;
		    case "%": return OPERATORS.MOD;
		    case "^": return OPERATORS.POW;
		    case "!": return OPERATORS.FAC;
		    case "AND": return OPERATORS.AND;
		    case "OR": return OPERATORS.OR;
		    case "NOT": return OPERATORS.NOT;
		    case "XOR": return OPERATORS.XOR;
		    default: return OPERATORS.UNKNOWN;
		}
	}

	/**
	 * @brief Determine if given character is a white one
	 *        (has ASCII code lesser 32)
	 * @param char Tested character
	 * @return true if the character is white else false
	 */
	boolean isWhiteChar(char testChar){
		return testChar > 0 && testChar <= 32;
	}

	/**
	 * @brief Determine if given character is a binary operator
	 *        Minus is not included as it can be unary as well.
	 * @param char Tested character
	 * @return true if the character is binary operator else false
	 */
	boolean isBinaryOperator(char testChar){
		return "+*/&|^%!".indexOf(testChar) != -1;
	}

	/**
	 * @brief Determine if given character is alphabetic or
	 *         an underscore
	 * @param char Tested character
	 * @return true if the character is alphabetic else false
	 */
	boolean isAlphabetic(char testChar){
		char lower = Character.toLowerCase(testChar);
		return "abcdefghijklmnopqrstuvwxyz_".indexOf(lower) != -1;
	}

	/**
	 * @brief Determine if given character is numeric or
	 *        a dot (for real numbers)
	 * @param char Tested character
	 * @return true if the character is digit or dot else false
	 */
	boolean isDigitOrDot(char testChar){
		return (testChar >= '0' && testChar <= '9') || testChar == '.';
	}

	/**
	 * @brief Determine if given character is numeric
	 * @param char Tested character
	 * @return true if the character is digit else false
	 */
	boolean isDigit(char testChar){
		return (testChar >= '0' && testChar <= '9');
	}
	  
	/**
	 * @brief Read next character from ExprParser parse input
	 */
	void readNextChar(){
		this.CurrentPosition++;
		if (this.CurrentPosition < this.Expression.length())
			this.CurrentChar = Expression.charAt(CurrentPosition);
		else
			CurrentChar = '\0'; // End of stream
	}	

	/**
	 * @brief Try to find next token in input stream. If forbidden
	 * 	      letter combination is found, throw SyntaxError.
	 * @throws SyntaxError
	 */
	void getNextToken() throws SyntaxError{
		this.TokenID = TOKENIDS.NONE;
		Token = ""; 
		
		// Ignore leading whitespace characters
		while (isWhiteChar(CurrentChar)){
			readNextChar();
		}
		if (CurrentChar == '\0'){ // End of input stream
			TokenID = TOKENIDS.SEPARATOR;
			return;
		}

		if (CurrentChar == '-'){ // Test unary minus
			TokenID = TOKENIDS.SEPARATOR;
			Token += CurrentChar;
			readNextChar();
			return;
		}
		
		// Test parenthesis
		if (CurrentChar == '(' || CurrentChar == ')'){
			TokenID = TOKENIDS.SEPARATOR;
			Token += CurrentChar;
			readNextChar();
			return;
		}

		// Test binary operators (except minus)
		if (isBinaryOperator(CurrentChar)){
			TokenID = TOKENIDS.SEPARATOR;
			while (isBinaryOperator(CurrentChar)){
				Token += CurrentChar;
				readNextChar();
			}
			return;
		}

		if (isDigitOrDot(CurrentChar)){ // Immediate value found
			TokenID = TOKENIDS.IMMEDIATE;
			while (isDigitOrDot(CurrentChar)){ // e.g. 2, 2.0 or 0.5
				Token += CurrentChar;
				readNextChar();
			}
			return;
		}
		
		// Test constants or functions
	    if (isAlphabetic(CurrentChar)) // Must start with a letter
	    {
	    	// Get whole constant or function identifier
	    	while (isAlphabetic(CurrentChar) || isDigit(CurrentChar)){ 
	    		Token += CurrentChar; 
	    		readNextChar();
	    	}

	      if (CurrentChar == '(') // Function found
	        TokenID = TOKENIDS.FUNCTION;
	      else // Variable (pi or e) found
	    	  TokenID = TOKENIDS.VARIABLE;
	      return;
	    }
	    
		// Nothing matched, this is syntax error
		TokenID = TOKENIDS.UNKNOWN;
		while (CurrentChar != '\0')
	    {  // Read the rest of input
			Token += CurrentChar;
			readNextChar();
	    }
	    throw new SyntaxError();
	}
}
