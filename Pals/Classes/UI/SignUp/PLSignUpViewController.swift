//
//  PLSignUpViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Permission

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
    
    
    // MARK: - Actions

    @IBAction func showActionSheet(sender: UIButton) {
        dismissKeyboard(sender)
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        optionMenu.addAction(UIAlertAction(title: "Choose from Library", style: .Default, handler: { [unowned self] alert in
            self.requestPermission(Permission.Photos)
            }))
        optionMenu.addAction(UIAlertAction(title: "Take a photo", style: .Default, handler: { [unowned self] alert in
            self.requestPermission(Permission.Camera)
            }))
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        present(optionMenu, animated: true)
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        dismissKeyboard(sender)
        checkingUserData()
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
            let tabBarController = UIStoryboard.tabBarController() as! UITabBarController
            self.present(tabBarController, animated: true)
        }
    }
    
    private func requestPermission(permission: Permission) {
        permission.request { [unowned self] status in
            guard status == .Authorized else { return }
            switch permission.type {
            case .Photos: self.showImagePickerForSourceType(.PhotoLibrary)
            case .Camera: self.showImagePickerForSourceType(.Camera)
            default: break
            }
        }
        let alert     = permission.deniedAlert
        alert.title   = "Using \(permission.type) is disabled for this app"
        alert.message = "Enable it in Settings->Privacy"
    }
    
    private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate   = self
        
        if sourceType == .Camera {
            imagePicker.cameraDevice      = .Front
            imagePicker.cameraCaptureMode = .Photo
        }
        present(imagePicker, animated: true)
    }

}


// MARK: - UIImagePickerControllerDelegate

extension PLSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        userProfileImageView.image = imagePicked.crop(CGSizeMake(200, 200))
        dismiss(true)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(true)
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