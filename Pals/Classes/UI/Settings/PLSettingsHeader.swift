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
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var usernameTextField: PLEditTextField!
    @IBOutlet weak var pensilImageView: UIImageView!
    @IBOutlet weak var textFieldWidthConstraint: NSLayoutConstraint!
    
    private let offset: CGFloat = 70.0

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

    override func layoutSubviews() {
        super.layoutSubviews()
     
        addConstraints()
    }
    
    private func addConstraints() {
        let screenWidth = UIScreen.mainScreen().bounds.width - offset
        let contentSize = usernameTextField.intrinsicContentSize()
        let constant = contentSize.width > screenWidth ? screenWidth : contentSize.width
        let relate: NSLayoutRelation = contentSize.width > screenWidth ? .Equal : .GreaterThanOrEqual
        usernameTextField.removeConstraint(textFieldWidthConstraint)
        textFieldWidthConstraint = NSLayoutConstraint(item: usernameTextField,
                                                      attribute: .Width,
                                                      relatedBy: relate,
                                                      toItem: nil,
                                                      attribute: .NotAnAttribute,
                                                      multiplier: 1,
                                                      constant: constant)
        usernameTextField.addConstraint(textFieldWidthConstraint)
        UIView.animateWithDuration(0.1, animations: {
            self.usernameTextField.updateConstraintsIfNeeded()
        })
    }

}


// MARK: - UITextFieldDelegate

extension PLSettingsHeader: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}



