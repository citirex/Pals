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
    @IBOutlet weak var scrollView: UIScrollView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(dismissTap)
    }

    
    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    // MARK: - Actions
    
    @IBAction func completeButtonTapped(sender: AnyObject) {
        print("completeButtonTapped")
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

    
    // AccessoryView on keyboard
    
    private func createAccessoryView() -> UIView {
        let accessoryView = UIButton(type: .System)
        accessoryView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        accessoryView.setTitle("Complete", forState: .Normal)
        accessoryView.backgroundColor = .whiteColor()
        accessoryView.tintColor = .completeButtonTintColor()
        accessoryView.addBottomBorderWithColor(.lightGrayColor(), width: 0.5)
        accessoryView.addTarget(self, action: #selector(completeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        return accessoryView
    }
    

}


// MARK: - UITextFieldDelegate

extension PLCardInfoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.inputAccessoryView = createAccessoryView()
    }
}


// MARK: - UIScrollViewDelegate

extension PLCardInfoViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dismissKeyboard(self)
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        dismissKeyboard(self)
        return true
    }
    
}





