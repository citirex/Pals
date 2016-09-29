//
//  PLSignUpViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLSignUpViewController: PLViewController {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var textFieldsContainer: UIView!
    @IBOutlet weak var usernameTextField: PLTextField!
    @IBOutlet weak var emailTextField: PLTextField!
    @IBOutlet weak var passwordTextField: PLTextField!
    @IBOutlet weak var confirmPasswordTextField: PLTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var addProfileImageButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    private lazy var imagePicker: UIImagePickerController! = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        return imagePicker
    }()
    
    private let offset: CGFloat = 20.0
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustFontSize()
        hideKeyboardWhenTapped()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        signUpButton.rounded = true
        userProfileImageView.rounded = true
    }
    

    // MARK: - Notifications
    
    private func registerKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

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
        
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardSize.height

        let scrollPoint = keyboardVisible ? CGPointMake(0, visibleRect.size.height / 3 + offset) : CGPointZero
        scrollView.setContentOffset(scrollPoint, animated: true)
     
        UIView.animateWithDuration(duration!, delay: 0.0, options: options, animations: {
            self.addProfileImageButton.enabled = keyboardVisible ? false : true
            self.addProfileImageButton.alpha = keyboardVisible ? 0 : 1
            self.userProfileImageView.alpha = keyboardVisible ? 0 : 1
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    // MARK: - Actions
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        dismissKeyboard(sender)
        userSignUp()
    }
    
    
    // MARK: - Private methods
    
    private func userSignUp() {
        let username = usernameTextField.text!.trim()
        let email = emailTextField.text!.trim()
        let password = passwordTextField.text!.trim()
        let picture = userProfileImageView.image ?? UIImage() // TODO: - Empty Image
        
        guard !username.isEmpty else { return PLShowAlert("Error", message: "Username must contain at least 1 character") }
        guard email.isValidEmail else { return PLShowAlert("Error", message: "Please enter a valid email address") }
        guard !password.isEmpty else { return PLShowAlert("Error", message: "Password must contain at least 1 character") }
        guard validatePassword(password) else { return PLShowAlert("Error", message: "Password mismatch") }
        
        let signUpData = PLSignUpData(username: username, email: email, password: password, picture: picture)
        
        activityIndicator.startAnimating()
        PLFacade.signUp(signUpData) { error in
            self.activityIndicator.stopAnimating()
            guard error == nil else { return PLShowAlert("Error", message: "This Username is Taken!") }
            let tabBarController = UIStoryboard.tabBarController() as! UITabBarController
            let navigationController = tabBarController.viewControllers?.first as! UINavigationController
            _ = navigationController.viewControllers.first as! PLProfileViewController
            self.present(tabBarController, animated: true)
        }
    }
    
    private func validatePassword(pass: String) -> Bool {
        return pass == confirmPasswordTextField.text!.trim()
    }
    
    private func adjustFontSize() {
        signInButton.titleLabel?.font = .customFontOfSize(15)
        signUpButton.titleLabel?.font = .customFontOfSize(15)
    }

}


// MARK: - UIImagePickerControllerDelegate Methods

extension PLSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        userProfileImageView.image = imagePicked
        dismiss(true)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(true)
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
            userSignUp()
        }
        return false
    }

}




