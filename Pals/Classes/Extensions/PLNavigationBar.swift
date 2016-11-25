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
        get { return translucent }
        set {
            let image: UIImage? = newValue ? UIImage() : nil
            setBackgroundImage(image, forBarMetrics: .Default)
            shadowImage = image
            translucent = newValue
        }
    }
    
    enum Style {
        case Default
        case ProfileStyle
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
            case .FriendsStyle:
                transparent = false
                barStyle    = .Default
                barColor    = .whiteColor()
                tintColor   = .violetColor
            case .PlacesStyle:
                transparent = false
                barStyle    = .Black
                shadowImage = UIImage()
                tintColor   = .whiteColor()
                barColor    = .violetColor
            case .SettingsStyle:
                transparent = false
                barStyle    = .Black
                tintColor   = .whiteColor()
                barColor    = .violetColor
            case .NotificationsStyle:
                break
            default:
                transparent = true
                barStyle    = .Black
                tintColor   = .whiteColor()
            }
            titleTextAttributes = attributes(style)
        }
    }
    
    private var barColor: UIColor? {
        get { return barTintColor! }
        set {
            setBackgroundImage(UIImage(color: newValue!), forBarMetrics: .Default)
        }
    }
    
    private func attributes(style: Style) -> [String : AnyObject]? {
        var titleColor = UIColor()
        switch style {
        case .FriendsStyle:
            titleColor = .violetColor
        default:
            titleColor = .whiteColor()
        }
        return [NSForegroundColorAttributeName : titleColor]
    }
}