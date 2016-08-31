//
//  PLLoginViewController.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol SNViewControllerKeyboard {
	func onWillShowKeyboard(notification: NSNotification)
	func onWillHideKeyboard(notification: NSNotification)
	func onTextFieldDidChange(notification: NSNotification)
}

class PLLoginViewController: UIViewController {

	
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var loginTextField: UITextField!
	@IBOutlet weak var passTextField: UITextField!
	@IBAction func loginButton(sender: AnyObject) {
	}
	@IBAction func forgotButton(sender: AnyObject) {
		let alert = UIAlertController(title: "We got your back!", message: "Enter below and we'll send your password!", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
		alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
			textField.placeholder = "Email"
		})
		self.presentViewController(alert, animated: true, completion: nil)
	}
	@IBAction func registerButton(sender: AnyObject) {
	}
	@IBOutlet weak var forgetView: UIView!
	@IBOutlet weak var loginView: UIView!
	
	@IBOutlet weak var registerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PLLoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PLLoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tap)
		
		roundImage(logoImage)
		loginTextField.textFieldLine(loginTextField)
		passTextField.textFieldLine(passTextField)
		loginView.layer.cornerRadius = 5
		
		self.hideKeyboardWhenTappedAround()
    }
		func keyboardWillShow(notification: NSNotification) {
		
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
		if view.frame.origin.y == 0{
		self.view.frame.origin.y -= keyboardSize.height
		}
		else {
		}
		}
		}
		
	func keyboardWillHide(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
				if view.frame.origin.y != 0 {
					self.view.frame.origin.y += keyboardSize.height
				}
		}
	}
	override func dismissKeyboard() {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}
	
	override func viewWillAppear(animated: Bool) {
		viewAppearAnimation(logoImage, duration: 0.5, delay: 0.2, flag: true)
		viewAppearAnimation(loginTextField, duration: 0.5, delay: 0.2, flag: true)
		viewAppearAnimation(passTextField, duration: 0.5, delay: 0.2, flag: true)
		viewAppearAnimation(loginView, duration: 0.5, delay: 0.2, flag: true)
	    viewAppearAnimation(forgetView, duration: 0.5, delay: 0.2, flag: true)
		viewAppearAnimation(registerView, duration: 0.5, delay: 0.2, flag: true)
	}
	
	override func viewWillDisappear(animated: Bool) {
		viewAppearAnimation(logoImage, duration: 0.5, delay: 0.2, flag: false)
		viewAppearAnimation(loginTextField, duration: 0.5, delay: 0.2, flag: false)
		viewAppearAnimation(passTextField, duration: 0.5, delay: 0.2, flag: false)
		viewAppearAnimation(loginView, duration: 0.5, delay: 0.2, flag: false)
		viewAppearAnimation(forgetView, duration: 0.5, delay: 0.2, flag: false)
		viewAppearAnimation(registerView, duration: 0.5, delay: 0.2, flag: false)
	}
	
	func roundImage(image: UIImageView) {
		image.layer.borderWidth = 0.1
		image.layer.masksToBounds = false
		image.layer.borderColor = UIColor.blackColor().CGColor
		image.layer.cornerRadius = image.frame.height/2
		image.clipsToBounds = true
	}
	
	func viewAppearAnimation(view: UIView, duration:NSTimeInterval, delay: NSTimeInterval, flag:Bool) {
		view.alpha = 0.0
		UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseOut, animations: {
			view.alpha = 1.0
			if flag{
				view.center.y -= self.view.bounds.height
			}else{
				view.center.y += self.view.bounds.height
			}
			}, completion: {_ in
				// Comletion
		})
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	func textFieldDidBeginEditing(textField: UITextField)  {
//		scrollView.setContentOffset(CGPointMake(0.0, 250.0), animated: true)
	}
	func textFieldDidEndEditing(textField: UITextField) {
//		scrollView.setContentOffset(CGPointMake(0.0, 0.0), animated: true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
}

extension UITextField {
	func textFieldLine(textField: UITextField) {
		let border = CALayer()
		let width = CGFloat(3.0)
		border.borderColor = UIColor.lightGrayColor().CGColor
		border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
		
		border.borderWidth = width
		textField.layer.addSublayer(border)
		textField.layer.masksToBounds = true
		
		textField.textColor = UIColor.lightGrayColor()
		textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
	}
}
