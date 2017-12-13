/**
 * @author xbenom01
 * @date 20.4.2016
 * @file Goniometric.java
 * @brief Library containing goniometric operation
 */
package math;

/**
 * @brief  Class containing goniometric methods
 */
public class Goniometric {

	/**
	 * @brief Calculate sine function
	 * @param a Real number in radians
	 * @return Sine of a
	 */
	public double sin (double a)
	{
		return Math.sin(a);
	}
	
	/**
	 * @brief Calculate cosine function
	 * @param a Real number in radians
	 * @return Cosine of a
	 */
	public double cos (double a)
	{
		return Math.cos(a);
	}
	
	/**
	 * @brief Calculate tangent function
	 * @param a Real number in radians
	 * @return Tangent of a
	 */
	public double tg (double a)
	{
		return Math.tan(a);
	}
	
	/**
	 * @brief Calculate cotangent function
	 * @param a Real number in radians
	 * @return Cotangent of a
	 */
	public double ctg (double a) throws MathError
	{
		if (a % Math.PI == 0)
		{
			throw new MathError();
		}
		return Math.cos(a)/Math.sin(a);
	}
}
