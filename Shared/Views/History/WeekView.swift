//
//  WeekView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/29/21.
//

import SwiftUI

struct WeekView: View {
    @Binding var selectedDate: Date
    @ObservedObject var journalViewModel: JournalViewModel
    @State var currentWeek: Date = Date()
    @AppStorage("user.theme") var theme: String = "Standard"
    var body: some View {
        let calendar = Calendar.current
        let startOfCurrentWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentWeek))
        let currentWeekDates = getWeekDates(of: startOfCurrentWeek!, with: calendar)
        ScrollView(.horizontal, showsIndicators: false){
            ScrollViewReader { value in
                HStack{
                    Button(action: {currentWeek = currentWeek.weekBefore}, label: {
                        Image(systemName: "chevron.backward.2")
                    })
                    .buttonStyle(GenericButtonStyle(foregroundColor: .accentColor, backgroundColor: Color.accentColor.opacity(0.14), pressedColor: Color.accentColor.opacity(0.2), internalPadding: 10))
                    Spacer()
                    ForEach(currentWeekDates, id: \.self){ day in
                        VStack(spacing: 8){
                                let monthInt = Calendar.current.component(.month, from: day)
                                let monthStr = Calendar.current.shortMonthSymbols[monthInt-1]
                            Text(monthStr).font(.caption).bold().opacity((day.isStartOfMonth || day.isEndOfMonth) ? 1 : 0)
                            Button(action: {selectedDate = day}, label: {
                                DailyView(date: day, journalViewModel: journalViewModel).id(day)
                                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Card", theme: theme)).opacity(selectedDate == day ? 1 : 0))
                            })
                            .disabled(isDateSelectable(day: day) ? false : true)
                            .buttonStyle(PlainButtonStyle())
                            .opacity(day.isFuture ? 0.7 : 1)
                        }
                        Spacer()
                    }
                    Button(action: {currentWeek = currentWeek.weekAfter}, label: {
                        Image(systemName: "chevron.forward.2")
                    })
                    .buttonStyle(GenericButtonStyle(foregroundColor: .accentColor, backgroundColor: Color.accentColor.opacity(0.14), pressedColor: Color.accentColor.opacity(0.2), internalPadding: 10))
                }.onAppear(perform: {
                    value.scrollTo(calendar.startOfDay(for: Date()))
                })
                .padding(.vertical)
            }
        }
        ScrollView{
            JournalListView(journals: journalViewModel.entries(at: selectedDate))
        }
    }
    
    func isDateSelectable(day: Date) -> Bool{
        return (!day.isFuture && !journalViewModel.entries(at: day).isEmpty)
    }
    
    func getWeekDates(of startDate: Date, with calender: Calendar) -> [Date] {
        let calendar = Calendar.current
        var weekDates: [Date] = []
        for i in 0..<7 {
            weekDates.append(calendar.date(byAdding: .day, value: i, to: startDate)!)
        }
        return weekDates
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(selectedDate: .constant(Calendar.current.startOfDay(for: Date())), journalViewModel: JournalViewModel())
    }
}
