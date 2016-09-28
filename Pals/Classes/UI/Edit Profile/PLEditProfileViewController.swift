//
//  PLEditProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class PLEditProfileViewController: PLViewController {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addProfileImageButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    private lazy var imagePicker: UIImagePickerController! = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private var userData: PLUserData!
    private var isEditing = false {
        didSet { updateUI() }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:))))
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
    
    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    
    private func setup() {
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
    
    private func showSettingsAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { action in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        present(alert, animated: true)
    }
    
    private func photoFromSourceType(sourceType: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        
        switch sourceType {
        case .PhotoLibrary:
            imagePicker.navigationBar.tintColor = .crayonPurple()
            imagePicker.modalPresentationStyle = .OverCurrentContext
        case .Camera:
            imagePicker.cameraDevice = .Front
            imagePicker.cameraCaptureMode = .Photo
            imagePicker.modalPresentationStyle = .FullScreen
        default:
            break
        }
        present(imagePicker, animated: true)
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
            self.photoLibraryPermission()
        }))
        optionMenu.addAction(UIAlertAction(title: "Take a photo", style: .Default, handler: { alert in
            self.cameraPermission()
        }))
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        present(optionMenu, animated: true)
    }

    // MARK: - Photo library permission
    
    func photoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            dispatch_async(dispatch_get_main_queue(), { 
                switch status {
                case .Authorized:
                    self!.photoFromSourceType(.PhotoLibrary)
                default:
                    self!.showSettingsAlert("",
                        message: "Using Photo Library is disabled for this app. Enable it in Settings->Privacy")
                }
            })
        }
    }
 
    // MARK: - Camera permission

    func cameraPermission() {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { [weak self] granted in
            dispatch_async(dispatch_get_main_queue(), {
                if granted {
                    self!.photoFromSourceType(.Camera)
                } else {
                    self!.showSettingsAlert("",
                        message: "Using Camera is disabled for this app. Enable it in Settings->Privacy")
                }
            })
        })
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

