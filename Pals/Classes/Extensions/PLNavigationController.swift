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
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.translucent = true
        navigationBar.shadowImage = UIImage()
    }
    
    public func hideTransparentNavigationBar() {
        navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }
}