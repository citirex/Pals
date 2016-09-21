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
    
    func setNavigationBarTransparent(transparent: Bool) {
        navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = transparent
    }

}