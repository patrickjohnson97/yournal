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
    var body: some View {
        let calendar = Calendar.current
        let startOfCurrentWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))
        let currentWeekDates = getWeekDates(of: startOfCurrentWeek!, with: calendar)
        ScrollView(.horizontal, showsIndicators: false){
            ScrollViewReader { value in
                HStack{
                    Spacer()
                    ForEach(currentWeekDates, id: \.self){ day in
                        Button(action: {selectedDate = day}, label: {
                            DailyView(date: day, journalViewModel: journalViewModel).id(day)
                                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color("Card")).opacity(selectedDate == day ? 1 : 0))
                        })
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }.onAppear(perform: {
                    value.scrollTo(calendar.startOfDay(for: Date()))
                })
                .padding(.vertical)
            }
        }
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
