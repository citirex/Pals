//
//  PLDate.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/29/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

enum PLDateType {
    case YearsAgo(Int), MonthsAgo(Int), WeeksAgo(Int), DaysAgo(Int), LastYear, LastMonth, LastWeek, Yesterday, Today
    
    var description: String {
        switch self {
        case .YearsAgo(let amount):  return String(format: "%d Years Ago", amount)
        case .MonthsAgo(let amount): return String(format: "%d Months Ago", amount)
        case .WeeksAgo(let amount):  return String(format: "%d Weeks Ago", amount)
        case .DaysAgo(let amount):   return String(format: "%d Days Ago", amount)
        case .LastYear:              return "Last Year"
        case .LastMonth:             return "Last Month"
        case .LastWeek:              return "Last Week"
        case .Yesterday:             return "Yesterday"
        case .Today:                 return "Today"
        }
    }
}



extension NSDate {
    
    var since: String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(self)
        let latest = earliest == now ? self : now
        
        let components = calendar.components([.Day, .WeekOfYear, .Month, .Year], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if components.year >= 2 { return "\(components.year) Years Ago" }
        else if components.year >= 1 { return "LastYear" }
            
        else if components.month >= 2 { return "\(components.month) Months Ago" }
        else if components.month >= 1 { return "LastMonth" }
            
        else if components.weekOfYear >= 2 { return "\(components.weekOfYear) Weeks Ago" }
        else if components.weekOfYear >= 1 { return "LastWeek" }
            
        else if components.day >= 2 { return "\(components.day) Days Ago" }
        else if components.day >= 1 { return "Yesterday" }

        else { return "Today" }
    }

    
    
    private func dateComponents() -> NSDateComponents {
        let calander = NSCalendar.currentCalendar()
        return calander.components([.Day, .WeekOfYear, .Month, .Year], fromDate: self, toDate: NSDate(), options: [])
    }
    
    
    convenience init(dateString: String, dateFormat: String = "yyyy-MM-dd") {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = dateFormat
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let date = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval: 0, sinceDate: date)
    }
    // NSDate(dateString: "2014-06-06")

}