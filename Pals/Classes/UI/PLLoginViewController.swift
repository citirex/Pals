//
//  PLLoginViewController.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLLoginViewController: UIViewController {
	
	var spinner: UIActivityIndicatorView?

	@IBOutlet weak var animationView: UIView!
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var loginTextField: UITextField!
	@IBOutlet weak var passTextField: UITextField!
    
	@IBAction func loginButtonClicked(sender: AnyObject) {
        let userName = loginTextField.text!
        let password = passTextField.text!
        if userName.isEmpty {
            // show error message
			alertCalled("Please enter your login.")
        } else if password.isEmpty {
            // show error message
			alertCalled("Please enter your password.")
        } else {
			self.spinner = UIActivityIndicatorView(frame: CGRectMake(self.view.bounds.width / 2, self.view.bounds.height / 2 - 35, 0, 0)) as UIActivityIndicatorView
			self.view.addSubview(self.spinner!)
			self.spinner!.startAnimating()
            PLFacade.login(userName, password: password, completion: { (error) in
                if error != nil {
                    // show error message
					self.alertCalled("Wrong user name or password.")
                } else {
                    self.showMainScreen()
					
//			self.spinner = UIActivityIndicatorView(frame: CGRectMake(self.view.bounds.width / 2, self.view.bounds.height / 2 - 35, 0, 0)) as UIActivityIndicatorView
//					self.view.addSubview(self.spinner!)
//					self.spinner!.startAnimating()
                }
            })
        }
	}
	@IBAction func forgotButtonClicked(sender: AnyObject) {
		self.spinner = UIActivityIndicatorView(frame: CGRectMake(self.view.bounds.width / 2, self.view.bounds.height / 2 - 35, 0, 0)) as UIActivityIndicatorView
		let alert = UIAlertController(title: "We got your back!", message: "Enter below and we'll send your password!", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
			(alert: UIAlertAction!) -> Void in
			self.view.addSubview(self.spinner!)
			self.spinner!.startAnimating()
		}))
		alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
			textField.placeholder = "Email"
		})
		self.presentViewController(alert, animated: true, completion: nil)
	}
	@IBAction func registerButtonClicked(sender: AnyObject) {
	}
	@IBAction func unwindToLoginClicked(sender: UIStoryboardSegue) {
	}
	
	func alertCalled(mesage: String) {
		let alert = UIAlertController(title: "Error!", message: mesage, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	func showMainScreen() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
		
		viewAppearLogo(logoImage, flag: true)
		viewAppearAnimation(animationView, duration: 1, delay: 0.2, flag: true)
		
		self.hideKeyboardWhenTappedAround()
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
