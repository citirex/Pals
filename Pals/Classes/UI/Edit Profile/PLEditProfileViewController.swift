//
//  PLEditProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import Permission

class PLEditProfileViewController: PLViewController {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addProfileImageButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private var userData: PLUserData!
    private var isEditing = false {
        didSet { updateUI() }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserData()
        hideKeyboardWhenTapped()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.setNavigationBarTransparent(true)
        navigationController?.navigationBar.tintColor = .whiteColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarTransparent(false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userProfileImageView.rounded = true
        signUpButton.rounded = true
    }
    
    
    // MARK: - Actions
    
    @IBAction func editBarBattonItemTapped(sender: UIBarButtonItem) {
        isEditing = !isEditing
        guard isEditing else { return updateUserData() }
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func showSignOutAlert(sender: UIButton) {
        let alert = UIAlertController(title: "You're signing out!", message: "Are you sure?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .Default) { action in
            let loginViewController = UIStoryboard.loginViewController()
            self.present(loginViewController!, animated: true)
            })
        present(alert, animated: true)
    }
    
    @IBAction func showActionSheet(sender: UIButton) {
        dismissKeyboard(sender)
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        optionMenu.addAction(UIAlertAction(title: "Choose from Library", style: .Default, handler: { alert in
            self.requestPermission(Permission.Photos)
        }))
        optionMenu.addAction(UIAlertAction(title: "Take a photo", style: .Default, handler: { alert in
            self.requestPermission(Permission.Camera)
        }))
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        present(optionMenu, animated: true)
    }
    
    
    // MARK: - Private Methods
    
    private func setupUserData() {
        userData = PLFacade.profile?.userData
        usernameTextField.text = userData!.name
        phoneNumberTextField.text = userData!.phone
        userProfileImageView.setImageWithURL(userData!.picture)
        adjustFontSize()
    }
    
    private func adjustFontSize() {
        signUpButton.titleLabel?.font = .customFontOfSize(22)
        usernameTextField.font = .customFontOfSize(15)
        phoneNumberTextField.font = .customFontOfSize(15)
    }
    
    // MARK: - Update User Data
    
    private func updateUserData() {
        userData.name = usernameTextField.text!
        userData.email = phoneNumberTextField.text!
        userData.phone = phoneNumberTextField.text!
//        userData.picture = userProfileImageView.image
//        PLFacade.updateUserData(userData) { error in }
    }
    
    // MARK: - Update UI
    
    private func updateUI() {
        usernameTextField.enabled = isEditing ? true : false
        phoneNumberTextField.enabled = isEditing ? true : false
        addProfileImageButton.enabled = isEditing ? true : false
        addProfileImageButton.hidden = isEditing ? false : true
    }
    
    // MARK: - Photos & Camera

    private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = sourceType == .Camera ? .FullScreen : .OverCurrentContext
        
        if sourceType == .Camera {
            imagePicker.cameraDevice = .Front
            imagePicker.cameraCaptureMode = .Photo
        }
        present(imagePicker, animated: true)
    }
    
    private func requestPermission(permission: Permission) {
        permission.request { status in
            guard status == .Authorized else { return }
            switch permission.type {
            case .Photos: self.showImagePickerForSourceType(.PhotoLibrary)
            case .Camera: self.showImagePickerForSourceType(.Camera)
            default: break
            }
        }
        let alert = permission.deniedAlert
        alert.title = "Using \(permission.type) is disabled for this app"
        alert.message = "Enable it in Settings->Privacy"
    }

}



// MARK: - UITextFieldDelegate

extension PLEditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}

// MARK: - UIImagePickerControllerDelegate Methods

extension PLEditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        userProfileImageView.image = imagePicked
        dismiss(true)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(true)
    }
    
}







