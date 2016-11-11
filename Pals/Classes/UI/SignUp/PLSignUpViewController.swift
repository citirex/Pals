//
//  PLSignUpViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//


class PLSignUpViewController: PLViewController {
    
    @IBOutlet weak var userProfileImageView: PLCircularImageView!
    @IBOutlet weak var usernameTextField:        PLFormTextField!
    @IBOutlet weak var emailTextField:           PLFormTextField!
    @IBOutlet weak var passwordTextField:        PLFormTextField!
    @IBOutlet weak var confirmPasswordTextField: PLFormTextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTapped = true
    }
    
    
    // MARK: - Private methods
    
    private func checkingUserData() {
        let username = usernameTextField.text!.trim()
        let email    = emailTextField.text!.trim()
        let password = passwordTextField.text!.trim()
        let picture  = userProfileImageView.image
        
        guard !username.isEmpty  else { return PLShowAlert("Error", message: "Username must contain at least 1 character") }
        guard email.isValidEmail else { return PLShowAlert("Error", message: "Please enter a valid email address") }
        guard !password.isEmpty  else { return PLShowAlert("Error", message: "Password must contain at least 1 character") }
        guard validate(password) else { return PLShowAlert("Error", message: "Password mismatch") }
        
        let signUpData = PLSignUpData(source: .SourceManual(Manual(username: username, email: email, password: password, picture: picture)))

        userSignUp(signUpData)
    }
    
    private func validate(password: String) -> Bool {
        return password == confirmPasswordTextField.text!.trim()
    }
    
    private func userSignUp(signUpData: PLSignUpData) {
        startActivityIndicator(.WhiteLarge)
        PLFacade.signUp(signUpData) { [unowned self] error in
            self.stopActivityIndicator()
            
            guard error == nil else {
                print("Error: \(error)")
                return PLShowAlert("Error", message: "This Username is Taken!") //FIXME: show actual error message
            }
            let tabBarController = UIStoryboard.tabBarController()
            self.present(tabBarController!, animated: true)
        }
    }

}


// MARK: - Actions

extension PLSignUpViewController {

    @IBAction func showActionSheet(sender: UIButton) {
        dismissKeyboard(sender)
        
        PLImagePicker.pickImage(self, imageView: userProfileImageView) { image in
            self.userProfileImageView.image = image
        }
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        dismissKeyboard(sender)
        checkingUserData()
    }

}


// MARK: - UITextFieldDelegate

extension PLSignUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.keyboardDistanceFromTextField = 40.0
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        jumpToNext(textField, withTag: nextTag)
        return false
    }
    
    func jumpToNext(textField: UITextField, withTag tag: Int) {
        if let nextField = textField.superview?.viewWithTag(tag) {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
}