import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import math.*;

public class TestsArithmetic {

	private static final Arithmetic arth = new Arithmetic();

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@Before
	public void setUp() throws Exception {
		
	}

	@Test
	public void testAdd() {
		assertEquals(0.000, arth.add(0, 0), 3);
		assertEquals(8.000, arth.add(5, 3), 3);
		assertEquals(-2.000, arth.add(-5, 3), 3);
		assertEquals(9.009, arth.add(5.52, 3.4892), 3);
		assertEquals(5.030, arth.add(5, 0.03), 3);
	}
	
	@Test
	public void testSub() {
		assertEquals(0.000, arth.sub(0, 0), 3);
		assertEquals(2.000, arth.sub(5, 3), 3);
		assertEquals(-8.000, arth.sub(-5, 3), 3);
		assertEquals(2.031, arth.sub(5.52, 3.4892), 3);
		assertEquals(4.970, arth.sub(5, 0.03), 3);
	}
	
	@Test
	public void testMul() {
		assertEquals(0.000, arth.mul(0, 0), 3);
		assertEquals(0.000, arth.mul(1, 0), 3);
		assertEquals(0.000, arth.mul(0, 1), 3);
		assertEquals(6.290, arth.mul(1.258, 5), 3);
		assertEquals(-10.000, arth.mul(-1, 10), 3);
		assertEquals(0.000, arth.mul(0, -10), 3);
	}
	
	@Test
	public void testDiv() throws DivisionByZero {
		assertEquals(0.000, arth.div(0, 10), 3);
		assertEquals(1.000, arth.div(10, 10), 3);
		assertEquals(-1.000, arth.div(10, -10), 3);
		assertEquals(3.333, arth.div(10, 3), 3);
		assertEquals(2.750, arth.div(5.5, 2), 3);
	}
	
	@Test(expected = DivisionByZero.class)
	public void testDivException() throws DivisionByZero {
		arth.div(10, 0);
		fail("Should have thrown the DivisionByZero exception");
	}
	
	@Test
	public void testPow() {
		assertEquals(1.000, arth.pow(10, 0), 3);
		assertEquals(100.000, arth.pow(10, 2), 3);
		assertEquals(1.000, arth.pow(1, 10), 3);
		assertEquals(25.000, arth.pow(5, 2), 3);
		assertEquals(0.000, arth.pow(0, 100), 3);
		assertEquals(0.040, arth.pow(5, -2), 3);
		assertEquals(0.725, arth.pow(5, -0.2), 3);
		assertEquals(6.223015277861142E39, arth.pow(2.5, 100), -100);
	}
	
	@Test
	public void testSqrt() throws MathError {
		assertEquals(0.000, arth.sqrt(0), 3);
		//assertEquals("1.000", arth.sqrt("1", "10"));
		//assertEquals("258.000", arth.sqrt("258", "1"));
		assertEquals(2.236, arth.sqrt(5), 3);
		//assertEquals("1.495", arth.sqrt("5", "4"));
		//assertEquals("55.902", arth.sqrt("5", "0.4"));
		//assertEquals("0.447", arth.sqrt("5", "-2"));
	}
	
	/*@Test(expected = MathError.class)
	public void testSqrtException() throws MathError {
		arth.sqrt("10", "0");
		fail("Should have thrown the MathError exception");
	}*/
	
	@Test(expected = MathError.class)
	public void testSqrtExceptionImaginary() throws MathError {
		arth.sqrt(-5);
		fail("Should have thrown the MathError exception");
	}
	
	@Test
	public void testLog() throws MathError {
		assertEquals(1.000, arth.log(10), 3);
		assertEquals(0.354, arth.log(2.258974), 3);
	}
	
	@Test(expected = MathError.class)
	public void testLogException() throws MathError {
		arth.log(-5);
		fail("Should have thrown the MathError exception");
	}
	
	@Test(expected = MathError.class)
	public void testLogException0() throws MathError {
		arth.log(0);
		fail("Should have thrown the MathError exception");
	}
	
	@Test
	public void testLn() throws MathError {
		assertEquals(2.303, arth.ln(10), 3);
		assertEquals(0.815, arth.ln(2.258974), 3);
		assertEquals(1.000, arth.ln(2.7182818285), 3);
	}
	
	@Test(expected = MathError.class)
	public void testLnException0() throws MathError {
		arth.ln(0);
		fail("Should have thrown the MathError exception");
	}
	
	@Test(expected = MathError.class)
	public void testLnException() throws MathError {
		arth.ln(-50);
		fail("Should have thrown the MathError exception");
	}
	
	@Test
	public void testFac() throws MathError {
	    //< We are not implementing Gamma function, so no decimal factorial
		assertEquals(3628800.000, arth.fac(10), 3);
		assertEquals(6, arth.fac(3), 3);
		assertEquals(120, arth.fac(5), 3);
		//assertEquals("2.424", arth.fac("2.2"));
		assertEquals(1.000, arth.fac(0), 3);
		assertEquals(1.000, arth.fac(1), 3);
		//assertEquals("2.424", arth.fac("-2.2"));
	}
    
    @Test(expected = MathError.class)
	public void testFacException() throws MathError {
		arth.fac(-5);
		fail("Should have thrown the MathError exception");
	}
}
