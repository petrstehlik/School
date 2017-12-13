
import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import math.*;

public class TestsLogic {

	private static final Logic log = new Logic();

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@Before
	public void setUp() throws Exception {
		
	}

	@Test
	public void testAnd() {		
		assertEquals(8, log.and(10, 12));
		assertEquals(0, log.and(0, 0));
		assertEquals(0, log.and(8, 2));
		assertEquals(1, log.and(7, 1));

		//< I am not quite sure how it should be represented
		assertEquals(0, log.and(1, 0));
	}
	
	@Test
	public void testOr() {
		assertEquals(14, log.or(10, 12));
		assertEquals(0, log.or(0, 0));
		assertEquals(10, log.or(8, 2));

		//< I am not quite sure how it should be represented
		assertEquals(1, log.or(1, 0));
	}
	
	@Test
	public void testXor() {
    	assertEquals(6, log.xor(10, 12));
		assertEquals(0, log.xor(0, 0));
		assertEquals(10, log.xor(8, 2));
		assertEquals(6, log.xor(7, 1));

		//< I am not quite sure how it should be represented
		assertEquals(1, log.xor(1, 0));
	}
	
	/*
	* @brief Test NOT function
	*
	*/
	@Test
	public void testNot() {
		assertEquals(-16, log.not(15));
		assertEquals(-4, log.not(3));
		assertEquals(-3, log.not(2));
	}

	@Test
    public void complexTests() {
        assertEquals(2, log.and(log.or(4, 10),log.not(13)));
        assertEquals(-7, log.not(log.xor(10, 12)));
        assertEquals(-12, log.xor(log.or(4, 10),log.not(5)));
    }
	
	/*@Test(expected = NotBinary.class)
	public void testNotBinary() {
		log.and("0e10", "0e10");
		fail("Should have thrown the NotBinary exception");
	}

    @Test(expected = NotBinary.class)
	public void testNotBinary1() {
		log.or("0e10", "0e10");
		fail("Should have thrown the NotBinary exception");
	}
	
	@Test(expected = NotBinary.class)
	public void testNotBinary2() {
		log.xor("0.1", "0e10");
		fail("Should have thrown the NotBinary exception");
	}
	
	@Test(expected = NotBinary.class)
	public void testNotBinary3() {
		log.not("10 ");
		fail("Should have thrown the NotBinary exception");
	}*/

}
