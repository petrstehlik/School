/**
 * @author xstude22
 * @file CalcButtons.java
 * @brief Contains class for button creation
 */

package gui;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.LinkedList;

import javax.swing.JButton;
import javax.swing.JLabel;

import control.ExprParser;
import math.*;



/**
 * @brief Class for button creation
 */
public class CalcButtons {
	public static final int BUTTONSIZE = 60; /*!< Button size in pixels */ 
	
	private int buttCount, boardWidth, boardHeight, height,width ;
	private JButton[] buttons;	
	private String[] charField;
	
	public LinkedList<String> expressionList;
	
	public static final String mysqrt  = new String("\u221A"); /*!< Square root unicode character */ 
	public static final String x2 = "x" + new String("\u00B2"); /*!< x letter with number 2 as upper index */ 
	public static final String xn = "x" + new String("\u207F"); /*!< x letter with n as upper index */
	public static final String pi = new String("\u03C0"); /*!< PI unicode character */
	public static final String superx = "10" + new String("\u02e3"); /*!< 10 with x as upper index */
	
	private ExprParser parser; /*!< Instance of expression parser */
	private String mode = "DEF";
	public boolean haveResult = false;
	
	/**
	 * @brief buttons texts for standard mode
	 */
	private String[] standardCharField = { 	"C","(",")","/",
											"7","8","9","-",
											"4","5","6","+",
											"1","2","3","*",
											"0"," ",".","="};
	/**
	 * @brief buttons texts for scientific mode
	 */
	private String[] extendedCharField = { 	x2,xn,"C","(",")","%","/",
											"x!",superx, mysqrt ,"7","8","9","-",
											"sin","cos","tg","4","5","6","+",
											"log","ln","ctg","1","2","3","*",
		   									"e",pi,"rand","0"," ",".","="};
	
	/**
	 * @brief buttons texts for programmer mode
	 */
	private String[] programmerCharField = { "BIN","DEC","C","%","/",
											 "AND","7","8","9","-",
											 "OR","4","5","6","+",
											 "NOT","1","2","3","*",
											 "XOR","0"," ",".","="};

	/**
	 * @brief specific groups of buttons with same attributes
	 */
	public String[] functionButtons = {"log", "ln", "sin", "cos", "tg","ctg"};
	public String[] logicalButtons = { "AND", "OR", "NOT", "XOR" };
	public String[] greenButtons = {"BIN","DEC","%","C","(",")","*","/","+","-"};
	public String[] decimalButtons = { ".", "DEC"};
	public String[] binaryButtons = { "DEC", "C", "=", "0", "1", "AND","OR","NOT","XOR"}; 
	public String[] numersButtons = { "0", "1", "2", "3", "4", "5","6","7","8","9"};
	
	/**
	 * @brief Create, set attributes and action listeners for buttons placed on main Frame.
	 * @param frame Instance of JFrame
	 * @param mode visible calculator mode
	 */
	public CalcButtons(MainFrame frame,String mode){
		parser = frame.parser;
		expressionList = new LinkedList<String>();
		
		switch(mode){
		case "standard":
			mode = "DEF";
			buttCount = 20;
			width = 4; height = 5;
			charField = standardCharField; 
			break;
		case "extended":
			mode = "DEF";
			buttCount = 35;
			width = 7; height = 5;
			charField = extendedCharField; 
			break;
		case "programmer":
			mode = "DEC";
			buttCount = 25;
			width = 5; height = 5;
			charField = programmerCharField; 
			break;	
		default:
			break;
		}
		buttons = new JButton[buttCount];
		boardWidth = width*BUTTONSIZE;
		boardHeight = height*BUTTONSIZE + 60;
		frame.getContentPane().setLayout(null);
		frame.setSize(boardWidth+5, boardHeight+50);
				
		addButtons(frame);	
	}
	
	/**
	 * @brief Add all buttons to Frame
	 * @param Parent fram object
	 */
	public void addButtons(MainFrame frame ){
		int i=0, boardWidhtPos = 0, boardHeightPos = 0;

		for(int y = 0; y < height; y++ ){
			for(int x = 0; x < width; x++ ){
				
				i = x + ( y*width );
				buttons[i] = new JButton(charField[i]);	
				boardHeightPos = y * BUTTONSIZE + BUTTONSIZE; // add textfield height
				boardWidhtPos = x * BUTTONSIZE;
				
				if(charField[i] == "0"){ 
					x++;
					buttons[i].setBounds(boardWidhtPos,  boardHeightPos, BUTTONSIZE*2, BUTTONSIZE);
				}else{
					buttons[i].setBounds(boardWidhtPos,  boardHeightPos, BUTTONSIZE, BUTTONSIZE);
				}
				
				setAttributes(buttons[i], frame);
				setActionListener(buttons[i], frame.textField, frame.errLabel);
				frame.getContentPane().add(buttons[i]);
			}
		}
	}
	
	/**
	 * @brief Set specific button properties
	 * @param button Instance of JButton
	 * @param frame Instance of MainFrame 
	 */
	private void setAttributes(JButton button, MainFrame frame){
		
		if(button.getText() == "=" ){
			button.setForeground(Color.BLACK);
			button.setBackground(Color.LIGHT_GRAY);
		}else if(isSpecificButton(button.getText(), greenButtons)){
			button.setForeground(Color.BLACK);
			button.setBackground(new Color(80,255,185));
		}else if(button.getText() == "DEC" ){
			button.setBackground(new Color(14,80,170));
		}else{
			button.setForeground(Color.WHITE);
			button.setBackground(Color.DARK_GRAY);
		}
		
		button.setFont(new Font("Tahoma", Font.PLAIN, 20));
		button.setBorder(null);
		button.setFocusable(true);
		button.addKeyListener(frame);
	};
	
