//
//  PLDate.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/29/16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLPassedDateType: Int {
    case Today
    case Yesterday
    case DaysAgo
    case LastWeek
    case WeeksAgo
    case LastMonth
    case MonthsAgo
    case LastYear
    case YearsAgo
    var string: String {
        switch self {
        case .Today:
            return "Today"
        case .Yesterday:
            return "Yesterday"
        case .DaysAgo:
            return "Days"
        case .LastWeek:
            return "Last Week"
        case .WeeksAgo:
            return "Weeks"
        case .LastMonth:
            return "Last Month"
        case .MonthsAgo:
            return "Months"
        case .LastYear:
            return "Last Year"
        case .YearsAgo:
            return "Years"
        }
    }
}

enum PLDateType {
    case Time
    case Date
}

extension NSDate {
   
    var dateComponent: (PLPassedDateType, Int) {
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
    
    var dateType: PLPassedDateType {
        return dateComponent.0
    }
    
    var since: String {
        let component = dateComponent
        let dateStr = component.0.string
        return component.1 > 1 ? "\(component.1) \(dateStr) Ago" : dateStr
    }

    func stringForStyles(dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.stringFromDate(self)
    }
    
    func stringForType(dateType: PLDateType, style: NSDateFormatterStyle) -> String {
        let formatter = NSDateFormatter()
        switch dateType {
        case .Date:
            formatter.dateStyle = style
            formatter.timeStyle = .NoStyle
        case .Time:
            formatter.timeStyle = style
            formatter.dateStyle = .NoStyle
        }
        return formatter.stringFromDate(self)
    }
    
}