//
//  PLBackBarButtonItem.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/12/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLBackBarButtonItem: UIBarButtonItem {
    
    typealias PLTapBackButtonDelegate = Void -> Void
    var didTapBackButton: PLTapBackButtonDelegate?
    
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let backImage  = UIImage(named: "back_arrow")!.imageWithRenderingMode(.AlwaysOriginal)
        let backButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
        backButton.setImage(backImage, forState: .Normal)
        backButton.layer.shadowRadius  = 5
        backButton.layer.shadowOpacity = 1.0
        backButton.layer.shadowOffset  = CGSizeMake(2, 2)
        backButton.layer.shadowColor   = UIColor.blackColor().CGColor
        backButton.addTarget(self, action: .backButtonTap, forControlEvents: .TouchUpInside)
        customView = backButton
    }
    
    
    func backButtonTapped(sender: UIBarButtonItem) {
        didTapBackButton!()
    }
    
}


