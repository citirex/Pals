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
        let backImage  = UIImage(named: "white_left_arrow")!.imageWithRenderingMode(.AlwaysOriginal)
        let backButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
        backButton.setImage(backImage, forState: .Normal)
        backButton.layer.shadowRadius = 5
        backButton.layer.shadowOpacity = 1.0
        backButton.layer.shadowOffset = CGSizeMake(2, 2)
        backButton.layer.shadowColor = UIColor.blackColor().CGColor
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), forControlEvents:.TouchUpInside)
        customView = backButton
    }
    
    
    func backButtonTapped(sender: UIBarButtonItem) {
        didTappedBackButton!()
    }

//    typealias didTappedBackButtonDelegate = Void -> Void
//    var didTappedBackButton: didTappedBackButtonDelegate?
//    
//    override init() {
//        super.init()
//        setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    
//    func setup() {
//        let button = UIButton()
//        button.setImage(UIImage(named: "white_left_arrow"), forState: .Normal)
//        button.frame = CGRectMake(0, 0, 22, 22)
//        button.bounds = CGRectOffset(button.bounds, -14, -7)
//        button.addTarget(self, action: #selector(backButtonTapped(_:)), forControlEvents: .TouchUpInside)
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
//        button.layer.shadowOpacity = 1.0
//        button.layer.shadowRadius = 5
//        button.layer.shadowColor = UIColor.blackColor().CGColor
//        button.layer.shadowOffset = CGSizeMake(2, 2)
//        button.tintColor = UIColor.redColor()
//        customView = button
        
        
//        let backImage  = UIImage(named: "white_left_arrow")!.imageWithRenderingMode(.AlwaysOriginal)
//        let backButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
//        backButton.setImage(backImage, forState: .Normal)
//        backButton.layer.shadowRadius = 5
//        backButton.layer.shadowOpacity = 1.0
//        backButton.layer.shadowOffset = CGSizeMake(2, 2)
//        backButton.layer.shadowColor = UIColor.blackColor().CGColor
//        backButton.transform = CGAffineTransformMakeTranslation(-20, 0)
//        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), forControlEvents:.TouchUpInside)
//        
//
//        
//        
//        
//        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
//        negativeSpacer.width = -16
//        navigationController.navigationItem.setLeftBarButtonItems([negativeSpacer, backButton], animated: false)
        
        //        let backButtonView = UIView(frame: backButton.frame)
        //        backButtonView.addSubview(backButton)
        //        customView = backButtonView
        
//        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, requiredButton /* this will be the button which you actually need */] animated:NO];
//    }
//    
//    func backButtonTapped(sender: UIBarButtonItem) {
//        didTappedBackButton!()
//    }
    
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
 
