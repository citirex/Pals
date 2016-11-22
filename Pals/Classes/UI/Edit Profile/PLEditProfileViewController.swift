//
//  PLEditProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import IQKeyboardManager

class PLEditProfileViewController: PLViewController {

    @IBOutlet weak var userProfileImageView: PLCircularImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var additionalTextField: UITextField!
    @IBOutlet weak var addProfileImageButton: UIButton!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var applyButton: UIButton!
    
    
    private var edit = false {
        didSet {
            updateEnabledStatus(edit)
            usernameTextField.becomeFirstResponder()
        }
    }
    
    private var editData = PLEditUserData(user: PLFacade.profile)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileUI()
        hideKeyboardWhenTapped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.style = .EditProfileStyle
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .textFieldDidChange, name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: - Private Methods
    
    private func updateEnabledStatus(status: Bool) {
        applyButton.hidden            = !status
        usernameTextField.enabled     = status
        additionalTextField.enabled   = status
        addProfileImageButton.enabled = status
        addProfileImageButton.hidden  = !status
    }
    
    private func updateProfileUI() {
        if let data = PLFacade.profile?.cellData {
            usernameTextField.text    = data.name
            phoneNumberTextField.text = data.email
            additionalTextField.text  = data.additional
            userProfileImageView.setImageWithURL(data.picture, placeholderImage: UIImage(named: "user"))
			
			userProfileImageView.setAvatarPlaceholder(userProfileImageView, url: data.picture)
        } else {
            usernameTextField.text     = "<Error name>"
            phoneNumberTextField.text  = "<Error phone>"
            additionalTextField.text   = "<Error additional>"
            userProfileImageView.image = UIImage(named: "user")
        }
    }

    private func logOut() {
        let loginViewController = UIStoryboard.loginViewController()!
        presentViewController(loginViewController, animated: true) {
            self.navigationController!.viewControllers.removeAll()
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
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
    
}


// MARK: - Actions

extension PLEditProfileViewController {
    
    @IBAction func applyAction(sender: UIButton) {
        guard editData != nil else { return }
        edit = false
        editBarButtonItem.image = UIImage(named: "edit")
        updateUserProfileIfNeeded(editData!)
    }
    
    @IBAction func editBarBattonItemTapped(sender: UIBarButtonItem) {
        edit = !edit
        sender.image = edit ? UIImage(named: "cancel") : UIImage(named: "edit")
        
        if !edit {
            updateProfileUI()
        }
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
        
        PLImagePicker.pickImage(self, imageView: userProfileImageView) { [unowned self] image in
			self.userProfileImageView.contentMode = .ScaleAspectFill
            self.userProfileImageView.image = image
            self.editData?.changePicture(image)
        }
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
