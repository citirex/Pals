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
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        balanceTextField.text = "$0"
    }
 
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .Default
        navigationController?.navigationBar.tintColor = .eminenceColor()
        navigationController?.setNavigationBarTransparent(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.tintColor = .whiteColor()
        navigationController?.setNavigationBarTransparent(false)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        balanceTextField.becomeFirstResponder()
    }
    
   
    //MARK: - Actions
    
    func refillButtonPressed(sender: AnyObject) {
        showAlert()
    }
    
    
    // MARK: - Alert
    
    private func showAlert() {
        let alertController = UIAlertController(title: "You amount was \(balanceTextField.text!)", message: "Are you sure?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Destructive) { action in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { action in
            self.view.endEditing(true)
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    
    // MARK: - AccessoryView on keyboard
    
    private func inputAccessoryView() -> UIView {
        let accessoryView = UIButton(type: .System)
        accessoryView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        accessoryView.tintColor = .whiteColor()
        accessoryView.setTitle("Refill", forState: .Normal)
        accessoryView.titleLabel?.font = UIFont.systemFontOfSize(17)
        accessoryView.backgroundColor = .caribeanGreenColor()
        accessoryView.addTarget(self, action: #selector(refillButtonPressed(_:)), forControlEvents: .TouchUpInside)
        return accessoryView
    }
    
}



//MARK: - TextField Delegate
extension PLAddFundsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.inputAccessoryView = inputAccessoryView()
    }
    
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
