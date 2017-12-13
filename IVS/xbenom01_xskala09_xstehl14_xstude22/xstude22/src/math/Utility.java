/**
 * @author xbenom01 
 * @date 21.4.2016
 * @file Utility.java
 * @brief Utility library. Contains predefined constants and Random() method
 */
package math;

import java.util.Random;

/**
 * @brief Class providing other numeric methods and predefined constants
 */
public class Utility {

	public static final double E = 2.71828182845904523536; /*!< Euler constant */
	public static final double PI = 3.14159265358979323846; /*!< PI constant */
	public static final Random rngGenerator = new Random(); /*!< Generate random number */
	
	/**
	 * @brief Generate random number in range <0;1)
	 */	
	public double Random()
	{
		return rngGenerator.nextDouble();
	}
}
