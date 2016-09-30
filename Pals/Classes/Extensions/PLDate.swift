//
//  PLDate.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/29/16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLDateType: Int {
    case Today
    case Yesterday
    case DaysAgo
    case LastWeek
    case WeeksAgo
    case LastMonth
    case MonthsAgo
    case LastYear
    case YearsAgo
}


extension NSDate {
   
    var dateComponent: (PLDateType, Int) {
        let calendar = NSCalendar.currentCalendar()
        let units: NSCalendarUnit = [.Day, .WeekOfMonth, .Month, .Year]
        let dateComp = calendar.components(units, fromDate: self)
        let currentComp = calendar.components(units, fromDate: NSDate())
//        PLLog("curr \(currentComp.day) : \(currentComp.weekOfMonth) : \(currentComp.month) : \(currentComp.year)")
//        PLLog("matc \(dateComp.day) : \(dateComp.weekOfMonth) : \(dateComp.month) : \(dateComp.year)")
        if dateComp.year < currentComp.year {
            if dateComp.year == currentComp.year-1 {
                return (.LastYear, 1)
            } else {
                return (.YearsAgo, currentComp.year - dateComp.year)
            }
        } else if dateComp.month < currentComp.month {
            if dateComp.month == currentComp.month-1 {
                return (.LastMonth, 1)
            } else {
                return (.MonthsAgo, currentComp.month - dateComp.month)
            }
        } else if dateComp.weekOfMonth < currentComp.weekOfMonth {
            if dateComp.weekOfMonth == currentComp.weekOfMonth-1 {
                return (.LastWeek, 1)
            } else {
                return (.WeeksAgo, currentComp.weekOfMonth - dateComp.weekOfMonth)
            }
        } else if dateComp.day < currentComp.day {
            if dateComp.day == currentComp.day-1 {
                return (.Yesterday, 1)
            } else {
                return (.DaysAgo, currentComp.day - dateComp.day)
            }
        }
        return (.Today, 1)
    }
    
    var dateType: PLDateType {
        return dateComponent.0
    }
    
    var since: String {
        
//        if dateComponents.year > 0 {
//            return dateComponents.year < 2 ? "Last Year" : String(format: "%d Years Ago", dateComponents.year)
//        }
//        
//        if dateComponents.month > 0 {
//            return dateComponents.month < 2 ? "Last Month" : String(format: "%d Months Ago", dateComponents.month)
//        }
//
//        if dateComponents.day >= 7 {
//            let week = dateComponents.day / 7
//            return week < 2 ? "Last Week" : String(format: "%d Weeks Ago", week)
//        }
//            
//        if dateComponents.day > 0 {
//            return dateComponents.day < 2 ? "Yesterday" : String(format: "%d Days Ago", dateComponents.day)
//        }

        return "Today"
    }

}