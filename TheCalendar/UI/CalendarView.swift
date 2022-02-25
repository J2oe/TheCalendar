//
//  CalendarView.swift
//  xinOA
//
//  Created by Joe on 2022/2/16.
//

import SwiftUI

let UnitCellMinWidth: CGFloat = 130

struct CalendarView: View {
    @State var selectMonthDate: Date = Foundation.Date()
    
    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(monthDate: $selectMonthDate)
            
            CalendarTitleView()
            
            CalendarContentView(monthDate: $selectMonthDate)
        }
    }
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

struct CalendarHeaderView: View {
    @Binding var monthDate: Date
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(selectMonthDateDesc())
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack(spacing: 2) {
                Button("<") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        didClickPreButton()
                    }
                }
                
                Button("今天") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        didClickCurrentDateButton()
                    }
                }
                
                Button(">") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        didClickNextButton()
                    }
                }
            }
        }
        .padding(10)
        .background(Color.yellow)
    }
    
    func selectMonthDateDesc() -> String {
        return monthDate.string("yyyy年M月")!
    }
    
    func didClickPreButton() {
        print("\(#function) \(#line)")
        var components = monthDate.dateComponents()
        components.month = components.month!-1
        let d = Calendar.current.date(from: components)!
        monthDate = d
    }
    
    func didClickCurrentDateButton() {
        print("\(#function) \(#line)")
        monthDate = Foundation.Date()
    }
    
    func didClickNextButton() {
        print("\(#function) \(#line)")
        var components = monthDate.dateComponents()
        components.month = components.month!+1
        let d = Calendar.current.date(from: components)!
        monthDate = d
    }
    
}

struct CalendarTitleView: View {
    let columns: Int = 7
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<columns, id: \.self) { columnsIndex in
                HStack {
                    Spacer()
                    Text(weekTitle(columnsIndex))
                        .padding(.trailing, 8)
                }
                .frame(minWidth: UnitCellMinWidth, maxWidth: .infinity)
                .foregroundColor(textColor(columnsIndex))
            }
        }
        .frame(minHeight: 30, maxHeight: 40)
    }
    
    func weekTitle(_ index: Int) -> String {
        switch (index+1) {
        case 1:
            return "周一"
        case 2:
            return "周二"
        case 3:
            return "周三"
        case 4:
            return "周四"
        case 5:
            return "周五"
        case 6:
            return "周六"
        case 7:
            return "周日"
            
        default:
            return ""
        }
    }
    
    func textColor(_ index: Int) -> Color {
        if (index+1 == 6 || index+1 == 7) {
            return Color(red: 251/255.0, green: 0, blue: 47/255.0)
        } else {
            return Color(red: 21/255.0, green: 67/255.0, blue: 165/255.0)
        }
    }
}

struct CalendarContentView: View {
    @Binding var monthDate: Date
    
    var showingDatesArray: [Date] = []
    
    init(monthDate: Binding<Date>) {
        self._monthDate = monthDate
        self.showingDatesArray = prepareDates()
    }
    
    let columns: Int = 7
    let rows: Int = 6
    var total: Int {
        get {
            return columns * rows
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { rowsIndex in
                HStack(spacing: 0) {
                    ForEach(0..<columns, id: \.self) { columnsIndex in
                        CalendarContentUnitView(findDate(rowsIndex, columnsIndex), aInSelectMonth: isSelectMonthDate(rowsIndex, columnsIndex))
                    }
                }
            }
        }
    }
    
    func prepareDates() -> [Date] {
        var datesArray: [Date] = []
        
        var baseDateComponents = monthDate.dateComponents()
        baseDateComponents.hour = 0
        baseDateComponents.minute = 0
        baseDateComponents.second = 0
        let baseDate = Calendar.current.date(from: baseDateComponents)!
        
        let daysCount = baseDate.getMonthDaysCount()
        for index in 1...daysCount {
            var components = baseDate.dateComponents()
            components.day = index
            let d = Calendar.current.date(from: components)!
            datesArray.append(d)
        }
        
        let firstDay = baseDate.getMonthFirstday()
        let firstDayWeekday = firstDay.getWeekday()
        var preMonthDays = 0
        if (firstDayWeekday == 1) {
            preMonthDays = columns - 1
        } else {
            preMonthDays = firstDayWeekday - 2
        }
        for index in 0..<preMonthDays {
            var components = firstDay.dateComponents()
            components.day = components.day! - (index+1)
            let d = Calendar.current.date(from: components)!
            datesArray.insert(d, at: 0)
        }
        
        let nextMonthDays = total - datesArray.count
        for index in 1...nextMonthDays {
            var components = baseDate.getMonthLastDay().dateComponents()
            components.day = components.day! + index
            let d = Calendar.current.date(from: components)!
            datesArray.append(d)
        }
        
        return datesArray
    }
    
