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

    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}


extension UIViewController {

    var hideKeyboardWhenTapped: Bool {
        get {
            return false
        }
        set {
            if newValue { view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .dismissTap)) }
        }
    }
    
    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
}

extension UIViewController {
    
    func performSegueWithIdentifier<T: RawRepresentable where T.RawValue == String>(identifier: T, sender: AnyObject?) {
        performSegueWithIdentifier(identifier.rawValue, sender: sender)
    }
}

extension UIViewController {
    
    func present(viewController: UIViewController, animated: Bool) {
        presentViewController(viewController, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool) {
        dismissViewControllerAnimated(animated, completion: nil)
    }
    
}


extension UIViewController {

    var activityIndicatorTag: Int { return 999999 }
    
    func startActivityIndicator(style: UIActivityIndicatorViewStyle, color: UIColor? = nil) {
        dispatch_async(dispatch_get_main_queue(), {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.tag = self.activityIndicatorTag
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = color
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
            
            activityIndicator.autoCenterInSuperview()
        })
    }
    
    func stopActivityIndicator() {
        dispatch_async(dispatch_get_main_queue(), {
            if let activityIndicator = self.view.subviews.filter({
                $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        })
    }
}
