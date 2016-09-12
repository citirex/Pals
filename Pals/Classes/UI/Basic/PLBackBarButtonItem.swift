//
//  PLBackBarButtonItem.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/12/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLBackBarButtonItem: UIBarButtonItem {

    typealias didTappedBackButtonDelegate = Void -> Void
    var didTappedBackButton: didTappedBackButtonDelegate?
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let button = UIButton()
        button.setImage(UIImage(named: "white_left_arrow"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        button.addTarget(self, action: #selector(backButtonTapped(_:)), forControlEvents: .TouchUpInside)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSizeMake(0, 3)
        customView = button
    }
    
    func backButtonTapped(sender: UIBarButtonItem) {
        didTappedBackButton!()
    }
    
}


/// Example:

 /*
 
override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let backButtonItem = PLBackBarButtonItem()
    navigationItem.leftBarButtonItem = backButtonItem
    backButtonItem.didTappedBackButton = {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
 
 */
 
