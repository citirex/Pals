//
//  PLOrderCheckoutPopupViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/20/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol CheckoutOrderPopupDelegate: class {
    func cancelButtonPressed()
    func sendButtonPressedWith(message: String)
}

class PLOrderCheckoutPopupViewController: UIViewController {

    private let placeholderText = "Write a message... (optional)"
    
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var messageTextView: UITextView!
    @IBOutlet private var popupView: UIView!
    
    var userName: String? = nil
    var locationName: String? = nil
    var orderAmount: String? = nil
    
    lazy private var tapGesture : UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(reciveTap(_:)))
    }()
    
    weak var delegate: CheckoutOrderPopupDelegate? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.hidden = true
        popupView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userNameLabel.text = userName
        locationLabel.text = locationName
        amountLabel.text = orderAmount
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    //MARK: - Actions
    func show() {
        popupView.alpha = 0
        view.alpha = 0
        view.hidden = false
        UIView.animateWithDuration(0.1, animations: {
            self.view.alpha = 1
            self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        }) { (complete) in
            self.popupView.transform = CGAffineTransformMakeScale(0, 0)
            self.popupView.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.size.height)
            self.popupView.alpha = 0.5
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.popupView.transform = CGAffineTransformIdentity
                self.popupView.alpha = 1
                }, completion: { (complete) in
                    
            })
        }
    }
    
    func hide() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.popupView.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.size.height)
            self.view.backgroundColor = UIColor.clearColor()
            }, completion: { (complete) in
                self.popupView.transform = CGAffineTransformIdentity
                self.view.alpha = 1
                self.dismissViewControllerAnimated(false, completion: nil)
                self.view.hidden = true
        })
    }
    
    @IBAction private func cancelButtonPressed(sender: UIButton) {
        delegate?.cancelButtonPressed()
    }
    
    @IBAction private func sendButtonPressed(sender: UIButton) {
        let message = (textViewText == placeholderText) ? "" : textViewText
        delegate?.sendButtonPressedWith(message)
    }
    
    @objc private var textViewText: String {
        get{
            return messageTextView.text
        }
        set{
            messageTextView.text = newValue
        }
    }
    
    @objc private func reciveTap(gesture: UITapGestureRecognizer) {
        if messageTextView.isFirstResponder() && messageTextView.canResignFirstResponder() {
            messageTextView.resignFirstResponder()
        }
    }
    
    private func addGestures() {
        view.addGestureRecognizer(tapGesture)
    }
    
    private func removeGestures() {
        view.removeGestureRecognizer(tapGesture)
    }

    
    //MARK: - Textview delegate
    func textViewDidBeginEditing(textView: UITextView) {
        addGestures()
        if textViewText == placeholderText {
            textViewText = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textViewText == "" {
            textViewText = placeholderText
        }
    }
}
