import java.awt.EventQueue;

import control.*;
import gui.MainFrame;

/**
 * 
 * @author xstude22 
 * @date 11.4.2016
 * @file Calculator.java
 * @brief Main class of  project Calculator.
 *  
 */
public class Calculator {

	private MainFrame frame;
	private ExprParser parser; 

	/**
	 * Create the application.
	 */
	public Calculator() {
		parser = new ExprParser();
		frame = new MainFrame(parser);
	}
	
	/**
	 * @brief Launch the application.
	 * @param args Commandline arguments
	 */
	public static void main(final String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					if (args.length > 0 && args[0].equals("-d")){ // Debug mode
						ExprParser parser = new ExprParser();
						if (args.length > 1)
							parser.debugMode(args[1]); // Expression from commandline
						else
							parser.debugMode(); // Interactive debug mode
						System.exit(0);
					}
					Calculator window = new Calculator();
					window.frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				} catch (control.SyntaxError e) {
					e.printStackTrace();
				} catch (math.MathError e) {
					e.printStackTrace();
				} catch (math.DivisionByZero e) {
					e.printStackTrace();
				}
			}
		});
	}
}
