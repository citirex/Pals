//
//  PLCardInfoViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/15/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLCardInfoViewController: PLViewController {
    
    @IBOutlet weak var creditCardNumberTextField: PLFormTextField!
    @IBOutlet weak var expirationDateTextField: PLFormTextField!
    @IBOutlet weak var zipCodeTextField: PLFormTextField!
    @IBOutlet weak var cvvCodeTextField: PLFormTextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTapped = true
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
        sendButton.titleLabel?.font = .customFontOfSize(15)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: .completePressed, forControlEvents: .TouchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.addConstraintCentered()

        return containerView
    }()

    
    override var inputAccessoryView: UIView? { return inputContainerView }

}


// MARK: - UITextFieldDelegate

extension PLCardInfoViewController: UITextFieldDelegate {

}





