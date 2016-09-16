//
//  PLRefillBalanceViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/16/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLRefillBalanceViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var numberTextField: UITextField! {
        didSet {
            numberTextField.text = String(format: "$%d", balance ?? 0)
        }
    }
    
    private let margin: CGFloat = 40.0
    private let digitsLimit = 6

    var balance: UInt?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAlert()
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(dismissTap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        registerKeyboardNotifications()
    }
 
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    // MARK: - Notifications
    
    private func registerKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + margin, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if CGRectContainsPoint(visibleRect, numberTextField!.frame.origin) {
            scrollView.scrollRectToVisible(numberTextField!.frame, animated: true)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    
    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }


    // Actions

    @IBAction func refillButtonTapped(sender: UIButton) {
        print("Refill tapped")
        dismissKeyboard(sender)
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
    
    
    // MARK: - AccessoryView on keyboard
    
    private func inputAccessoryView() -> UIView {
        let accessoryView = UIButton(type: .System)
        accessoryView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        accessoryView.setTitle("Refill", forState: .Normal)
        accessoryView.backgroundColor = .refillButtonBackgroudColor()
        accessoryView.tintColor = .whiteColor()
        accessoryView.addTarget(self, action: #selector(refillButtonTapped(_:)), forControlEvents: .TouchUpInside)
        return accessoryView
    }
    
    
    // MARK: - Alert
    
    func showAlert() {
        let alertController = UIAlertController(title: "You amount was \(numberTextField.text!)", message: "Are you sure?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Destructive) { action in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { action in
            
        }
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    
}


// MARK: - UIScrollViewDelegate

extension PLRefillBalanceViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dismissKeyboard(scrollView)
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        dismissKeyboard(scrollView)
        return true
    }
    
}


// MARK: - UITextFieldDelegate

extension PLRefillBalanceViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
        textField.inputAccessoryView = inputAccessoryView()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let digitalCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
        let isDigits = string.rangeOfCharacterFromSet(digitalCharacterSet) == nil
        
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        let isCorrectLimit = newLength <= digitsLimit
        
        if range.length > 0 && range.location == 0 {
            let changedText = NSString(string: textField.text!).substringWithRange(range)
            if changedText.containsString("$") {
                return false
            }
        }
        return isDigits && isCorrectLimit
    }
    
}


