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

