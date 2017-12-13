/**
 * @author xbenom01
 * @date 20.4.2016
 * @file Arithmetic.java
 * @brief Library containing arithmetic operation
 */

package math;

/**
 * @brief Class containing arithmetic methods
 */
public class Arithmetic {

	/**
	 * @brief Arithmetic addition
	 * @param a First addend
	 * @param b Second addend
	 * @return Number, a+b
	 */
	public double add (double a, double b)
	{
		return a + b;
	}

	/**
	 * @brief Arithmetic subtraction
	 * @param a First subtractor
	 * @param b Second subtractor
	 * @return Number, a-b
	 */
	public double sub (double a, double b)
	{
		return a - b;
	}
	
	/**
	 * @brief Arithmetic multiplication
	 * @param a First multiplicant
	 * @param b Second multiplicant
	 * @return Number, a*b
	 */
	public double mul (double a, double b)
	{
		return a * b;
	}
	
	/**
	 * @brief Arithmetic division
	 * @param a Divisor
	 * @param b Dividend
	 * @return Number, a/b
	 * @throws DivisionByZero when attempting to divide by 0 
	 */
	public double div (double a, double b) throws DivisionByZero
	{
		if (b == 0)
		{
			throw new DivisionByZero();
		}
		return a/b;
	}
	
	/**
	 * @brief Number to the power
	 * @param a Base
	 * @param b Exponent
	 * @return Number, a^b
	 */
	public double pow (double a, double b)
	{
		return Math.pow(a, b);
	}
	
	/**
	 * @brief Square root of number
	 * @param a Non-negative number
	 * @return Number, square root of input
	 * @throws MathError when input is negative
	 */
	public double sqrt (double a) throws MathError
	{
		if ( a < 0)
		{
			throw new MathError();
		}
		return Math.sqrt(a); 
	}
	
	/**
	 * @brief Logarithm base 10
	 * @param a Positive number
	 * @return Number, log10 of input
	 * @throws MathError when input is not positive
	 */
	public double log (double a) throws MathError
	{
		if (a <= 0)
		{
			throw new MathError();
		}
		return Math.log10(a);
	}
	
	/**
	 * @brief Natural logarithm
	 * @param a Input, positive number
	 * @return Number, log of a given number
	 * @throws MathError when input is not positive
	 */
	public double ln (double a) throws MathError
	{
		if (a <= 0)
		{
			throw new MathError();
		}
		return Math.log(a);
	}
	
	/**
	 * @brief Factorial
	 * @param a Non-negative integer
	 * @return Number, factorial of input
	 * @throws MathError when input is negative
	 */
	public double fac (int a) throws MathError
	{
		if (a < 0)
		{
			throw new MathError();
		}
		int result = 1;
        for (int i = 1; i <= a; i++) {
        	result *= i;
        }
        return result;		
	}
	
	/**
	 * @brief Modulus
	 * @param a Non-negative integer
	 * @param b Non-negative integer
	 * @return Number, a%b
	 */
	public int Modulus(int a, int b)
	{
		return a % b;
	}
}
