//
//  PLCardInfoViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/15/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLCardInfoViewController: PLViewController {
    
    @IBOutlet weak var creditCardNumberTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var cvvCodeTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(dismissTap)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarTransparent(true)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarTransparent(false)
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        creditCardNumberTextField.becomeFirstResponder()
    }

    
    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    // MARK: - Actions
    
    func completeButtonTapped(sender: AnyObject) {
        dismissKeyboard(sender)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func textFieldEditing(sender: UITextField) {
        let datePicker  = UIDatePicker()
        datePicker.datePickerMode = .Date
        sender.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: .ValueChanged)
    }
    
    
    // MARK: - Date Picker
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        expirationDateTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    

    
    // MARK: - AccessoryView on keyboard
    
    private func inputAccessoryView() -> UIView {
        let accessoryView = UIButton(type: .System)
        accessoryView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        accessoryView.setTitle("Complete", forState: .Normal)
        accessoryView.backgroundColor = .whiteColor()
        accessoryView.tintColor = .mediumOrchidColor()
        accessoryView.addBottomBorderWithColor(.lightGrayColor(), width: 0.5)
        accessoryView.addTarget(self, action: #selector(completeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        return accessoryView
    }
    

}


// MARK: - UITextFieldDelegate

extension PLCardInfoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.inputAccessoryView = inputAccessoryView()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange
        range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case creditCardNumberTextField: print()
        case expirationDateTextField: print()
        case zipCodeTextField: print()
        case cvvCodeTextField: print()
        default:
            break
        }
        return true
    }
    
}





