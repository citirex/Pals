//
//  PLEditViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 12/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLEditViewController: UITableViewController {
    
    @IBOutlet weak var userImageView: PLCircularImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    
    private var editUserData = PLEditUserData(user: PLFacade.profile)
    
    private var userIsInTheEditMode = false {
        didSet {
            updateUI()
        }
    }
    
    private lazy var done: UIBarButtonItem! = {
        return UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(editTapped))
    }()
    
    private lazy var cancel: UIBarButtonItem! = {
       return UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelTapped))
    }()
    
    private lazy var back: UIBarButtonItem! = {
        return UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .Plain, target: self, action: #selector(backTapped))
    }()
    
    private lazy var edit: UIBarButtonItem! = {
        return UIBarButtonItem(image: UIImage(named: "edit"), style: .Plain, target: self, action: #selector(editTapped))
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProfile()
        
        hideKeyboardWhenTapped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textFieldDidChange), name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addImageButton.rounded = true
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dismissKeyboard(scrollView)
    }
   
    
    // MARK: - Actions
    
    func cancelTapped() {
        userIsInTheEditMode = false
        
        resetUserProfileFields()
    }
    
    func editTapped() {
        userIsInTheEditMode = !userIsInTheEditMode
        
        if !userIsInTheEditMode {
            guard editUserData != nil else { return }
            updateUserProfileIfNeeded(editUserData!)
        }
    }
    
    func backTapped() {
        navigationController?.popViewControllerAnimated(true)
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
        
        PLImagePicker.pickImage(self, imageView: userImageView) { [unowned self] image in
            self.userImageView.contentMode = .ScaleAspectFill
            self.userImageView.image = image
            self.editUserData?.changePicture(image)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func updateProfile() {
        if let user = PLFacade.profile {
            usernameTextField.text = user.name
            phoneTextField.text = user.additional
            emailTextField.text = user.email
//            additionalTextField.text  = user.additional
            userImageView.setImageSafely(fromURL: user.picture, placeholderImage: UIImage(named: "user"))
        } else {
            usernameTextField.text = "<Error name>"
            phoneTextField.text  = "<Error phone>"
            emailTextField.text = "<Error email>"
//            additionalTextField.text   = "<Error additional>"
            userImageView.image = UIImage(named: "user")
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
            usernameTextField.text = editUserData?.name.old as? String
        }
    }
    
    private func updateUserProfileIfNeeded(editUserData: PLEditUserData) {
        let validator = editUserData.validate()
        if validator.1 != nil {
            let error = validator.1!
            if error.domain == PLErrorDomain.User.string && error.code == 1002 {
                resetEmptyFields()
            }
        } else {
            if validator.0 {
                startActivityIndicator(.WhiteLarge, color: .grayColor())
                PLFacade.updateProfile(editUserData) { [unowned self] error in
                    self.stopActivityIndicator()
                    guard error == nil else { return PLShowErrorAlert(error: error!) }
                    self.editUserData = PLEditUserData(user: PLFacade.profile)
                }
            }
        }
    }
    
    private func resetUserProfileFields() {
        userImageView.setImageWithURL(editUserData?.picture.old as! NSURL)
        usernameTextField.text = editUserData?.name.old as? String
//        additionalTextField.text = editUserData?.additional.old as? String
    }
    
    private func updateUI() {
        usernameTextField.enabled  = userIsInTheEditMode
        firstNameTextField.enabled = userIsInTheEditMode
        lastNameTextField.enabled  = userIsInTheEditMode
        phoneTextField.enabled     = userIsInTheEditMode
        addImageButton.hidden      = !userIsInTheEditMode
        
        if userIsInTheEditMode {
            navigationItem.setRightBarButtonItem(done, animated: true)
            navigationItem.setLeftBarButtonItem(cancel, animated: true)
            navigationItem.backBarButtonItem = nil
        } else {
            navigationItem.setRightBarButtonItem(edit, animated: true)
            navigationItem.backBarButtonItem = back
            navigationItem.leftBarButtonItem = nil
        }
    }

    
}


// MARK: - UITextFieldDelegate

extension PLEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldDidChange(notification: NSNotification) {
        if let textField = notification.object as? UITextField {
            let text = textField.text
            if textField === usernameTextField {
                editUserData?.changeName(text)
            }
//            else if textField === additionalTextField {
//                editUserData?.changeAdditional(text)
//            }
        }
    }
    
}

