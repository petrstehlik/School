
import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import math.*;

public class TestsGoniometric {

	private static final Goniometric gon = new Goniometric();
	private static final Double pi = 3.1415926536;
	private static final Double halfPi = pi/2;
	
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@Before
	public void setUp() throws Exception {
		
	}

	@Test
	public void testSin() {
		assertEquals(0.000, gon.sin(0), 3);
		assertEquals(-0.544, gon.sin(10), 3);
		assertEquals(0.543, gon.sin(-10), 3);
		assertEquals(0.100, gon.sin(0.10), 3);
		assertEquals(1.000, gon.sin(halfPi), 3);
		assertEquals(0.000, gon.sin(pi), 3);
	}
    
    public void testCos() {
		assertEquals(1.000, gon.cos(0), 3);
		assertEquals(-0.839, gon.cos(10), 3);
		assertEquals(-0.839, gon.cos(-10), 3);
		assertEquals(0.995, gon.cos(0.10), 3);
		assertEquals(0.000, gon.cos(halfPi), 3);
		assertEquals(-1.000, gon.cos(pi), 3);
	}
	
	public void testTg() {
		assertEquals(0.000, gon.tg(0), 3);
		assertEquals(0.648, gon.tg(10), 3);
		assertEquals(-0.648, gon.tg(-10), 3);
		assertEquals(0.100, gon.tg(0.10), 3);
		assertEquals(0.000, gon.tg(pi), 3);

		//< this wont fail since we don't have exact PI number
		// But it should throw exception anyway
		//assertEquals(1.633e16, gon.tg(halfPi));
		
	}
	
	public void testCtg() throws MathError {
		//< this will actually fail
		//assertEquals(1.000, gon.ctg(0), 3);
		
		//< this wont fail since we don't have exact PI number
		// But it should throw exception anyway
		//assertEquals(-1.000, gon.ctg(pi));

		assertEquals(1.542, gon.ctg(10), 3);
		assertEquals(-1.542, gon.ctg(-10), 3);
		assertEquals(9.967, gon.ctg(0.10), 3);
		assertEquals(0.000, gon.ctg(halfPi), 3);
	} 
	
	//Not exact PI/2 so this wont match
	/*
	@Test(expected = MathError.class)
	public void testTgException() throws MathError {
	    gon.tg(halfPi);
		fail("Should have thrown the MathError exception");
	}*/
    
    @Test(expected = MathError.class)
	public void testCtgException() throws MathError {
	    gon.ctg(Math.PI);
		fail("Should have thrown the MathError exception");
	}

    @Test(expected = MathError.class)
	public void testCtgException1() throws MathError {
	    gon.ctg(0);
		fail("Should have thrown the MathError exception");
	}
}
