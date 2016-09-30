//
//  PLDate.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/29/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

enum PLDateType: Int {
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


extension NSDate {
    
    private var dateComponents: NSDateComponents {
        let calander = NSCalendar.currentCalendar()
        return calander.components([.Day, .Month, .Year], fromDate: self, toDate: NSDate(), options: [])
    }
    
    
    var since: String {
        
        if dateComponents.year > 0 {
            return dateComponents.year < 2 ? "Last Year" : String(format: "%d Years Ago", dateComponents.year)
        }
        
        if dateComponents.month > 0 {
            return dateComponents.month < 2 ? "Last Month" : String(format: "%d Months Ago", dateComponents.month)
        }

        if dateComponents.day >= 7 {
            let week = dateComponents.day / 7
            return week < 2 ? "Last Week" : String(format: "%d Weeks Ago", week)
        }
            
        if dateComponents.day > 0 {
            return dateComponents.day < 2 ? "Yesterday" : String(format: "%d Days Ago", dateComponents.day)
        }

        return "Today"
    }

}