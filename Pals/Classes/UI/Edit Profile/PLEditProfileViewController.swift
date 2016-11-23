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
    @IBOutlet weak var checkButton: PLCheckmarkButton!

    private var editData = PLEditUserData(user: PLFacade.profile)
    private var edit = false {
        didSet {
            updateEnabledStatus(edit)
            usernameTextField.becomeFirstResponder()
        }
    }
    
    private lazy var editBarButtonItem: UIBarButtonItem! = {
        return UIBarButtonItem(image: UIImage(named: "edit"), style: .Plain, target: self, action: .tappedEditButton)
    }()
    
    private lazy var cancelBarButtonItem: UIBarButtonItem! = {
        let cancelButton = PLCancelButton(frame: CGRectMake(0, 0, 44, 44))
        cancelButton.addTarget(self, action: .tappedCancelButton, forControlEvents: .TouchUpInside)
        return UIBarButtonItem(customView: cancelButton)
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileUI()
        hideKeyboardWhenTapped = true
        navigationItem.rightBarButtonItem = editBarButtonItem
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addProfileImageButton.rounded = true
    }
    
    
    // MARK: - Private Methods
    
    private func updateEnabledStatus(status: Bool) {
        checkButton.hidden            = !status
        usernameTextField.enabled     = status
        additionalTextField.enabled   = status
        addProfileImageButton.enabled = status
        addProfileImageButton.hidden  = !status
        navigationItem.rightBarButtonItem = status ? cancelBarButtonItem : editBarButtonItem
    }
    
    private func updateProfileUI() {
        if let data = PLFacade.profile?.cellData {
            usernameTextField.text    = data.name
            phoneNumberTextField.text = data.email
            additionalTextField.text  = data.additional
            userProfileImageView.setImageWithURL(data.picture, placeholderImage: UIImage(named: "user"))
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
    
    private func resetProfile() {
        userProfileImageView.setImageWithURL(editData?.picture.old as! NSURL)
        usernameTextField.text   = editData?.name.old as? String
        additionalTextField.text = editData?.additional.old as? String
    }
    
}


// MARK: - Actions

extension PLEditProfileViewController {
    
    func tappedEditButton(sender: UIBarButtonItem) {
        edit = !edit
    }
    
    func tappedCancelButton(sender: UIButton) {
        edit = false
        resetProfile()
    }
    
    @IBAction func tappedCheckButton(sender: UIButton) {
        guard editData != nil else { return }
        edit = false
        updateUserProfileIfNeeded(editData!)
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
