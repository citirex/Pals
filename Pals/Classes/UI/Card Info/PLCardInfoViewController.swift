//
//  PLCardInfoViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/15/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import Stripe

class PLCardInfoViewController: PLViewController {
    
    @IBOutlet private var cardField: STPPaymentCardTextField?
    @IBOutlet private weak var creditCardNumberTextField: PLFormTextField!
    @IBOutlet private weak var expirationDateTextField:   PLFormTextField!
    @IBOutlet private weak var zipCodeTextField:          PLFormTextField!
    @IBOutlet private weak var cvvCodeTextField:          PLFormTextField!
    private var allFields = [UITextField]()
    
    lazy var expirationDatePicker = PLDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTapped = true
        allFields.append(creditCardNumberTextField!)
        allFields.append(zipCodeTextField!)
        allFields.append(cvvCodeTextField!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.style = .CardInfoStyle
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        creditCardNumberTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    func completePressed(sender: UIButton) {
        dismissKeyboard(sender)
        navigationController?.popViewControllerAnimated(true)
    }

    private lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
        containerView.backgroundColor = .whiteColor()
        
        let sendButton = UIButton(type: .System)
        sendButton.tintColor = .mediumOrchidColor()
        sendButton.setTitle("Complete", forState: .Normal)
        sendButton.titleLabel?.font = .systemFontOfSize(15)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: .completePressed, forControlEvents: .TouchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.addConstraintsWithEdgeInsets(UIEdgeInsetsZero)

        return containerView
    }()

    override var inputAccessoryView: UIView? { return inputContainerView }
}

// MARK: - UITextFieldDelegate

extension PLCardInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        if expirationDatePicker.isPresented {
            expirationDatePicker.dismiss()
        }
    }
    
    @IBAction func didClickExpirationField() {
        for field in allFields {
            field.resignFirstResponder()
        }
        if !expirationDatePicker.isPresented {
            expirationDatePicker.presentOnView(view)
        } else {
            expirationDatePicker.dismiss()
        }
    }
}
