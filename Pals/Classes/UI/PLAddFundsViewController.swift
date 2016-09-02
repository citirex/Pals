//
//  PLAddFundsViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/2/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLAddFundsViewController: UIViewController, UITextFieldDelegate {
    
    let sumView = UINib(nibName: "PLAddFundsView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLAddFundsView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sumView.frame = view.bounds
        view.addSubview(sumView)
        sumView.sumTextField.delegate = self   
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if sumView.sumTextField.canBecomeFirstResponder() {
            sumView.sumTextField.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        sumView.sumTextField.resignFirstResponder()
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }

}
