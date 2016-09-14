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
    @IBOutlet weak var addProfileImageButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let imagePicker = UIImagePickerController()
    private var isEditing = false
    
    var user: PLUser!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        usernameTextField.text = user.name
        userProfileImageView.setImageWithURL(user.picture)
    
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(dismissTap)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }

    
    // MARK: - Actions

    @IBAction func editBarBattonItemTapped(sender: UIBarButtonItem) {
        isEditing = !isEditing
        
        updateUI()
        
        if isEditing {
            usernameTextField.becomeFirstResponder()
        }
    }
    

    @IBAction func invitePalsButtonTapped(sender: UIButton) {
        print("invitePalsButtonTapped")
    }
    
    
    @IBAction func signOutButtonTapped(sender: UIButton) {
        let alertController = UIAlertController(title: "You're signing out!", message: "Are you sure?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            let loginViewController = UIStoryboard.loginViewController()
            self.presentViewController(loginViewController!, animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    

    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        let scrollViewBounds = scrollView.bounds
        let contentViewBounds = view.bounds
        
        var scrollViewInsets = UIEdgeInsetsZero
        scrollViewInsets.top = scrollViewBounds.size.height / 2
        scrollViewInsets.top -= contentViewBounds.size.height / 2
        
        scrollViewInsets.bottom = scrollViewBounds.size.height / 2
        scrollViewInsets.bottom -= contentViewBounds.size.height / 2
        scrollViewInsets.bottom += 1
        
        scrollView.contentInset = scrollViewInsets
        
        super.viewWillLayoutSubviews()
    }

    
    // MARK: - update UI
    
    private func updateUI() {
        if isEditing {
            usernameTextField.enabled = true
            phoneNumberTextField.enabled = true
            addProfileImageButton.enabled = true
        } else {
            usernameTextField.enabled = false
            phoneNumberTextField.enabled = false
            addProfileImageButton.enabled = false
        }
    }

}


// MARK: - UIScrollViewDelegate

extension PLEditProfileViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dismissKeyboard(self)
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        dismissKeyboard(self)
        return true
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

