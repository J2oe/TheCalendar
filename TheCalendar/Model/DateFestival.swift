//
//  EventDate.swift
//  xinOA
//
//  Created by Joe on 2022/2/22.
//

import Foundation

extension Date {
    
    func festivalName() -> String {
        let dict = festivalsAndMemorialDaysDict()
        let dateKey = self.string("MMdd")!
        let string = dict[dateKey]
        return string ?? ""
    }
    
    func traditionalFestivalName () -> String {
        let components = self.dateComponents(.chinese)
        let dict = chineseFestivalsAndMemorialDaysDict()
        
        var dateKey = ""
        let eveKey = chineseNewYearEveKey(components)
        if (eveKey != nil) {
            dateKey = eveKey!
        } else {
            if (components.isLeapMonth == false) {
                dateKey = self.string("MMdd", .chinese)!
            }
        }
        
        let string = dict[dateKey]
        return string ?? ""
    }
    
    private func chineseNewYearEveKey(_ components: DateComponents) -> String? {
        var nextDayComponents = components
        nextDayComponents.day = nextDayComponents.day! + 1
        
        let chineseDate = Calendar(identifier:.chinese).date(from: nextDayComponents)!
        
        let compareComponents = chineseDate.dateComponents(.chinese)
        if (compareComponents.month == 1 && compareComponents.day == 1) {
            return chineseDate.string("MMdd", .chinese)! + "eve"
        } else {
            return nil
        }
    }
    
    func chinese24SolarTerms () -> String {
        let components = self.dateComponents()
        
        let dict = chinese24SolarTermsDict(components.year)
        let values: [String: String] = dict["short"] ?? [:]
        
        let dateKey = self.string("MMdd")!
        let string = values[dateKey]
        return string ?? ""
    }
    
    private func fileContentDataWith(_ path: String? = nil) -> Data? {
        if (path == nil) {
            return nil
        }
        
        let pathUrl = URL(fileURLWithPath: path!)
        let data = try? Data(contentsOf: pathUrl, options: .dataReadingMapped)
        return data
    }
    
    private func chinese24SolarTermsDict(_ yearString: Int? = nil) -> [String: [String: String]] {
        let empty: [String: [String: String]] = [:]
        
        if (yearString == nil) {
            return empty
        }
        
        let path = Bundle.main.path(forResource: "\(yearString!)", ofType: "json")
        let data = fileContentDataWith(path)
        if (data == nil) {
            return empty
        }
        
        let dict = try? JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .mutableLeaves, .fragmentsAllowed])
        if (dict != nil) {
            return dict as! [String: [String: String]]
        }
        
        return empty
    }
    
    private func festivalsAndMemorialDaysDict() -> [String: String] {
        let empty: [String: String] = [:]
        
        let path = Bundle.main.path(forResource: "festivalsAndMemorialDays", ofType: "json")
        let data = fileContentDataWith(path)
        if (data == nil) {
            return empty
        }
        
        let dict = try? JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .mutableLeaves, .fragmentsAllowed])
        if (dict != nil) {
            return dict as! [String: String]
        }
        return empty
    }
    
    private func chineseFestivalsAndMemorialDaysDict() -> [String: String] {
        let empty: [String: String] = [:]
        
        let path = Bundle.main.path(forResource: "chineseTraditionalFestivalsAndMemorialDays", ofType: "json")
        let data = fileContentDataWith(path)
        if (data == nil) {
            return empty
        }
        
        let dict = try? JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .mutableLeaves, .fragmentsAllowed])
        if (dict != nil) {
            return dict as! [String: String]
        }
        return empty
    }
    
    /// 是否为假期
    /// - Returns: true: 是; false: 否
    func isLeavingDay() -> Bool {
        // TODO: 先判断法定假期，还是先判断周末？
        if (self.isWeekend()) {
            // 周末：判断是否为假期调班
            return !self.isLegalHolidayCompensation()
        } else {
            // 工作日：判断是否为假期
            return self.isLegalHolidays()
        }
    }
    
    /// 是否为法定假期
    /// - Returns: true: 是; false: 否
    private func isLegalHolidays() -> Bool {
        let dict = self.chineseHolidaysDict()
        let dateRangesArray = dict["holidays"]!
        
        for rangeItem in dateRangesArray {
            let startDate = rangeItem.first!
            let endDate = rangeItem.last!
            
            if (self.compare(startDate) != .orderedAscending && self.compare(endDate) != .orderedDescending) {
                return true
            }
        }
        
        return false
    }
    
    /// 是否为法定假期调班
    /// - Returns: true: 是; false: 否
    private func isLegalHolidayCompensation() -> Bool {
        let dict = self.chineseHolidaysDict()
        let dateRangesArray = dict["compensations"]!
        
        for rangeItem in dateRangesArray {
            let startDate = rangeItem.first!
            let endDate = rangeItem.last!
            
            if (self.compare(startDate) != .orderedAscending && self.compare(endDate) != .orderedDescending) {
                return true
            }
        }
        return false
    }
    
    private func chineseHolidaysDict() -> [String: [[Date]]]{
        var allHolidaysDateRanges = [[Date]]()
        var allHolidaysCompensationDateRanges = [[Date]]()
        
        let array = chineseHolidaysFileContents()
        for value in array {
            let theValue = value
            let holidays = theValue["holidays"] as! [String: String]
            let holidayDateRange = self.createHolidayDateRange(holidays)
            allHolidaysDateRanges.append(holidayDateRange)
            
            let compensations = theValue["compensation"] as! [[String: String]]
            let compensationDateRange = self .createHolidayCompensationDateRange(compensations)
            allHolidaysCompensationDateRanges.append(contentsOf: compensationDateRange)
        }
        
        return [
            "holidays": allHolidaysDateRanges,
            "compensations":  allHolidaysCompensationDateRanges
        ]
    }
    
    private func createHolidayDateRange(_ holidaysDict: [String: String]) -> [Date] {
        let holidays = holidaysDict
        let startday = holidays["start"]!
        let endday = holidays["end"]!
        
        let dateFormat = "yyyyMMdd"
        let startDate = self.createDate(startday, dateFormat)!
        let endDate = self.createDate(endday, dateFormat)!
        
        let dateRange: [Date] = [startDate, endDate]
        return dateRange
    }
    
    private func createHolidayCompensationDateRange(_ compensationArray: [[String: String]]) -> [[Date]] {
        var compensationDateRanges = [[Date]]()
        
        for compensationElement in compensationArray {
            let compensation = compensationElement

            let startday = compensation["start"]!
            let endday = compensation["end"]!
            
            let dateFormat = "yyyyMMdd"
            let startDate = self.createDate(startday, dateFormat)!
            let endDate = self.createDate(endday, dateFormat)!
            
            let dateRange: [Date] = [startDate, endDate]
            compensationDateRanges.append(dateRange)
        }
        
        return compensationDateRanges
    }
    
    private func chineseHolidaysFileContents() -> [ [String: Any] ] {
        let empty: [ [String: Any] ] = []
        
        let path = Bundle.main.path(forResource: "holidays2022", ofType: "json")
        let data = fileContentDataWith(path)
        if (data == nil) {
            return empty
        }
        
        let array = try? JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .mutableLeaves, .fragmentsAllowed])
        if (array != nil) {
            return array as! [ [String: Any] ]
        }
        return empty
    }
    
    func createDate(_ string: String, _ dateFormat: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.date(from: string)
    }
}
