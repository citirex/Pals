//
//  PLStoryboard.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/2/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation


extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: .mainBundle()) }
    
    class func tabBarController() -> UIViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TabBarController")
    }
 
}