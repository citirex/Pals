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
    @IBOutlet private weak var expirationDateActivateButton: UIButton?
    @IBOutlet private weak var zipCodeTextField:          PLFormTextField!
    @IBOutlet private weak var cvvCodeTextField:          PLFormTextField!
    private var allFields = [UITextField]()
    
    lazy var expirationDatePicker = PLExpirationDatePicker()
    lazy var cardForm = STPCardParams()
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textFieldChanged(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        creditCardNumberTextField.becomeFirstResponder()
    }
    
    func textFieldChanged(notification: NSNotification) {
        let field = notification.object as! UITextField
        let text = field.text
        if field === creditCardNumberTextField {
            cardForm.number = text
        } else if field === zipCodeTextField {
            cardForm.addressZip = text
        } else if field === cvvCodeTextField {
            cardForm.cvc = text
        }
    }
    
    func enableControls(enabled: Bool) {
        allFields.forEach { (field) in
            field.enabled = enabled
        }
        expirationDateActivateButton?.enabled = enabled
    }
    
    // MARK: - Actions
    
    func completePressed(sender: UIButton) {
        dismissKeyboard(sender)
        let state = STPCardValidator.validationStateForCard(cardForm)
        switch state {
        case .Valid:
            startActivityIndicator(.WhiteLarge)
            enableControls(false)
            PLFacade.addPaymentCard(cardForm, completion: { (error) in
                self.stopActivityIndicator()
                self.enableControls(true)
                if error != nil {
                    PLShowErrorAlert(error: error!)
                } else{
                    PLShowAlert("You have successfully added your card details") {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }
            })
        case .Invalid:
            PLShowAlert("Card data is invalid")
        case .Incomplete:
            PLShowAlert("Please, fill all required fields (card number, expiration date, cvc)")
        }
    }

    // MARK: - Lazy
    
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
}

// MARK: - PLExpirationDatePickerDelegate

extension PLCardInfoViewController : PLExpirationDatePickerDelegate {
    
    @IBAction func didClickExpirationField() {
        for field in allFields {
            field.resignFirstResponder()
        }
        if !expirationDatePicker.isPresented {
            expirationDatePicker.delegate = self
            expirationDatePicker.presentOnView(view)
        } else {
            expirationDatePicker.dismiss()
        }
    }
    
    func expirationDatePicker(picker: PLExpirationDatePicker, didChangeDate date: PLExpirationDate) {
        let last2Year = date.year%1000
        expirationDateTextField.text = String(format: "%.2d/%d", date.month, last2Year)
        cardForm.expMonth = UInt(date.month)
        cardForm.expYear = UInt(date.year)
    }
}
