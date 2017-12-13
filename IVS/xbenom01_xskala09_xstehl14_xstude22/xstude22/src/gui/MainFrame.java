/**
 * @author xstude22 
 * @file MainFrame.java
 * @brief Contains MainFrame class
 */
package gui;

import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

import javax.swing.SwingConstants;

import control.ExprParser;

import java.awt.Font;

/**
 * @brief Creates the main window and all its components  
 */
public class MainFrame extends JFrame implements KeyListener{
	
	public ExprParser parser; /*!< Instance of expression parser */
	
	private JMenuItem menuItemStand, menuItemScient, menuItemProg;  
	
	public static final int BUTTONSIZE = 60; /*!< Button size in pixels */ 
	public int positionX = 200; int positionY = 200;

	public JLabel textField;
	public JLabel errLabel;

	CalcButtons buttons;
	
	/**
	 * @brief Constructor of MainFrame
	 * @param parser Instance of expression parser
	 */
	public MainFrame(ExprParser parser) {
		this.parser = parser;
		setTitle("Calculator");
		setResizable(false);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(positionX, positionY, 245, 410);
		setFocusable(true);
		addKeyListener(this);
		
		
		setJMenuBar(createMenu());
		setModeStandard();
	
	}
	
	/**
	 * @brief Creates menu
	 * @return New menu
	 */
	private JMenuBar createMenu(){
		menuItemStand = new JMenuItem("standard");
		menuItemStand.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				 menuItemStand.setBackground(new Color(80,255,185));
				 menuItemScient.setBackground(Color.LIGHT_GRAY);
				 menuItemProg.setBackground(Color.LIGHT_GRAY);
				 setModeStandard();
			}
		});
		
		menuItemScient = new JMenuItem("scientific");
		menuItemScient.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				menuItemStand.setBackground(Color.LIGHT_GRAY);
				menuItemScient.setBackground(new Color(80,255,185));
				menuItemProg.setBackground(Color.LIGHT_GRAY);
				setModeScient();
			}
		});
		
		menuItemProg = new JMenuItem("programmer");	
		menuItemProg.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				 menuItemStand.setBackground(Color.LIGHT_GRAY);
				 menuItemScient.setBackground(Color.LIGHT_GRAY);
				 menuItemProg.setBackground(new Color(80,255,185));
				 setModeProgram();
			}
		});
		
		JMenuItem exit = new JMenuItem("Exit");
		exit.setBackground(Color.LIGHT_GRAY);
		exit.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				System.exit(0);
			}
		});
		
		JMenu folder = new JMenu("Show"); 
		folder.add(menuItemStand);
		folder.add(menuItemScient);
		folder.add(menuItemProg);
		folder.add(exit);
		
		JMenuBar menu = new JMenuBar();
		menu.add(folder);
		return menu;
	}
	
	/**
	 * @brief Set standard calculator mode
	 */
	public void setModeStandard(){
		int width = 4;
		getContentPane().removeAll();
		createTextField(width*BUTTONSIZE, BUTTONSIZE/3, 2*BUTTONSIZE/3);
		buttons = null;
		buttons = new CalcButtons(this, "standard");		
	}
	
	/**
	 * @brief Set scientific calculator mode
	 */
	public void setModeScient(){
		int width = 7;
		getContentPane().removeAll();
		createTextField(width*BUTTONSIZE, BUTTONSIZE/3, 2*BUTTONSIZE/3);
		buttons = null;
		buttons = new CalcButtons(this, "extended");
	}
	
	/**
	 * @brief Set programmer calculator mode
	 */
	public void setModeProgram(){
		int width = 5;
		getContentPane().removeAll();
		createTextField(width*BUTTONSIZE, BUTTONSIZE/3, 2*BUTTONSIZE/3);
		buttons = null;
		buttons = new CalcButtons(this, "programmer");
		buttons.setDecadicMode();
	}
	
	/**
	 * @brief Create a new instance of JLabel
	 * @param width Width of JLabel in pixels
	 * @param labelHeight Height of JLabel in pixels
	 * @param textHeight Text height
	 */
	public void createTextField(int width, int labelHeight, int textHeight ){
		errLabel = new JLabel("");
		errLabel.setFont(new Font("Tahoma", Font.PLAIN, 15));
		errLabel.setBackground(Color.WHITE);
		errLabel.setOpaque(true);
		errLabel.setBounds(0, 0, width, labelHeight);
		errLabel.setHorizontalAlignment(SwingConstants.RIGHT);
		getContentPane().add(errLabel);
		errLabel.setBorder(null);
		errLabel.setFocusable(true);
		errLabel.addKeyListener(this);
		
		textField = new JLabel("");
		textField.setFont(new Font("Tahoma", Font.PLAIN, 22));
		textField.setBounds(0, labelHeight, width, textHeight);
		getContentPane().add(textField);
		textField.setHorizontalAlignment(SwingConstants.RIGHT);
		textField.setBackground(Color.WHITE);
		textField.setOpaque(true);
		textField.setBorder(null);
		textField.setFocusable(true);
		textField.addKeyListener(this);
	}

	/**
	 * @briev override key pressed action 
	 */
	@Override
	public void keyPressed(KeyEvent evt) {
		if(evt.getKeyCode() == KeyEvent.VK_ENTER){
			errLabel.setText("");
        	buttons.countResult(textField, errLabel);	
        } else if(evt.getKeyCode() == KeyEvent.VK_BACK_SPACE){
        	String tmpText = textField.getText();
        	if(tmpText.length() > 0){
        		textField.setText(tmpText.substring(0, tmpText.length()-1));
        	}
        } else if(isNumber(evt)){
        	String tmpText = textField.getText();
        	if(buttons.haveResult){
        		buttons.expressionList.clear();
        		tmpText = "";	
			}
        	if(tmpText.length()< 32){
	        	tmpText += evt.getKeyChar();   	
			}
			textField.setText(tmpText);
			buttons.haveResult = false;
			
        } else if(isAllowedKey(evt)){
        	String tmpText = textField.getText();
        	tmpText += evt.getKeyChar();
        	textField.setText(tmpText);
			buttons.haveResult = false;
        }
	}

	@Override
	public void keyReleased(KeyEvent e) {
	}

	@Override
	public void keyTyped(KeyEvent e) {
	}

	/**
	 * @brief Specify array of numeric keys witch are available in calculator
	 * @param evt Instance of KeyEvent
	 * @return true if event meet requirements else false
	 */
	private boolean isNumber(KeyEvent evt){
		int keyInput[] = { KeyEvent.VK_0, KeyEvent.VK_1, KeyEvent.VK_2, KeyEvent.VK_3, KeyEvent.VK_4,
				           KeyEvent.VK_5, KeyEvent.VK_6, KeyEvent.VK_7, KeyEvent.VK_8, KeyEvent.VK_9,
				           KeyEvent.VK_NUMPAD0, KeyEvent.VK_NUMPAD1, KeyEvent.VK_NUMPAD2, KeyEvent.VK_NUMPAD3, 
				           KeyEvent.VK_NUMPAD4, KeyEvent.VK_NUMPAD5, KeyEvent.VK_NUMPAD6, 
				           KeyEvent.VK_NUMPAD7, KeyEvent.VK_NUMPAD8, KeyEvent.VK_NUMPAD9 };
		for(int i  = 0; i < keyInput.length ;  i++){
			if(evt.getKeyCode() == keyInput[i]){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @brief Specify array of keys witch are available in calculator
	 * @param evt Instance of KeyEvent
	 * @return true if event meet requirements else false
	 */
	private boolean isAllowedKey(KeyEvent evt){
		int keyInput[] = { KeyEvent.VK_ADD, KeyEvent.VK_SUBTRACT , KeyEvent.VK_MULTIPLY , KeyEvent.VK_DIVIDE ,KeyEvent.VK_PERIOD};
		for(int i  = 0; i < keyInput.length ;  i++){
			if(evt.getKeyCode() == keyInput[i]){
				return true;
			}
		}
		return false;
	}
}

