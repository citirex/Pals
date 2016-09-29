//
//  PLCardInfoViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/15/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLCardInfoViewController: PLViewController {
    
    @IBOutlet weak var creditCardNumberTextField: PLTextField!
    @IBOutlet weak var expirationDateTextField: PLTextField!
    @IBOutlet weak var zipCodeTextField: PLTextField!
    @IBOutlet weak var cvvCodeTextField: PLTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTapped()
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
        accessoryView.frame = CGRectMake(0, 0, view.bounds.width, 50)
        accessoryView.titleLabel?.font = .customFontOfSize(15)
        accessoryView.setTitle("Complete", forState: .Normal)
        accessoryView.tintColor = .mediumOrchidColor()
        accessoryView.backgroundColor = .whiteColor()
        accessoryView.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
        accessoryView.addTarget(self, action: .completeButtonTap, forControlEvents: .TouchUpInside)
        return accessoryView
    }

}


// MARK: - UITextFieldDelegate

extension PLCardInfoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.inputAccessoryView = inputAccessoryView()
    }
    
}





