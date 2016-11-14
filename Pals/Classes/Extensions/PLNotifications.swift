//
//  PLNotifications.swift
//  Pals
//
//  Created by ruckef on 14.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLNotificationType: String {
    case ProfileChanged
    case ProfileSet
    var str: String {return rawValue}
}

class PLNotifications {
    
    static func postNotification(notificationType: PLNotificationType) {
        postNotification(notificationType, object: nil)
    }
    
    static func postNotification(notificationType: PLNotificationType, object: AnyObject!) {
        NSNotificationCenter.defaultCenter().postNotificationName(notificationType.str, object: object)
    }
}
