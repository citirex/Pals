//
//  PLSignUpViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLSignUpViewController: UIViewController {
    
    typealias DidSignUpDelegate = (userData: PLSignUpData) -> Void
    var didSignUp: DidSignUpDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: PLTextField!
    @IBOutlet weak var emailTextField: PLTextField!
    @IBOutlet weak var passwordTextField: PLTextField!
    @IBOutlet weak var confirmPasswordTextField: PLTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldsContainer: UIView!
    
    private let imagePicker = UIImagePickerController()
    
    private var margin: CGFloat = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(dismissTap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        registerKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Dismiss Keyboard
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    // MARK: - Notifications
    
    private func registerKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + margin, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if CGRectContainsPoint(visibleRect, textFieldsContainer!.frame.origin) {
            scrollView.scrollRectToVisible(textFieldsContainer!.frame, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    
    // MARK: - Actions
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        let username = nameTextField.text!.trim()
        let email = emailTextField.text!.trim()
        let password = passwordTextField.text!.trim()
        let picture = imageView.image != nil ? imageView.image : UIImage(named: "anonimus")
        
        let userData = PLSignUpData(username: username, email: email, password: password, picture: picture!)
        // validate here
        PLFacade.signUp(userData) { (error) in
            // show tabbar or alert if error!=nil
        }
        
//        if validate(userData) {
//            didSignUp?(userData: userData)
//            showAlert("Success", message: "Signed Up")
//        }
        
        
    }
    
    private func validate(userData: PLSignUpData) -> Bool {
        if userData.username.characters.count == 0 {
            showAlert("Error", message: "Username must contain at least 1 character")
            return false
        } else if !validateEmail(userData.email) {
            showAlert("Error", message: "Please enter a valid email address")
            return false
        } else if userData.password.characters.count == 0 {
            showAlert("Error", message: "Password must contain at least 1 character")
            return false
        } else if userData.password != confirmPasswordTextField.text?.trim() {
            showAlert("Error", message: "Password mismatch")
            return false
        }
        return true
    }
    
    private func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(email)
    }
    
    // MARK: - Alert
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }


    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}


// MARK: - UIImagePickerControllerDelegate Methods

extension PLSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.layer.cornerRadius = imageView.bounds.size.width / 2
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = imagePicked
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}


// MARK: - UITextFieldDelegate

extension PLSignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview!.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }

}

