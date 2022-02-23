//
//  EventDate.swift
//  xinOA
//
//  Created by Joe on 2022/2/22.
//

import Foundation

extension Date {
    func festivalName() -> String {
        let components = self.dateComponents()
        if (components.month == 1 && components.day == 1) {
            return "元旦节"
        } else if (components.month == 3 && components.day == 8) {
            return "妇女节"
        } else if (components.month == 5 && components.day == 1) {
            return "劳动节"
        } else if (components.month == 5 && components.day == 4) {
            return "青年节"
        } else if (components.month == 6 && components.day == 1) {
            return "儿童节"
        } else if (components.month == 7 && components.day == 1) {
            return "建党节"
        } else if (components.month == 8 && components.day == 1) {
            return "建军节"
        } else if (components.month == 9 && components.day == 10) {
            return "教师节"
        } else if (components.month == 9 && components.day == 30) {
            return "烈士纪念日"
        } else if (components.month == 10 && components.day == 1) {
            return "国庆节"
        } else {
            return ""
        }
    }
    
    func traditionalFestivalName () -> String {
        let components = self.dateComponents(.chinese)
        
        if (components.month == 12) {
            var lastMonthDateComponents = components
            lastMonthDateComponents.day = lastMonthDateComponents.day! + 1
            lastMonthDateComponents = Calendar(identifier:.chinese).date(from: lastMonthDateComponents)!.dateComponents(.chinese)
            if (lastMonthDateComponents.month == 1 && lastMonthDateComponents.day == 1) {
                return "除夕"
            } else {
                //
            }
        } else {
            if (components.isLeapMonth == false) {
                if (components.month == 1 && components.day == 1) {
                    return "春节"
                } else if (components.month == 1 && components.day == 15) {
                    return "元宵节"
                } else if (components.month == 5 && components.day == 5) {
                    return "端午节"
                } else if (components.month == 7 && components.day == 7) {
                    return "七夕节"
                } else if (components.month == 8 && components.day == 15) {
                    return "中秋节"
                } else if (components.month == 9 && components.day == 9) {
                    return "重阳节"
                } else {
                    //
                }
            } else {
                //
            }
        }
        
        return ""
    }
    
    func chinese24SolarTerms () -> String {
        let components = self.dateComponents()
        
        let dict = chinese24SolarTermsDict(components.year)
        let values: [String: String] = dict["short"] ?? [:]
        
        let key = self.string("MMdd")!
        print("\(#function). \(key)")
        let string = values[key]
        return string ?? ""
    }
    
    private func chinese24SolarTermsDict(_ yearString: Int? = nil) -> [String: [String: String]] {
        let empty: [String: [String: String]] = [:]
        
        if (yearString == nil) {
            return empty
        }
        
        let path = Bundle.main.path(forResource: "\(yearString!)", ofType: "json")
        if (path == nil) {
            return empty
        }
        
        let pathUrl = URL(fileURLWithPath: path!)
        let data = try? Data(contentsOf: pathUrl, options: .dataReadingMapped)
        if (data == nil) {
            return empty
        }
        
        let dict = try? JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .mutableLeaves, .fragmentsAllowed])
        if (dict != nil) {
            return dict as! [String: [String: String]]
        }
        
        return empty
    }
}
