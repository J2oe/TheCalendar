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
    func string(_ format: String?) -> String? {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// 获取日期的星期几
    func getWeekday() -> Int {
        let components = Set.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekday])
        let dateComponents = Calendar.init(identifier: .gregorian).dateComponents(components, from: self)
        return dateComponents.weekday!
    }
    
}