    func findDate(_ rowIndex: Int, _ columnIndex: Int) -> Date? {
        let index = rowIndex * columns + columnIndex
        if (index < showingDatesArray.count) {
            let d = showingDatesArray[index]
            return d
        } else {
            return nil
        }
    }
    
    func isSelectMonthDate(_ rowIndex: Int, _ columnIndex: Int) -> Bool {
        let d = findDate(rowIndex, columnIndex)
        if (d == nil) {
            return false
        } else {
            return (d!.dateComponents().month == monthDate.dateComponents().month)
        }
    }
    
}

struct CalendarContentUnitView: View {
    var theDate: Date? = nil
    var isToday: Bool = false
    var isChineseFirstDay: Bool = false
    var inSelectMonth: Bool = false
    
    var festivals: [String] = []
    
    
    init(_ aDate: Date?, aInSelectMonth: Bool = true) {
        self.theDate = aDate
        self.inSelectMonth = aInSelectMonth
        self.isToday = aDate?.isTodayDate() ?? false
        self.isChineseFirstDay = aDate?.isChineseCalendarFirstDay() ?? false
        self.festivals = collectFestivals()
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(spacing: 0) {
                    Text(dateChineseDesc())
                        .lineLimit(1)
                        .padding(.bottom, 4)
                        .overlay(alignment: .bottom, content: {
                            if (isChineseFirstDay) {
                                Divider().frame(height: 2).background(Color.red)
                            }
                        })
                }
                .frame(minWidth: 36, alignment: .leading)
                .padding(2)
                .padding(.leading, 2)
                .background(Color.white)
                
                Spacer()
                
                Text(dateADDesc())
                    .lineLimit(1)
                    .frame(minWidth: 36, alignment: .trailing)
                    .padding(2)
                    .foregroundColor(isToday ? Color.white : foreColor())
                    .background(isToday ? Color.red : Color.white)
                    .cornerRadius(isToday ? 6 : 0)
            }
            .padding(.top, 2)
            .padding(.trailing, 6)
            
            VStack {
                ForEach(festivals, id: \.self) { f in
                    Text(f)
                        .lineLimit(1)
                        .padding(0)
                        .padding(.leading, 8)
                        .padding(.trailing, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Spacer()
        }
        .foregroundColor(foreColor())
        .frame(minWidth: UnitCellMinWidth, maxWidth: .infinity, minHeight: 60, maxHeight: .infinity)
        .background(Color.white)
        .border(Color(red: 128/255.0, green: 128/255.0, blue: 128/255.0), width: 1)
        .opacity(opacityValue())
    }
    
    func collectFestivals() -> [String] {
        if (theDate == nil) {
            return []
        }

        var arr = [String]()

        let festival = theDate!.festivalName()
        if (festival.count != 0) {
            arr.append(festival)
        }

        let tradFestival = theDate!.traditionalFestivalName()
        if (tradFestival.count != 0) {
            arr.append(tradFestival)
        }

        let solarTerm = theDate!.chinese24SolarTerms()
        if (solarTerm.count != 0) {
            arr.append(solarTerm)
        }

        return arr
    }
    
    func festivalDesc() -> String {
        if (theDate == nil) {
            return ""
        }
        
        return theDate!.festivalName()
    }
    
    func dateADDesc() -> String {
        if (theDate == nil) {
            return ""
        }
        
        let d = theDate!
        let day = d.dateComponents().day!
        if (day == 1) {
            return "\(d.dateComponents().month!)月\(day)日"
        } else {
            return "\(day)日"
        }
    }
    
    func foreColor() -> Color {
        if (theDate == nil) {
            return Color(red: 21/255.0, green: 67/255.0, blue: 165/255.0)
        }
        
        let weekday = theDate!.getWeekday()
        if (weekday == 1 || weekday == 7) {
            return Color(red: 251/255.0, green: 0, blue: 47/255.0)
        } else {
            return Color(red: 21/255.0, green: 67/255.0, blue: 165/255.0)
        }
    }
    
    func opacityValue() -> Double {
        return inSelectMonth ? 1.0 : 0.4
    }
    
    func dateChineseDesc() -> String {
        if (theDate == nil) {
            return ""
        }
        
        let d = theDate!
        let day = d.dateComponents(.chinese).day!
        if (day == 1) {
            let leapMonthDesc = d.chineseCalendarMonthLeapDesc()
            let monthDesc = d.chineseCalendarMonthDesc()
            let dayDesc = d.chineseCalendarDayDesc()
            return "\(leapMonthDesc) \(monthDesc)月\(dayDesc)"
        } else {
            let dayDesc = d.chineseCalendarDayDesc()
            return "\(dayDesc)"
        }
    }
    
    
    
}
