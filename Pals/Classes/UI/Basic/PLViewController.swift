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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.activityIndicator != nil {
            stopActivityIndicator()
        }
    }
    
}

extension PLViewController {
    
    func loadData<T : PLDatedObject where T : PLFilterable>
        (datasource: PLDatasource<T>, onLoad: () -> UITableView ) {
        datasource.cancel()
        datasource.loadPage {[unowned self] (indices, error) in
            self.stopActivityIndicator()
            let table: UITableView = onLoad()
            self.didLoadPage(table, indices: indices, error: error)
        }
    }
    
    func didLoadPage(table:UITableView, indices: [NSIndexPath], error: NSError?) {
        table.reloadEmptyDataSet()
        if error == nil {
            table.beginUpdates()
            table.insertRowsAtIndexPaths(indices, withRowAnimation: .Bottom)
            table.endUpdates()
        } else {
            PLShowErrorAlert(error: error!)
        }
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
    
    enum PLPosition {
        case Center
        case Bottom
    }

    var activityIndicatorTag: Int { return 999999 }
    
    var activityIndicator: UIActivityIndicatorView? {
        return self.targetView.viewWithTag(self.activityIndicatorTag) as? UIActivityIndicatorView
    }
    
    var targetView: UIView {
        var targetView: UIView?
        if let navVC = self.navigationController {
            targetView = navVC.view
        } else {
            targetView = self.view
        }
        return targetView!
    }
    
    func startActivityIndicator(style: UIActivityIndicatorViewStyle, color: UIColor? = nil, position: PLPosition = .Center) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tag = self.activityIndicatorTag
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = color
        activityIndicator.startAnimating()
        self.targetView.addSubview(activityIndicator)
        self.targetView.bringSubviewToFront(activityIndicator)
        self.addConstraints(activityIndicator, position: position)
    }
    
    func stopActivityIndicator() {
        if let spinner = self.activityIndicator {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
    
    private func addConstraints(activityIndicator: UIActivityIndicatorView, position: PLPosition) {
        switch position {
        case .Center:
            activityIndicator.autoCenterInSuperview()
        case .Bottom:
            activityIndicator.autoAlignAxis(.Horizontal, toSameAxisOfView: self.targetView, withMultiplier: 1.65)
            activityIndicator.autoAlignAxisToSuperviewAxis(.Vertical)
        }
    }

}
