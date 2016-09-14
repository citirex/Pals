//
//  PLLoginViewController.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLLoginViewController: PLViewController {
	
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	private var currentTextField: PLTextField!

	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var loginTextField: PLTextField!
	@IBOutlet weak var passTextField: PLTextField!
    
    @IBOutlet var loginViewBotC: NSLayoutConstraint?
    @IBOutlet var logoTopC: NSLayoutConstraint?
    
	@IBAction func loginButtonClicked(sender: AnyObject) {
        let userName = loginTextField.text!
        let password = passTextField.text!
        if userName.isEmpty {
//			PLShowAlert("Login error!", message: "Please enter your login.")
        } else if password.isEmpty {
//			PLShowAlert("Login error!", message: "Please enter your password.")
        } else {
			spinner!.startAnimating()
            PLFacade.login(userName, password: password, completion: { (error) in
                if error != nil {
//					PLShowAlert("Login error!", message: (error?.localizedDescription)!)
					PLShowAlert(message: "Wrong Username/Password!")
					self.spinner?.stopAnimating()
                } else {
                    self.showMainScreen()
					self.spinner?.stopAnimating()
                }
            })
        }
	}
	
	@IBAction func forgotButtonClicked(sender: AnyObject) {
		let alert = UIAlertController(title: "We got your back!", message: "Enter below and we'll send your password!", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
		alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
			textField.placeholder = "Email"
		})
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
			let textField = alert.textFields![0] as UITextField
			if (textField.text?.trim().isValidEmail)! {
				self.spinner!.startAnimating()
				PLFacade.sendPassword(textField.text!, completion: { (error) in
					var message = ""
					if error == nil {
						message = "Sent!"
					} else {
						message = (error?.localizedDescription)!
					}
                    PLShowAlert(message: message)
					self.spinner?.stopAnimating()
				})
			} else {
                PLShowAlert(message: "This Email doesn't exist!")
			}
		}))
		presentViewController(alert, animated: true, completion: nil)
	}
	@IBAction func registerButtonClicked(sender: AnyObject) {
	}
    
    // MARK: - Navigation
    
	@IBAction func unwindToLoginClicked(sender: UIStoryboardSegue) {
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
		
		anime()
		
		hideKeyboardWhenTappedAround()
        }
	
	
		func anime() {
			self.logoTopC?.constant = (UIScreen.mainScreen().bounds.height / 2) - (self.logoImage.bounds.height / 2)
			self.loginViewBotC!.constant = -self.loginView.bounds.height
			self.view.layoutIfNeeded()
			
			UIView.animateWithDuration(1, delay: 2.2, options: .CurveEaseOut, animations: {
				self.loginViewBotC?.constant = 0
				self.logoTopC?.constant = 50
					self.view.layoutIfNeeded()
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
