//
//  PLLoginViewController.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLLoginViewController: PLViewController {
	
	@IBOutlet weak var mySpinner: UIActivityIndicatorView!
	private var currentTextField: PLFormTextField!

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var textFieldsView: UIView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var loginTextField: PLFormTextField!
	@IBOutlet weak var passTextField: PLFormTextField!
	@IBOutlet var registerButton: UIButton!
    
	@IBOutlet var logoCenterXC: NSLayoutConstraint!
    @IBOutlet var loginViewBotC: NSLayoutConstraint?
	@IBOutlet var registerBotC: NSLayoutConstraint!
	@IBOutlet var logoBottomC: NSLayoutConstraint!
	
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
	@IBAction func loginButtonClicked(sender: AnyObject) {
		loginToMainScreen()
	}
	
	@IBAction func forgotButtonClicked(sender: AnyObject) {
		
		let alert = UIAlertController(title: "We got your back!", message: "Enter below and we'll send your password!", preferredStyle: UIAlertControllerStyle.Alert)
        
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        let forgotAction = UIAlertAction(title: "OK", style: .Default, handler: {[unowned self] (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            NSNotificationCenter.defaultCenter().removeObserver(textField)
            
            if textField.text!.trim().isValidEmail {
                self.mySpinner!.startAnimating()
                PLFacade.sendPassword(textField.text!, completion: { (error) in
                    if error == nil {
                        PLShowAlert(title:"A new generated password has been sent to your email.")
                    } else {
                        PLShowErrorAlert(error: error!)
                    }
                    self.mySpinner?.stopAnimating()
                })
            } else {
                PLShowAlert(title: "Please, enter a valid user email.")
            }
        })
        forgotAction.enabled = false
        
		alert.addTextFieldWithConfigurationHandler({ (textField) in
			textField.placeholder = "Email"
            textField.keyboardType = .EmailAddress
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                forgotAction.enabled = textField.text != ""
            }
		})
        
		alert.addAction(forgotAction)
		presentViewController(alert, animated: true, completion: nil)
	}
    
    //FB
    @IBAction func facebookLoginButtonPressed(sender: UIButton) {
        startActivityIndicator(.WhiteLarge)
        PLFacade.loginFB { [unowned self] (error) in
            self.stopActivityIndicator()
            if error == nil {
                self.showMainScreen()
            } else {
                PLShowErrorAlert(error: error!)
            }
        }
    }

	// MARK: - Navigation
    
	@IBAction func unwindToLoginClicked(sender: UIStoryboardSegue) {
	}
	
	func loginToMainScreen() {
        var userName = ""
        var password = ""
        if loginTextField.text!.isEmpty && passTextField.text!.isEmpty {
            if let defaultUser = PLFacade.instance.settingsManager.defaultUser {
                userName = defaultUser.login
                password = defaultUser.password
            }
        } else {
            userName = loginTextField.text!
            password = passTextField.text!
        }

		if userName.isEmpty {
			PLShowAlert("Login error!", message: "Please enter your login.")
		} else if password.isEmpty {
			PLShowAlert("Login error!", message: "Please enter your password.")
		} else {
			self.view.userInteractionEnabled = false
			mySpinner!.startAnimating()
			PLFacade.login(userName, password: password, completion: { (error) in
				if error != nil {
					PLShowAlert("Login error!", message: (error?.localizedDescription)!)
					self.view.userInteractionEnabled = true
					self.mySpinner?.stopAnimating()
				} else {
					self.showMainScreen()
					self.view.userInteractionEnabled = true
					self.mySpinner?.stopAnimating()
				}
			})
		}
	}
	
	func showMainScreen() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
		presentViewController(vc, animated: true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		loginTextField.delegate = self
		passTextField.delegate = self
		
		animateSplashToLogin()
        hideKeyboardWhenTapped = true
    }
	
	
	func animateSplashToLogin() {
		
		logoCenterXC.active = true
		logoBottomC.active = false
		registerBotC.constant = -(registerButton.bounds.height * 2)
		loginViewBotC!.constant = -loginView.bounds.height
		view.layoutIfNeeded()
			
		UIView.animateWithDuration(1, delay: 2.2, options: .CurveEaseOut, animations: {
				self.logoCenterXC.active = false
				self.logoBottomC.active = true
				self.loginViewBotC?.constant = 0
				self.registerBotC.constant = 0
					self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		registerKeyboardNotifications()
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	// MARK: - Notifications
	
	private func registerKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	// MARK: - Keyboard
	
	func keyboardWillShow(notification: NSNotification) {
		updateViewAnimated(notification)
	}
	
	func keyboardWillHide(notification: NSNotification) {
		updateViewAnimated(notification)
	}
	
	private func updateViewAnimated(notification: NSNotification) {
		let userInfo = notification.userInfo!
		let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
		let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
		let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey]?.unsignedIntegerValue
		let options = UIViewAnimationOptions(rawValue: curve!<<16)
		let keyboardVisible = notification.name == UIKeyboardWillShowNotification
		
		UIView.animateWithDuration(duration!, delay: 0.0, options: options, animations: {
			self.registerButton.enabled = keyboardVisible ? false : true
			self.registerButton.alpha = keyboardVisible ? 0 : 1
			self.logoImage.alpha = keyboardVisible ? 0 : 1
			self.loginView.layoutIfNeeded()
			}, completion: nil)
		
		var visibleRect = loginView.frame
		visibleRect.size.height -= keyboardSize.height
		
		let scrollPoint = keyboardVisible ? CGPointMake(0, visibleRect.size.height / 2) : CGPointZero
		scrollView.setContentOffset(scrollPoint, animated: true)
		
	}
	
}

extension PLLoginViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		let nextTag = textField.tag + 1
		if let nextResponder = textField.superview!.viewWithTag(nextTag) {
			nextResponder.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
			loginToMainScreen()
		}
		return false
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		currentTextField = nil
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		currentTextField = textField as! PLFormTextField
	}
	
}
