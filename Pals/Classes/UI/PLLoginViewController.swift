//
//  PLLoginViewController.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLLoginViewController: UIViewController {
	
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	private var currentTextField: PLTextField!

	@IBOutlet weak var animationView: UIView!
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var loginTextField: PLTextField!
	@IBOutlet weak var passTextField: PLTextField!
    
	@IBAction func loginButtonClicked(sender: AnyObject) {
        let userName = loginTextField.text!
        let password = passTextField.text!
        if userName.isEmpty {
            // show error message
			alertCalled("Login error!", mesage: "Please enter your login.")
        } else if password.isEmpty {
            // show error message
			alertCalled("Login error!", mesage: "Please enter your password.")
        } else {
//			spinner = UIActivityIndicatorView(frame: CGRectMake(view.bounds.width / 2, self.view.bounds.height / 2 + 35, 0, 0)) as UIActivityIndicatorView
			view.addSubview(spinner!)
			spinner!.startAnimating()
            PLFacade.login(userName, password: password, completion: { (error) in
                if error != nil {
                    // show error message
					self.alertCalled("Login error!", mesage: (error?.localizedDescription)!)
					self.spinner?.stopAnimating()
                } else {
                    self.showMainScreen()
					self.spinner?.stopAnimating()
                }
            })
        }
	}
	
	@IBAction func forgotButtonClicked(sender: AnyObject) {
//		self.spinner = UIActivityIndicatorView(frame: CGRectMake(view.bounds.width / 2, view.bounds.height / 2 + 35, 0, 0)) as UIActivityIndicatorView
		let alert = UIAlertController(title: "We got your back!", message: "Enter below and we'll send your password!", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
		alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
			textField.placeholder = "Email"
		})
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
			let textField = alert.textFields![0] as UITextField
			if (textField.text?.trim().isValidEmail)! {
				self.view.addSubview(self.spinner!)
				self.spinner!.startAnimating()
				PLFacade.sendPassword(textField.text!, completion: { (error) in
					self.alertCalled("Succes!", mesage: "Show password on your E-mail.")
					self.spinner?.stopAnimating()
				})
			} else {
				self.alertCalled("Incorrect email!", mesage: "Re-enter your email.")
			}
		}))
		presentViewController(alert, animated: true, completion: nil)
	}
	@IBAction func registerButtonClicked(sender: AnyObject) {
	}
	@IBAction func unwindToLoginClicked(sender: UIStoryboardSegue) {
	}
	
	func alertCalled(title: String, mesage: String) {
		let alert = UIAlertController(title: title, message: mesage, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	func showMainScreen() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
		presentViewController(vc, animated: true, completion: nil)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		loginTextField.delegate = self
		passTextField.delegate = self
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
		
		viewAppearLogo(logoImage, center: 0, alfa: 1.0, flag: true)
		viewAppearLogo(animationView, center: -view.bounds.height, alfa: 0.0, flag: true)
		
		hideKeyboardWhenTappedAround()
        PLFacade.sendPassword("ssds") { (error) in
            let title = (error != nil ? error?.localizedDescription : "success")
            let alert = UIAlertController(title: title, message: "", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
	
	func viewAppearLogo(view: UIView, center: CGFloat, alfa: CGFloat, flag: Bool) {
		view.alpha = alfa
		UIView.animateWithDuration(1, delay: 0.2, options: .CurveEaseOut, animations: {
			view.alpha = 1.0
			if flag{
				view.center.y = center
			}else{
				view.center.y += view.bounds.height
			}
			}, completion: {_ in
		})
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

extension PLLoginViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		let nextTag = textField.tag + 1
		if let nextResponder = textField.superview!.viewWithTag(nextTag) {
			nextResponder.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
			loginButtonClicked(self)
		}
		return false
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		currentTextField = nil
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		currentTextField = textField as! PLTextField
	}
	
}
