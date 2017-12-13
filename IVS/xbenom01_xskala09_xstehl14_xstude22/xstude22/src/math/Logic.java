/**
 * @author xbenom01
 * @date 20.4.2016
 * @file Logic.java
 * @brief Library containing logic operation
 */
package math;

/**
 * @brief Class performing logical operations.
 */
public class Logic {

	/**
	 * @brief Apply bitwise AND on operands
	 * @param a Number, left operand
	 * @param b Number, right operand
	 * @return Result of bitwise AND
	 */
	public int and (int a, int b)
	{
		return a & b;
	}
	
	/**
	 * @brief Apply bitwise OR on operands
	 * @param a Number, left operand
	 * @param b Number, right operand
	 * @return Result of bitwise OR
	 */
	public int or (int a, int b)
	{
		return a | b;
	}
	
	/**
	 * @brief Apply bitwise XOR on operands
	 * @param a Number, left operand
	 * @param b Number, right operand
	 * @return Result of bitwise XOT
	 */
	public int xor (int a, int b)
	{
		return a ^ b;
	}
	
	/**
	 * @brief Apply bitwise NOT on operand
	 * @param a Number to be negated
	 * @return Result of bitwise NOT
	 */
	public int not (int a)
	{
		return ~a;
	}
}
