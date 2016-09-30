//
//  PLDate.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/29/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

enum PLDateComponent: Int {
    case YearsAgo
    case MonthsAgo
    case WeeksAgo
    case DaysAgo
    case LastYear
    case LastMonth
    case LastWeek
    case Yesterday
    case Today
}

extension PLDateComponent {
    
    var description: String {
        switch self {
        case .YearsAgo:  return ""
        case .MonthsAgo: return ""
        case .WeeksAgo:  return ""
        case .DaysAgo:   return ""
        case .LastYear:  return ""
        case .LastMonth: return ""
        case .LastWeek:  return ""
        case .Yesterday: return ""
        case .Today:     return ""
        }
    }
}





extension NSDate {
    
    private var dateComponents: NSDateComponents {
        let calander = NSCalendar.currentCalendar()
        return calander.components([.Day, .Month, .Year], fromDate: self, toDate: NSDate(), options: [])
    }
    
    
    var since: String {
        
        if dateComponents.year > 0 {
            if dateComponents.year < 2 {
                return "Last year"
            } else {
                return String(format: "%d Years Ago", dateComponents.year)
            }
        }
        
        if dateComponents.month > 0 {
            if dateComponents.month < 2 {
                return "Last month"
            } else {
                return String(format: "%d Months Ago", dateComponents.month)
            }
        }

        if dateComponents.day >= 7 {
            let week = dateComponents.day / 7
            if week < 2 {
                return "Last week"
            } else {
                return String(format: "%d Weeks Ago", week)
            }
        }
            
        if dateComponents.day > 0 {
            if dateComponents.day < 2 {
                return "Yesterday"
            } else  {
                return String(format: "%d Days Ago", dateComponents.day)
            }
        }

        return "Today"
    }



    // NSDate(dateString: "2014-06-06")
    convenience init(dateString: String, dateFormat: String = "yyyy-MM-dd") {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = dateFormat
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let date = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval: 0, sinceDate: date)
    }
    
}