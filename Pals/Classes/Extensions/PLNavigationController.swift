//
//  PLNavigationController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/4/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
//    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
    
    func setNavigationBarTransparent(transparent: Bool) {
        navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = transparent
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