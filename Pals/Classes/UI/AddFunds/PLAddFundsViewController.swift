//
//  PLAddFundsViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/2/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLAddFundsViewController: PLViewController, UITextFieldDelegate {
    
    let sumView = UINib(nibName: "PLAddFundsView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLAddFundsView
    var refillSum: String {
        guard let sum = sumView.sumTextField.text?.substringFromIndex(sumView.sumTextField.text!.startIndex.advancedBy(1)) where sum.isEmpty == false else { return "0" }
            return sum
    }
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sumView.frame = view.bounds
        view.addSubview(sumView)
        sumView.sumTextField.delegate = self
        sumView.sumTextField.text = "$0"
        
        let buttonFrame = CGRectMake(0, 0, sumView.bounds.size.width, 44)
        let refillButton = UIButton(frame: buttonFrame)
        refillButton.setTitle("Refill", forState: .Normal)
        refillButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        refillButton.backgroundColor = UIColor(red:0.17, green:0.83, blue:0.61, alpha:1.0)
        refillButton.addTarget(self, action: #selector(refillButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        sumView.sumTextField.inputAccessoryView = refillButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if sumView.sumTextField.canBecomeFirstResponder() {
            sumView.sumTextField.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        sumView.sumTextField.resignFirstResponder()
    }
    
    //MARK: - TextField Delegate
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
    
    
    //MARK: - Actions
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        print("Cancel refilling")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refillButtonPressed(sender: AnyObject) {
        print("Refill by: [\(refillSum)]")
        dismissViewControllerAnimated(true, completion: nil)
    }
}
