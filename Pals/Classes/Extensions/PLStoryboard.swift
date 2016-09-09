//
//  PLStoryboard.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/2/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

enum PLStoryboardType : String {
    case LoginViewController
    case TabBarController
    case FriendsViewController
    case LocationsViewController
    case OrderLocationsViewController
    case OrderFriendsViewController
    var string: String {return rawValue}
}

extension UIStoryboard {
    
    class var mainStoryboard: UIStoryboard { return UIStoryboard(name: "Main", bundle: .mainBundle()) }
    
    class func tabBarController() -> UIViewController? {
        return viewControllerWithType(.TabBarController)
    }
    
    class func viewControllerWithType(type: PLStoryboardType) -> UIViewController? {
        return mainStoryboard.instantiateViewControllerWithIdentifier(type.string)
    }
    
    class func loginViewController() -> PLLoginViewController? {
        return viewControllerWithType(.LoginViewController) as? PLLoginViewController
    }
 
}