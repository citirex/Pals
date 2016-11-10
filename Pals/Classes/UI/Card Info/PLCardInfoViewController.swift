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
        prefillCardFields()
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
        if !PLFacade.profile!.hasPaymentCard {
            creditCardNumberTextField.becomeFirstResponder()
        }
    }
    
    func prefillCardFields() {
        if let source = PLFacade.profile?.customer?.paymentSource {
            if let expDate = source.expirationDate {
                expirationDateTextField.text = source.expirationDate?.string
                cardForm.expYear = UInt(expDate.year)
                cardForm.expMonth = UInt(expDate.month)
            }
            zipCodeTextField.text = source.zip
            prefillCardNumber(source.last4)
            prefillCVC()
        }
    }
    
    func prefillCardNumber(last4: String?) {
        if last4 != nil {
            creditCardNumberTextField.text = "●●●● ●●●● ●●●● \(last4!)"
        } else {
            creditCardNumberTextField.text = "●●●● ●●●● ●●●● ●●●●"
        }
    }
    
    func prefillCVC() {
        cvvCodeTextField.text = "●●●"
    }
    
    func textFieldChanged(notification: NSNotification) {
        let field = notification.object as! UITextField
        let text = field.text
        if field === creditCardNumberTextField {
            field.text = addWhiteSpacesToNumberString(text)
            cardForm.number = text?.removedWhitespaces()
        } else if field === zipCodeTextField {
            cardForm.addressZip = text
        } else if field === cvvCodeTextField {
            let cvc = trimCVCto3Chars(text)
            field.text = cvc
            cardForm.cvc = cvc
        }
    }
    
    func trimCVCto3Chars(cvc: String?) -> String? {
        if var str = cvc {
            if str.characters.count > 3 {
                str = str.substringToIndex(str.startIndex.advancedBy(3))
            }
            return str
        }
        return nil
    }
    
    func addWhiteSpacesToNumberString(string: String?) -> String? {
        if var str = string {
            str = str.stringByReplacingOccurrencesOfString(" ", withString: "")
            if str.characters.count > 16 {
                str = str.substringToIndex(str.startIndex.advancedBy(16))
            }
            var fourDigitArray = [String]()
            var fourDigits = [Character]()
            for i in 0..<str.characters.count {
                let character = str[str.startIndex.advancedBy(i)]
                let fold = i%4 == 0 && i != 0
                if fold {
                    fourDigitArray.append(String(fourDigits))
                    fourDigits = [Character]()
                }
                fourDigits.append(character)
            }
            fourDigitArray.append(String(fourDigits))
            let newStr = fourDigitArray.joinWithSeparator(" ")
            return newStr
        }
        return nil
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
        if PLFacade.profile!.hasPaymentCard {
            if textField === creditCardNumberTextField {
                if let number = cardForm.number where !number.isEmpty {
                    textField.text = addWhiteSpacesToNumberString(number)
                } else {
                    textField.text = nil
                }
            } else if textField === cvvCodeTextField {
                textField.text = cardForm.cvc
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if PLFacade.profile!.hasPaymentCard {
            if let text = textField.text {
                if text.isEmpty {
                    if textField === creditCardNumberTextField {
                        prefillCardNumber(PLFacade.profile?.customer?.paymentSource?.last4)
                    } else if textField === cvvCodeTextField {
                        prefillCVC()
                    }
                }
            }
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
        expirationDateTextField.text = date.string
        cardForm.expMonth = UInt(date.month)
        cardForm.expYear = UInt(date.year)
    }
}
