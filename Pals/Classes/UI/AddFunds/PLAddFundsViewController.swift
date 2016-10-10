//
//  PLAddFundsViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/2/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLAddFundsViewController: PLViewController {
    
//    var refillSum: String {
//        guard let sum = sumView.sumTextField.text?.substringFromIndex(sumView.sumTextField.text!.startIndex.advancedBy(1)) where sum.isEmpty == false else { return "0" }
//            return sum
//    }
    
    @IBOutlet weak var balanceTextField: UITextField!
    
    var user: PLUser!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        balanceTextField.text = "$0"
    }
 
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .AddFundsStyle
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        balanceTextField.becomeFirstResponder()
    }
    

   
    //MARK: - Actions
    
    func refillPressed(sender: AnyObject) {
        showAlert()
    }
    
    
    // MARK: - Alert
    
    private func showAlert() {
        let alertController = UIAlertController(title: "You amount was \(balanceTextField.text!)", message: "Are you sure?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Destructive) { action in }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { action in
            self.view.endEditing(true)
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }


    private lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
        containerView.backgroundColor = .chamrockColor()
        
        let sendButton = UIButton(type: .System)
        sendButton.tintColor = .whiteColor()
        sendButton.setTitle("Refill", forState: .Normal)
        sendButton.titleLabel?.font = .customFontOfSize(15)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: .refillPressed, forControlEvents: .TouchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.addConstraintCentered()
        
        return containerView
    }()
    
    
    override var inputAccessoryView: UIView? { return inputContainerView }
    
}



//MARK: - TextField Delegate
extension PLAddFundsViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.location > 0 && range.location < 6  {
            if textField.text?.hasPrefix("$0") == true {
                if string != "0" {
                    textField.text = "$" + string
                }
                return false
            }
            return true
        }
        return false
    }
}
