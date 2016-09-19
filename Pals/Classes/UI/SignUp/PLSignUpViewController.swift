//
//  PLSignUpViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLSignUpViewController: PLViewController {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: PLTextField!
    @IBOutlet weak var emailTextField: PLTextField!
    @IBOutlet weak var passwordTextField: PLTextField!
    @IBOutlet weak var confirmPasswordTextField: PLTextField!
    @IBOutlet weak var textFieldsContainer: UIView!
    @IBOutlet weak var addProfileImageButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    private let imagePicker = UIImagePickerController()
    private let margin: CGFloat = 100.0
    
    
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
    
    
    
    // MARK: - Notifications
    
    private func registerKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
 
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + margin, 0.0)
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey]?.unsignedIntegerValue
        let options = UIViewAnimationOptions(rawValue: curve!<<16)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if CGRectContainsPoint(visibleRect, textFieldsContainer!.frame.origin) {
            scrollView.scrollRectToVisible(textFieldsContainer!.frame, animated: true)
            UIView.animateWithDuration(duration!, delay: 0.0, options: options, animations: {
                self.addProfileImageButton.alpha = 0
                self.userProfileImageView.alpha = 0
                }, completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey]?.unsignedIntegerValue
        let options = UIViewAnimationOptions(rawValue: curve!<<16)
        
        UIView.animateWithDuration(duration!, delay: 0.0, options: options, animations: {
            self.addProfileImageButton.alpha = 1
            self.userProfileImageView.alpha = 1
            }, completion: nil)
        
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    
    // MARK: - Dismiss Keyboard
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    // MARK: - Actions
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        signUp()
    }
    
    // MARK: - Private methods
    
    private func signUp() {
        let username = usernameTextField.text!.trim()
        let email = emailTextField.text!.trim()
        let password = passwordTextField.text!.trim()
        let picture = userProfileImageView.image
        
        guard !username.isEmpty else { return PLShowAlert("Error", message: "Username must contain at least 1 character") }
        guard email.isValidEmail else { return PLShowAlert("Error", message: "Please enter a valid email address") }
        guard !password.isEmpty else { return PLShowAlert("Error", message: "Password must contain at least 1 character") }
        guard validatePassword(password) else { return PLShowAlert("Error", message: "Password mismatch") }
        
        let signUpData = PLSignUpData(username: username, email: email, password: password, picture: picture!)
        
        // TODO: - Need pass user to profile
        activityIndicator.startAnimating()
        PLFacade.signUp(signUpData) { error in
            self.activityIndicator.stopAnimating()
            guard error == nil else { return PLShowAlert("Error", message: error!.localizedDescription) }
            let tabBarController = UIStoryboard.tabBarController() as! UITabBarController
            let navigationController = tabBarController.viewControllers?.first as! UINavigationController
            _ = navigationController.viewControllers.first as! PLProfileViewController
            self.presentViewController(tabBarController, animated: true, completion: nil)
        }
    }
    
    private func validatePassword(pass: String) -> Bool {
        return pass == confirmPasswordTextField.text!.trim()
    }
}


// MARK: - UIImagePickerControllerDelegate Methods

extension PLSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userProfileImageView.image = imagePicked
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
            signUp()
            textField.resignFirstResponder()
        }
        return false
    }

}

