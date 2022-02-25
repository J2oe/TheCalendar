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
}
