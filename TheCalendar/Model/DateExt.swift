//
//  CalendarDate.swift
//  xinOA
//
//  Created by Joe on 2021/6/10.
//

import Foundation

extension Date {
    /// 获取日期月份的天数
    /// - Returns: 日期月份的天数
    func getMonthDaysCount() -> Int {
        let theDate = getMonthLastDay()
        let components = Set.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day])
        let theDateComponents = Calendar.current.dateComponents(components, from: theDate)
        return theDateComponents.day!
    }
    
    /// 获取日期月份的第一天Date
    /// - Returns: 月份第一天Date
    func getMonthFirstday() -> Date {
        let components = Set.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day])
        var dateComponents = Calendar.current.dateComponents(components, from: self)
        dateComponents.day = 1
        let theDate = Calendar.current.date(from: dateComponents)!
        return theDate
    }
    
    /// 获取日期月份的最后一天Date
    /// - Returns: 月份最后一天Date
    func getMonthLastDay() -> Date {
        let components = Set.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day])
        var dateComponents = Calendar.current.dateComponents(components, from: self)
        dateComponents.month = dateComponents.month! + 1
        dateComponents.day = 0
        let theDate = Calendar.current.date(from: dateComponents)!
        return theDate
    }
    
    /// 获取日期下个月的第一天Date
    /// - Returns: 日期下个月的第一天Date
    func getNextMonthFirstDay() -> Date {
        let components = Set.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day])
        var dateComponents = Calendar.current.dateComponents(components, from: self)
        dateComponents.month = dateComponents.month! + 1
        dateComponents.day = 1
        let theDate = Calendar.current.date(from: dateComponents)!
        return theDate
    }
    
    /// 获取日期关联的DateComponenets
    /// - Returns: 日期关联的DateComponenets
    func dateComponents(_ identifier: Calendar.Identifier? = nil) -> DateComponents {
        let calendar = (identifier != nil ? Calendar(identifier: identifier!) : Calendar.current)
        let components = Set.init([Calendar.Component.year,
                                   Calendar.Component.month,
                                   Calendar.Component.day,
                                   Calendar.Component.hour,
                                   Calendar.Component.minute,
                                   Calendar.Component.second])
        let dateComponents = calendar.dateComponents(components, from: self)
        return dateComponents
    }
    
    /// 获取日期指定格式的字符串
    /// - Parameter format: 指定格式. 默认为 "yyyyMMdd HH:mm:ss"
    /// - Returns: 日期字符串
    func string(_ format: String?, _ identifier: Calendar.Identifier? = nil) -> String? {
        let formatter = DateFormatter.init()
        if (identifier != nil) {
            formatter.calendar = Calendar(identifier: identifier!)
        }
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// 获取日期的星期几
    func getWeekday() -> Int {
        let components = Set.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekday])
        let dateComponents = Calendar.init(identifier: .gregorian).dateComponents(components, from: self)
        return dateComponents.weekday!
    }
    
    func isTodayDate() -> Bool {
        let components = self.dateComponents()
        let todayComponents = Foundation.Date().dateComponents()
        if (components.year == todayComponents.year &&
            components.month == todayComponents.month &&
            components.day == todayComponents.day) {
            return true
        } else {
            return false
        }
    }
    
    func isChineseCalendarFirstDay() -> Bool {
        let components = self.dateComponents(.chinese)
        return components.day == 1
    }
    
    func chineseCalendarMonthLeapDesc() -> String {
        let components = self.dateComponents(.chinese)
        if (components.isLeapMonth == true) {
            return "闰"
        }
        return ""
    }
    
    func chineseCalendarMonthDesc() -> String {
        let components = self.dateComponents(.chinese)
        let month = components.month
        
        if (month == nil) {
            return ""
        }
        
        switch month! {
        case 1:
            return "正"
        case 2:
            return "二"
        case 3:
            return "三"
        case 4:
            return "四"
        case 5:
            return "五"
        case 6:
            return "六"
        case 7:
            return "七"
        case 8:
            return "八"
        case 9:
            return "九"
        case 10:
            return "十"
        case 11:
            return "十一"
        case 12:
            return "十二"
        default:
            return ""
        }
    }
    
    func chineseCalendarDayDesc() -> String {
        let day = self.dateComponents(.chinese).day
        
        if (day == nil) {
            return ""
        }
        
        switch day! {
        case 1:
            return "初一"
        case 2:
            return "初二"
        case 3:
            return "初三"
        case 4:
            return "初五"
        case 5:
            return "初六"
        case 6:
            return "初六"
        case 7:
            return "初七"
        case 8:
            return "初八"
        case 9:
            return "初九"
        case 10:
            return "初十"
        case 11:
            return "十一"
        case 12:
            return "十二"
        case 13:
            return "十三"
        case 14:
            return "十四"
        case 15:
            return "十五"
        case 16:
            return "十六"
        case 17:
            return "十七"
        case 18:
            return "十八"
        case 19:
            return "十九"
        case 20:
            return "二十"
        case 21:
            return "廿一"
        case 22:
            return "廿二"
        case 23:
            return "廿三"
        case 24:
            return "廿四"
        case 25:
            return "廿五"
        case 26:
            return "廿六"
        case 27:
            return "廿七"
        case 28:
            return "廿八"
        case 29:
            return "廿九"
        case 30:
            return "三十"
        default:
            return ""
        }
    }
}
