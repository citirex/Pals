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

    @IBOutlet weak var userProfileImageView: PLCircularImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addProfileImageButton: UIButton!
    
    private var userData: PLUserData!
    private var isEditing = false { didSet { updateUI() }}
    private lazy var tempProfile: PLEditableUser! = { return PLEditableUser() }()
    
    
    
    deinit {
        print("PLEditProfileViewController deinit")
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
            self.startActivityIndicator(.WhiteLarge, color: .grayColor())
            PLFacade.logout({ error in
                self.stopActivityIndicator()
                
                sleep(1)
                
                guard error == nil else { return PLShowErrorAlert(error: error!) }
                self.logOut()
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
        userData                  = PLFacade.profile?.userData
        usernameTextField.text    = userData!.name
        phoneNumberTextField.text = userData!.email
        userProfileImageView.setImageWithURL(userData!.picture, placeholderImage: UIImage(named: "profile_placeholder"))
    }

    private func logOut() {
        let loginViewController = UIStoryboard.loginViewController()!
        presentViewController(loginViewController, animated: true) {
            self.navigationController!.viewControllers.removeAll()
        }
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
            startActivityIndicator(.WhiteLarge, color: .grayColor())
            PLFacade.updateProfile(tempProfile) {[unowned self] (error) in
                self.stopActivityIndicator()
                guard error == nil else { return PLShowErrorAlert(error: error!) }
                self.tempProfile.clean()
                self.setupUserData()
                NSNotificationCenter.defaultCenter().postNotificationName(kProfileInfoChanged, object: nil)
            }
        }
    }
    
    // MARK: - Update UI
    
    private func updateUI() {
        usernameTextField.enabled     = isEditing ? true : false
        phoneNumberTextField.enabled  = isEditing ? true : false
        addProfileImageButton.enabled = isEditing ? true : false
        addProfileImageButton.hidden  = isEditing ? false : true
    }
    
    // MARK: - Photos & Camera

    private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType             = sourceType
        imagePicker.delegate               = self
        imagePicker.modalPresentationStyle = sourceType == .Camera ? .FullScreen : .OverCurrentContext
        
        if sourceType == .Camera {
            imagePicker.cameraDevice      = .Front
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
        tempProfile.picture        = imagePicked
        dismiss(true)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(true)
    }
    
}

