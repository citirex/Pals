//
//  PLViewController.swift
//  Pals
//
//  Created by ruckef on 09.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLViewController: UIViewController {
    
    lazy var spinner: UIActivityIndicatorView = {
        let spnr = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        self.view.addSubview(spnr)
        return spnr
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}


extension PLViewController {
    
    func hideKeyboardWhenTapped() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .dismissTap))
    }
    
    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
}

extension PLViewController {
    
    func performSegueWithIdentifier<T: RawRepresentable where T.RawValue == String>(identifier: T, sender: AnyObject?) {
        performSegueWithIdentifier(identifier.rawValue, sender: sender)
    }
}

extension PLViewController {
    
    func present(viewController: UIViewController, animated: Bool) {
        presentViewController(viewController, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool) {
        dismissViewControllerAnimated(animated, completion: nil)
    }
    
}
