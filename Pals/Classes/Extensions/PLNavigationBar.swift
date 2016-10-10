//
//  PLNavigationBar.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/2/16.
//  Copyright © 2016 citirex. All rights reserved.
//


extension UINavigationBar {
    
    var height: CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.height + frame.height
    }
    
    private var transparent: Bool {
        get {
            return false
        }
        set {
            setBackgroundImage(UIImage(), forBarMetrics: .Default)
            shadowImage = UIImage()
            translucent = newValue
        }
    }
    
    enum Style {
        case Default
        case ProfileStyle
        case AddFundsStyle
        case FriendsStyle
        case FriendProfileStyle
        case OrderStyle
        case PlacesStyle
        case PlaceProfileStyle
        case SettingsStyle
        case EditProfileStyle
        case CardInfoStyle
        case OrderHistoryStyle
        case NotificationsStyle
    }
    
    var style: Style {
        get { return .Default }
        set (style) {
            switch style {
            case .AddFundsStyle:
                transparent = true
                barStyle = .Default
                tintColor = .affairColor()
            case .FriendsStyle:
                transparent = false
                barStyle = .Default
                tintColor = .affairColor()
            case .PlacesStyle:
                transparent = false
                barStyle = .Black
                barTintColor = .affairColor()
            case .SettingsStyle:
                transparent = false
                barStyle = .Black
                tintColor = .whiteColor()
                barTintColor = .affairColor()
            case .NotificationsStyle:
                transparent = false
                barStyle = .Black
                tintColor = .whiteColor()
                barTintColor = .affairColor()
            default:
                transparent = true
                barStyle = .Black
                tintColor = .whiteColor()
            }
            titleTextAttributes = attributes(style)
        }
    }
    
    private func attributes(style: Style) -> [String : AnyObject]? {
        var titleColor = UIColor()
        switch style {
        case .FriendsStyle: titleColor = .affairColor()
        default: titleColor = .whiteColor()
        }
        return [NSForegroundColorAttributeName : titleColor]
    }
    
}



