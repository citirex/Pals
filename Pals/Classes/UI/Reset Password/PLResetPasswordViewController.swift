//
//  PLResetPasswordViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 11/23/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: PLFormTextField!
    @IBOutlet weak var codeTextField: PLFormTextField!
    @IBOutlet weak var passwordTextField: PLFormTextField!
    @IBOutlet weak var confirmPasswordTextField: PLFormTextField!

    var email: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTapped = true
    
        emailTextField.text = email
        codeTextField.becomeFirstResponder()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    // MARK: - Actions
    
    @IBAction func save(sender: UIButton) {
        checkingUserData()
    }
    
    
    // MARK: - Private methods
    
    private func checkingUserData() {
        let password = passwordTextField.text!.trim()
        let code = codeTextField.text!.trim()
        
        guard code.characters.count == 4 else { return PLShowAlert("Error", message: "Code must contain 4 digits") }
        guard !password.isEmpty  else { return PLShowAlert("Error", message: "Password must contain at least 1 character") }
        guard validate(password) else { return PLShowAlert("Error", message: "Password mismatch") }
        
        let resetPasswordData = PLResetPasswordData(email: email, code: code, password: password)
        
        resetPassword(resetPasswordData)
    }
    
    private func resetPassword(resetPasswordData: PLResetPasswordData) {
//        startActivityIndicator(.WhiteLarge)
//        PLFacade.resetPassword(resetPasswordData) { [unowned self] error in
//            self.stopActivityIndicator()
//            
//        }
    }
    
    private func validate(password: String) -> Bool {
        return password == confirmPasswordTextField.text!.trim()
    }
    
}


// MARK: - UITextFieldDelegate

extension PLResetPasswordViewController: UITextFieldDelegate {
        
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
