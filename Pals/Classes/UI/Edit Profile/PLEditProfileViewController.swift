//
//  PLEditProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLEditProfileViewController: PLViewController {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addProfileImageButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    private let imagePicker = UIImagePickerController()
    private var isEditing = false { didSet { updateUI() } }
    
    var userData: PLUserData!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        userData = PLFacade.profile?.userData
        usernameTextField.text = userData.name
        phoneNumberTextField.text = userData.phone
        userProfileImageView.setImageWithURL(userData.picture)
        
        adjustFontSize()
    
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(dismissTap)
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
    
    
    // MARK: - Update User Data
    
    private func updateUserData() {
        userData.name = usernameTextField.text!
        userData.email = phoneNumberTextField.text!
        userData.phone = phoneNumberTextField.text!
        //userData.picture = userProfileImageView.image
    }

    // MARK: - Actions

    @IBAction func editBarBattonItemTapped(sender: UIBarButtonItem) {
        isEditing = !isEditing
        if isEditing { usernameTextField.becomeFirstResponder() }
        else { updateUserData() }
    }
    
    
    @IBAction func signOutButtonTapped(sender: UIButton) {
        let alertController = UIAlertController(title: "You're signing out!", message: "Are you sure?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { action in
            let loginViewController = UIStoryboard.loginViewController()
            self.presentViewController(loginViewController!, animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.navigationBar.tintColor = .crayonPurple()
        imagePicker.modalPresentationStyle = .OverCurrentContext
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    // MARK: - update UI
    
    private func updateUI() {
        if isEditing {
            usernameTextField.enabled = true
            phoneNumberTextField.enabled = true
            addProfileImageButton.enabled = true
            addProfileImageButton.hidden = false
        } else {
            usernameTextField.enabled = false
            phoneNumberTextField.enabled = false
            addProfileImageButton.enabled = false
            addProfileImageButton.hidden = true
        }
    }
    
    private func adjustFontSize() {
        signUpButton.titleLabel?.font = .customFontOfSize(22)
        usernameTextField.font = .customFontOfSize(15)
        phoneNumberTextField.font = .customFontOfSize(15)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        userProfileImageView.rounded = true
        signUpButton.rounded = true
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
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userProfileImageView.image = imagePicked
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

