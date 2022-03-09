//
//  EventDate.swift
//  xinOA
//
//  Created by Joe on 2022/2/22.
//

import Foundation

class MemoriesDayManager {
    static let shared = MemoriesDayManager()
    
    private init() {}
    
    var _memoriesDays: [String: String]?
    var memoriesDays: [String: String] {
        get {
            if _memoriesDays == nil {
                _memoriesDays = festivalsAndMemorialDaysDict()
            }
            return _memoriesDays!
        }
    }
    
    var _traditionalMemoriesDays: [String: String]?
    var traditionalMemoriesDays: [String: String] {
        get {
            if _traditionalMemoriesDays == nil {
                _traditionalMemoriesDays = traditionalFestivalsAndMemorialDaysDict()
            }
            return _traditionalMemoriesDays!
        }
    }
    
    // TODO: 24节气和法定假期，每年都有变更
    var _chinese24SolarTermsDays: [String: [String: String]]?
    var chinese24SolarTermsDays: [String: [String: String]] {
        get {
            if _chinese24SolarTermsDays == nil {
                _chinese24SolarTermsDays = chinese24SolarTermsDict(Date().dateComponents().year)
            }
            return _chinese24SolarTermsDays!
        }
    }
    
    var _legalholidays: [String: [[Date]]]?
    var legalholidays: [String: [[Date]]] {
        get {
            if _legalholidays == nil {
                _legalholidays = chineseHolidaysDict()
            }
            return _legalholidays!
        }
    }
    
    func festivalName(_ aDate: Date) -> String {
        let dateKey = aDate.string("MMdd")!
        let string = self.memoriesDays[dateKey]
        return string ?? ""
    }
    
    func traditionalFestivalName (_ aDate: Date) -> String {
        let components = aDate.dateComponents(.chinese)
        
        var dateKey = ""
        let eveKey = chineseNewYearEveKey(components)
        if (eveKey != nil) {
            dateKey = eveKey!
        } else {
            if (components.isLeapMonth == false) {
                dateKey = aDate.string("MMdd", .chinese)!
            }
        }
        
        let string = self.traditionalMemoriesDays[dateKey]
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
    
    func chinese24SolarTerms (_ aDate: Date) -> String {
        let values: [String: String] = self.chinese24SolarTermsDays["short"] ?? [:]
        
        let dateKey = aDate.string("MMdd")!
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
        
        let path = Bundle.main.path(forResource: "solarTerms", ofType: "json")
        let data = fileContentDataWith(path)
        if (data == nil) {
            return empty
        }
        
        do {
            let dict = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .mutableLeaves, .fragmentsAllowed])
            let theDict = dict as! [String: Any]
            let content = theDict["content"] as? [String: [String: String]]
            return content!
        } catch {
            return empty
        }
    }
    
    private func festivalsAndMemorialDaysDict() -> [String: String] {
        let empty: [String: String] = [:]
        
        let path = Bundle.main.path(forResource: "festivalsAndMemorialDays", ofType: "json")
        let data = fileContentDataWith(path)
        if (data == nil) {
            return empty
        }
        
        do {
            let dict = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .mutableLeaves, .fragmentsAllowed])
            let theDict = dict as! [String: Any]
            let content = theDict["content"] as? [String: String]
            return content!
        } catch {
            return empty
        }
    }
    
    private func traditionalFestivalsAndMemorialDaysDict() -> [String: String] {
        let empty: [String: String] = [:]
        
        let path = Bundle.main.path(forResource: "traditionalFestivalsAndMemorialDays", ofType: "json")
        let data = fileContentDataWith(path)
        if (data == nil) {
            return empty
        }
        
        do {
            let dict = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .mutableLeaves, .fragmentsAllowed])
            let theDict = dict as! [String: Any]
            let content = theDict["content"] as? [String: String]
            return content!
        } catch {
            return empty
        }
    }
    
    /// 是否为假期
    /// - Returns: true: 是; false: 否
    func isLeavingDay(_ aDate: Date) -> Bool {
        // TODO: 先判断法定假期，还是先判断周末？
        if (aDate.isWeekend()) {
            // 周末：判断是否为假期调班
            return !self.isLegalHolidayCompensation(aDate)
        } else {
            // 工作日：判断是否为假期
            return self.isLegalHolidays(aDate)
        }
    }
    
    /// 是否为法定假期
    /// - Returns: true: 是; false: 否
    private func isLegalHolidays(_ aDate: Date) -> Bool {
        let dateRangesArray = self.legalholidays["holidays"]!
        
        for rangeItem in dateRangesArray {
            let startDate = rangeItem.first!
            let endDate = rangeItem.last!
            
            if (aDate.compare(startDate) != .orderedAscending && aDate.compare(endDate) != .orderedDescending) {
                return true
            }
        }
        
        return false
    }
    
    /// 是否为法定假期调班
    /// - Returns: true: 是; false: 否
    private func isLegalHolidayCompensation(_ aDate: Date) -> Bool {
        let dateRangesArray = self.legalholidays["compensations"]!
        
        for rangeItem in dateRangesArray {
            let startDate = rangeItem.first!
            let endDate = rangeItem.last!
            
            if (aDate.compare(startDate) != .orderedAscending && aDate.compare(endDate) != .orderedDescending) {
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
        let startDate = Date.createDate(startday, dateFormat)!
        let endDate = Date.createDate(endday, dateFormat)!
        
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
            let startDate = Date.createDate(startday, dateFormat)!
            let endDate = Date.createDate(endday, dateFormat)!
            
            let dateRange: [Date] = [startDate, endDate]
            compensationDateRanges.append(dateRange)
        }
        
        return compensationDateRanges
    }
    
    private func chineseHolidaysFileContents() -> [ [String: Any] ] {
        let empty: [ [String: Any] ] = []
        
        let path = Bundle.main.path(forResource: "legalholidays", ofType: "json")
        let data = fileContentDataWith(path)
        if (data == nil) {
            return empty
        }
        
        do {
            let dict = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .mutableLeaves, .fragmentsAllowed])
            let theDict = dict as! [String: Any]
            let content = theDict["content"] as? [ [String: Any] ]
            return content!
        } catch {
            return empty
        }
    }
}
