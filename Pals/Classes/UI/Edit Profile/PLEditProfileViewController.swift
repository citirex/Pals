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
    @IBOutlet weak var signOutButton: UIButton!

    private var userData: PLUserData!
    private lazy var tempProfile: PLEditableUser = { return PLEditableUser() }()
    private var isEditing = false {
        didSet { updateUI() }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserData()
        hideKeyboardWhenTapped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .EditProfileStyle
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        userProfileImageView.borderColor = .whiteColor()
        userProfileImageView.layer.borderWidth = 1.0
        userProfileImageView.rounded = true
        signOutButton.rounded = true
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
        alert.addAction(UIAlertAction(title: "Yes", style: .Default) { [unowned self] action in
            PLFacade.logout({ (error) in
                let loginViewController = UIStoryboard.loginViewController()
                self.present(loginViewController!, animated: true)
            })
        })
        present(alert, animated: true)
    }
    
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
    
    
    // MARK: - Private Methods
    
    private func setupUserData() {
        userData = PLFacade.profile?.userData
        usernameTextField.text = userData!.name
        phoneNumberTextField.text = userData!.email
        userProfileImageView.setImageWithURL(userData!.picture, placeholderImage: UIImage(named: "no_image_available"))
    }

    
    // MARK: - Update User Data
    
    private func updateUserData() {
        //check for dada chenged
        if let name = usernameTextField.text where name != userData.name {
            tempProfile.name = name
        }
        if let contact = phoneNumberTextField.text where contact != userData.email {
            tempProfile.contactMain = contact
        }
//        if let contactSpare = phoneNumberTextField.text where contactSpare != userData.name {
//            tempProfile.contactSecondary = contactSpare
//        }
        
        if tempProfile.isChanged == true {
            spinner.center = view.center
            spinner.startAnimating()
            spinner.activityIndicatorViewStyle = .Gray
            PLFacade.updateProfile(tempProfile) {[unowned self] (error) in
                if error == nil {
                    self.tempProfile.clean()
                    self.setupUserData()
                    NSNotificationCenter.defaultCenter().postNotificationName(kProfileInfoChanged, object: nil)
                } else {
                    PLShowErrorAlert(error: error!)
                }
                self.spinner.stopAnimating()
            }
        }
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
        permission.request { [unowned self] status in
            guard status == .Authorized else { return }
            switch permission.type {
            case .Photos: self.showImagePickerForSourceType(.PhotoLibrary)
            case .Camera: self.showImagePickerForSourceType(.Camera)
            default: break
            }
        }
        let alert = permission.deniedAlert
        alert.title   = "Using \(permission.type) is disabled for this app"
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
        tempProfile.picture = imagePicked
        dismiss(true)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(true)
    }
    
}

