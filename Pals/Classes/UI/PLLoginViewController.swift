//
//  PLLoginViewController.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLLoginViewController: UIViewController {

	@IBOutlet weak var animationView: UIView!
	
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var loginTextField: UITextField!
	@IBOutlet weak var passTextField: UITextField!
	@IBAction func loginButton(sender: AnyObject) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
		self.presentViewController(vc, animated: true, completion: nil)
	}
	@IBAction func forgotButton(sender: AnyObject) {
		let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(self.view.bounds.width / 2, self.view.bounds.height / 2 - 35, 0, 0)) as UIActivityIndicatorView
		let alert = UIAlertController(title: "We got your back!", message: "Enter below and we'll send your password!", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
			(alert: UIAlertAction!) -> Void in
			self.view.addSubview(spinner)
			spinner.startAnimating()
		}))
		alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
			textField.placeholder = "Email"
		})
		self.presentViewController(alert, animated: true, completion: nil)
	}
	@IBAction func registerButton(sender: AnyObject) {
	}
	@IBOutlet weak var registerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
		
//		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PLLoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PLLoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
		
		viewAppearLogo(logoImage, flag: true)
		viewAppearAnimation(animationView, duration: 1, delay: 0.2, flag: true)
		
		self.hideKeyboardWhenTappedAround()
    }
//	func keyboardWillShow(notification: NSNotification) {
//		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//				if view.frame.origin.y == 0{
//					self.view.frame.origin.y -= keyboardSize.height
//				}
//		}
//	}
//	func keyboardWillHide(notification: NSNotification) {
//		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//				if view.frame.origin.y != 0 {
//					self.view.frame.origin.y += keyboardSize.height
//				}
//		}
//	}

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
	
	func viewAppearLogo(view: UIView, flag: Bool) {
		UIView.animateWithDuration(1, delay: 0.2, options: .CurveEaseOut, animations: {
			view.alpha = 1.0
			if flag{
				view.center.y = 0
			}else{
				view.center.y += self.view.bounds.height
			}
			}, completion: {_ in
				// Comletion
		})
	}
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
    }

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
