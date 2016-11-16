//
//  PLNotifications.swift
//  Pals
//
//  Created by ruckef on 14.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendNotification {
    var friend: PLUser
    var section: PLOrderSection
    
    init(friend: PLUser, section: PLOrderSection) {
        self.friend = friend
        self.section = section
    }
}

class PLPlaceEventNotification {
    var place: PLPlace
    var event: PLEvent?
    
    convenience init(place: PLPlace){
        self.init(place: place, event: nil)
    }
    init(place: PLPlace, event: PLEvent?) {
        self.place = place
        self.event = event
    }
}

enum PLNotificationType: String {
    case ProfileChanged
    case ProfileSet
    case PlaceDidSelect
    case FriendSend
    var str: String {return rawValue}
}

class PLNotifications {
    
    static func postNotification(type: PLNotificationType) {
        postNotification(type, object: nil)
    }
    
    static func postNotification(type: PLNotificationType, object: AnyObject!) {
        NSNotificationCenter.defaultCenter().postNotificationName(type.str, object: object)
    }

    static func addObserver(observer: AnyObject, selector: Selector, type: PLNotificationType) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: type.str, object: nil)
    }
    
    static func removeObserver(observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
}
