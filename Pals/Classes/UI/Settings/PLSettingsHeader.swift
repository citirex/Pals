//
//  PLSettingsHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/12/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLSettingsHeader: UICollectionViewCell {
    
    @IBOutlet weak var headerSectionView: UIView!
    @IBOutlet weak var userProfileImageView: PLImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var usernameTextField: PLEditTextField!
    @IBOutlet weak var pensilImageView: UIImageView!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestures()
        
        usernameTextField.delegate = self
    }

    
    // MARK: - Gestures
    
    private func addGestures() {
        let editTap = UITapGestureRecognizer(target: self, action: #selector(textFieldEditing(_:)))
        pensilImageView.addGestureRecognizer(editTap)
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        headerSectionView.addGestureRecognizer(dismissTap)
    }
    
    
    // MARK: - Actions
    
    func textFieldEditing(sender: UITapGestureRecognizer) {
        print("textFieldEditing")
        usernameTextField.becomeFirstResponder()
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        print("dismissKeyboard")
        if usernameTextField.isFirstResponder() {
            usernameTextField.resignFirstResponder()
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension PLSettingsHeader: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}