	/**
	 * @brief Set action listener
	 * @param button Instance of JButton
	 * @param textField Instance of JLabel 
	 * @param errLabel Instance of JLabel
	 */
	private void setActionListener(JButton button, final JLabel textField, final JLabel errLabel){
		button.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				errLabel.setText("");
				String text = textField.getText();
				String tmp = "";	
				
				JButton butName = (JButton) e.getSource();
				String bText = butName.getText(); 
				
				if(bText == x2){
					tmp = "^2";
				}else if(bText == xn){
					tmp = "^";
				}else if(bText == mysqrt){
					tmp = "sqrt(";
				}else if(bText == "x!"){	
					tmp = "!";
				}else if(bText == superx){
					tmp = "10^";
				}else if(bText == "rand"){
					tmp = "rand()";
				}else if(bText == pi){
					tmp = "PI";
				}else if(bText == "C"){
					if(!expressionList.isEmpty()){
						String rem = expressionList.removeLast();
						if(text.length() - rem.length() > 0){
							text = text.substring(0, text.length() - rem.length());
							textField.setText(text);
						}
					}else if(text.length() > 0){
			        	if(text.length() > 0){
			        		textField.setText(text.substring(0, text.length()-1));
			        	}
					}
					return;
				}else if(isSpecificButton(bText, functionButtons)){	
					tmp = butName.getText()+"(";
				}else if(isSpecificButton(bText, logicalButtons)){	
					tmp = " "+butName.getText()+" ";	
				}else if(bText == "BIN"){
					try {
						setBinaryMode();
						expressionList.clear();
						String result = parser.dec2bin(text);
						expressionList.add(result);
						textField.setText(result);
					} catch (NumberFormatException e1) {
						errLabel.setText("Can not convert to binary");
					}
					return;
				}else if(bText == "DEC"){
					try {
						setDecadicMode();
						expressionList.clear();
						String result = parser.bin2dec(text);
						expressionList.add(result);
						textField.setText(result);
					} catch (NumberFormatException e1) {
						errLabel.setText("Can not convert to decimal");
					}
					return;
				}else if(bText == "="){
					countResult(textField, errLabel);
					return;
				}else if(isSpecificButton(bText, numersButtons)){
					if(haveResult){
						expressionList.clear();
						text = "";
					}
					haveResult = false;
					tmp = butName.getText();
				}else{
					tmp = butName.getText();
					haveResult = false;
				}
				
				if(text.length() < 32 ){
					expressionList.add(tmp);
					text += tmp;
					textField.setText(text);
				}
			}
		});
	}
	
	/**
	 * @brief Determine if the button pass selected group 
	 * @param buttonText Text of the checked button
	 * @param array of specific group of buttons 
	 * @return true if text does group button else false
	 */	
	public boolean isSpecificButton(String buttonText, String[] group ){
		for(int i = 0; i < group.length; i++ ){
			if(buttonText == group[i])
				return true;
		}
		return false;
	}
		
	/**
	 * @brief Enable/Disable buttons for decimal mode.
	 */
	public void setDecadicMode(){
		mode = "DEC";
		JButton btn = getButtonByName("DEC");
		btn.setBackground(new Color(14,80,170));
		btn = getButtonByName("BIN");
		btn.setBackground(new Color(80,255,185));
		
		for(int i = 0; i < buttCount; i++ ){
			if(buttons[i] != null ){
				if(isSpecificButton(buttons[i].getText(), decimalButtons))
					buttons[i].setEnabled(false);
				else
					buttons[i].setEnabled(true);
			}
		}
	}
	
	/**
	 * @brief Enable/Disable buttons for binary mode
	 */
	private void setBinaryMode(){
		mode = "BIN";
		JButton btn = getButtonByName("BIN");
		btn.setBackground(new Color(14,80,170));
		btn = getButtonByName("DEC");
		btn.setBackground(new Color(80,255,185));
		
		for(int i = 0; i < buttCount; i++ ){
			if(buttons[i] != null ){
				if(!isSpecificButton(buttons[i].getText(), binaryButtons))
					buttons[i].setEnabled(false);
				else
					buttons[i].setEnabled(true);
			}
		}
	}
	
	
	/**
	 * @brief Get button by its name attribute
	 * @param name Name which will be searched
	 * @return Instance of matched button
	 */
	public JButton getButtonByName(String name){
		for(int i = 0; i < buttCount; i++){
			if(buttons[i] != null && buttons[i].getText() == name){
				return buttons[i];
			}
		}
		return null;
	}
	
	/**
	 * @brief Call parser and display the result on screen
	 * @param textField Instance of JLabel
	 * @param errLabel Instance of JLabel
	 */
	public void countResult(JLabel textField, JLabel errLabel){
		String result = "";
		try{
			if(mode == "BIN"){
				result = parser.parse(textField.getText(), parser.modes.BINARY);
			} else if (mode == "DEC"){
				result = parser.parse(textField.getText(), parser.modes.DECIMAL);
			} else {
				result = parser.parse(textField.getText());
			}
			expressionList.clear();
			expressionList.add(result);
			haveResult = true;
			textField.setText(result);
		}catch(control.SyntaxError err){
			errLabel.setText("Syntax Error");
		}catch(MathError err){
			errLabel.setText("Math Error");
		}catch(DivisionByZero err){
			errLabel.setText("Division By Zero");
		}
	}
	
}
