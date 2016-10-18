//
//  PLEditProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Permission
import IQKeyboardManager

class PLEditProfileViewController: PLViewController {

    @IBOutlet weak var userProfileImageView: PLCircularImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var additionalTextField: UITextField!
    @IBOutlet weak var addProfileImageButton: UIButton!
    
    private var edit = false {
        didSet {
            updateEnabledStatus(edit)
            guard edit else {
                if editData != nil {
                    updateUserProfileIfNeeded(editData!)
                }
                return
            }
            usernameTextField.becomeFirstResponder()
        }
    }
    private var editData = PLEditUserData(user: PLFacade.profile)
    
    deinit {
        print("PLEditProfileViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileUI()
        hideKeyboardWhenTapped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.style = .EditProfileStyle
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Actions
    
    @IBAction func editBarBattonItemTapped(sender: UIBarButtonItem) {
        edit = !edit
    }
    
    @IBAction func showSignOutAlert(sender: UIButton) {
        let alert = UIAlertController(title: "You're signing out!", message: "Are you sure?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .Default) { [unowned self] action in
            self.startActivityIndicator(.WhiteLarge, color: .grayColor())
            PLFacade.logout({ error in
                self.stopActivityIndicator()
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
    
    private func updateEnabledStatus(status: Bool) {
        usernameTextField.enabled     = status
        additionalTextField.enabled  = status
        addProfileImageButton.enabled = status
        addProfileImageButton.hidden  = !status
    }
    
    private func updateProfileUI () {
        if let data = PLFacade.profile?.userData {
            usernameTextField.text    = data.name
            phoneNumberTextField.text = data.email
            additionalTextField.text = data.additional
            userProfileImageView.setImageWithURL(data.picture, placeholderImage: UIImage(named: "profile_placeholder"))
        } else {
            usernameTextField.text = "<Error name>"
            phoneNumberTextField.text = "<Error phone>"
            additionalTextField.text = "<Error additional>"
            userProfileImageView.image = UIImage(named: "profile_placeholder")
        }
    }

    private func logOut() {
        let loginViewController = UIStoryboard.loginViewController()!
        presentViewController(loginViewController, animated: true) {
            self.navigationController!.viewControllers.removeAll()
        }
    }
    
    private func resetEmptyFields() {
        // only for those fields that are not allowed to be empty
        if usernameTextField.text!.isEmpty {
            usernameTextField.text = editData?.name.old as? String
        }
    }
    
    private func updateUserProfileIfNeeded(editData: PLEditUserData) {
        let validator = editData.validate()
        if validator.1 != nil {
            let error = validator.1!
            if error.domain == PLErrorDomain.User.string && error.code == 1002 {
                resetEmptyFields()
            }
        } else {
            if validator.0 {
                startActivityIndicator(.WhiteLarge, color: .grayColor())
                PLFacade.updateProfile(editData) {[unowned self] (error) in
                    self.stopActivityIndicator()
                    guard error == nil else { return PLShowErrorAlert(error: error!) }
                    self.editData = PLEditUserData(user: PLFacade.profile)
                }
            }
        }
    }
    
    // MARK: - Photos & Camera

    private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType             = sourceType
        imagePicker.allowsEditing          = false
        imagePicker.delegate               = self
        
        if sourceType == .Camera {
            imagePicker.cameraDevice           = .Front
            imagePicker.cameraCaptureMode      = .Photo
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
        alert.message = "Enable it in Settings -> Privacy"
    }
}

// MARK: - UITextFieldDelegate

extension PLEditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidChange(notif: NSNotification) {
        if let textField = notif.object as? UITextField {
            let text = textField.text
            if textField === usernameTextField {
                editData?.changeName(text)
            } else if textField === additionalTextField {
                editData?.changeAdditional(text)
            }
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate Methods

extension PLEditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        userProfileImageView.image = imagePicked
        editData?.changePicture(imagePicked)
        dismiss(true)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(true)
    }
    
}