//
//  PLDate.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/29/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation


extension NSDate {
    
    convenience init(dateString: String, dateFormat: String = "yyyy-MM-dd") {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = dateFormat
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let date = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval: 0, sinceDate: date)
    }
    // NSDate(dateString: "2014-06-06")
    

    func timeAgoSinceDate() -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(self)
        let latest = earliest == now ? self : now
        
        let components = calendar.components([.Day, .WeekOfYear, .Month, .Year], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if components.year >= 2 { return "\(components.year) years ago" }
        else if components.year >= 1 { return "Last year" }
            
        else if components.month >= 2 { return "\(components.month) months ago" }
        else if components.month >= 1 { return "Last month" }
            
        else if components.weekOfYear >= 2 { return "\(components.weekOfYear) weeks ago" }
        else if components.weekOfYear >= 1 { return "Last week" }
            
        else if components.day >= 2 { return "\(components.day) days ago" }
        else if components.day >= 1 { return "Yesterday" }

        else { return "Today" }
    }

}