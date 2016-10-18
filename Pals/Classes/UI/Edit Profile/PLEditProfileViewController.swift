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
    
    private var isEditing = false { didSet { updateUI() }}
    private var tempUserData: PLUserEditedData!
    
    
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
        
        guard let userData = PLFacade.profile?.userData else {
            PLShowAlert(title: "Something went wrong, try again later")
            return
        }
        tempUserData = PLUserEditedData(aUserName: userData.name, aUserEmail: userData.email, aUserImage: nil)
        usernameTextField.text    = userData.name
        phoneNumberTextField.text = userData.email
        let imageRequest = NSURLRequest(URL: userData.picture, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 30)
        userProfileImageView.setImageWithURLRequest(imageRequest, placeholderImage: UIImage(named: "profile_placeholder"), success: {[unowned self] (request, response, image) in
                self.userProfileImageView.image = image
                self.tempUserData?.userImage.initial = image
            }) { (request, response, error) in
                PLLog(request.URL?.absoluteString, response?.allHeaderFields, error.localizedDescription)
        }
    }

    private func logOut() {
        let loginViewController = UIStoryboard.loginViewController()!
        presentViewController(loginViewController, animated: true) {
            self.navigationController!.viewControllers.removeAll()
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
    
    // MARK: - Update User Data
    
    private func updateUserData() {
        tempUserData?.userName.final = usernameTextField.text
        tempUserData?.userEmail.final = phoneNumberTextField.text
        tempUserData?.userImage.final = userProfileImageView.image
        
        if tempUserData?.isChanged == true {
            print(tempUserData!.params())
            
            startActivityIndicator(.WhiteLarge, color: .grayColor())
            PLFacade.updateProfile(tempUserData) {[unowned self] (error) in
                self.stopActivityIndicator()
                guard error == nil else { return PLShowErrorAlert(error: error!) }
                self.tempUserData.clean()
                self.setupUserData()
                NSNotificationCenter.defaultCenter().postNotificationName(kProfileInfoChanged, object: nil)
            }
            
        }
        
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
        tempUserData?.userImage.final = imagePicked
        dismiss(true)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(true)
    }
    
}

