//
//  MonthlyView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/31/21.
//

import SwiftUI

struct MonthlyView: View {
    @State var selectedDate: Date? = Calendar.current.startOfDay(for: Date())
    @State var timelineEntries = [JournalEntry]()
    @ObservedObject var journalViewModel: JournalViewModel
    @State var currentMonth: Date = Date()
    @AppStorage("user.theme") var theme: String = "Parchment"
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack{
                HStack{
                    Button(action: {}, label: {
                        Image(systemName: "chevron.backward.2")
                    })
                    .buttonStyle(GenericButtonStyle(foregroundColor: .accentColor, backgroundColor: Color.accentColor.opacity(0.14), pressedColor: Color.accentColor.opacity(0.2), internalPadding: 10))
                    .simultaneousGesture(LongPressGesture().onEnded { _ in
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        currentMonth = Calendar.current.date(byAdding: DateComponents(year: -1), to: currentMonth)!
                    })
                    .simultaneousGesture(TapGesture().onEnded {
                        decrementMonth()
                    })
                    Spacer()
                    let monthInt = Calendar.current.component(.month, from: currentMonth)
                    let monthStr = Calendar.current.monthSymbols[monthInt-1]
                    let yearInt = Calendar.current.component(.year, from: currentMonth)
                    Text("\(monthStr) \(String(yearInt))").bold().padding(8).background(RoundedRectangle(cornerRadius: 8).foregroundColor(getThemeColor(name: "Card", theme: theme)))
                        .onLongPressGesture {
                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                            impactHeavy.impactOccurred()
                            currentMonth = Date()
                        }
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "chevron.forward.2")
                    })
                    .buttonStyle(GenericButtonStyle(foregroundColor: .accentColor, backgroundColor: Color.accentColor.opacity(0.14), pressedColor: Color.accentColor.opacity(0.2), internalPadding: 10))
                    .simultaneousGesture(LongPressGesture().onEnded { _ in
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        currentMonth = Calendar.current.date(byAdding: DateComponents(year: 1), to: currentMonth)!
                    })
                    .simultaneousGesture(TapGesture().onEnded {
                        advanceMonth()
                    })
                }
                .padding(.top)
                .padding(.horizontal)
                let days = getAllDays()
                let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(days, id: \.self){ day in
                        Button(action: {selectedDate = day}, label: {
                            VStack{
                                Circle().frame(width: 10, height: 10, alignment: .center).foregroundColor(getThemeColor(name:"Chosen", theme: theme)).opacity(journalViewModel.entries(at: day).isEmpty ? 0 : 1)
                                Text(String(day.get(.day))).font(.caption)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(lineWidth: journalViewModel.entries(at: day).isEmpty ? 0 : 3).foregroundColor(getThemeColor(name:"Card", theme: theme)))
                            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Card", theme: theme)).opacity(selectedDate == day ? 1 : 0))
                            .opacity(Calendar.current.component(.month, from: day) != Calendar.current.component(.month, from: currentMonth) ? 0 : 1)
                        })
                        .disabled(isDateSelectable(day: day) ? false : true)
                        .buttonStyle(PlainButtonStyle())
                        .opacity(day.isFuture ? 0.7 : 1)
                    }
                }
                .padding(.horizontal)
                TimelineView(selectedDate: $selectedDate, currentMonth: $currentMonth, journalViewModel: journalViewModel)
                
            }
        }
        
    }
    
    func isDateSelectable(day: Date) -> Bool{
        return (Calendar.current.component(.month, from: day) == Calendar.current.component(.month, from: currentMonth) && !day.isFuture && !journalViewModel.entries(at: day).isEmpty)
    }
    
    func advanceMonth(){
        DispatchQueue.main.async{
            currentMonth = currentMonth.monthAfter;
        }
        DispatchQueue.main.async {
            selectedDate = nil
        }
    }
    
    func decrementMonth(){
        DispatchQueue.main.async{
            currentMonth = currentMonth.monthBefore;
        }
        DispatchQueue.main.async {
            selectedDate = nil
        }
    }
    
    func getAllDays() -> [Date]
    {
        var days = [Date]()
        
        let calendar = Calendar.current
        
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        
        var day = Calendar.current.date(from:Calendar.current.dateComponents([.year,.month], from: currentMonth))!
        
        for _ in 1...range.count
        {
            days.append(day)
            day = calendar.date(byAdding: .day, value: 1, to: day)!
        }
        let firstDayOfWeek = calendar.component(.weekday, from: (days.first!))
        if(firstDayOfWeek != 1){
            for _ in 1...firstDayOfWeek-1 {
                let firstDay = days.first
                days.insert(firstDay!.dayBefore, at: 0)
            }
        }
        let lastDayOfWeek = calendar.component(.weekday, from: (days.last!))
        if(lastDayOfWeek != 7){
            for _ in lastDayOfWeek+1...7 {
                let lastDay = days.last
                days.append(lastDay!.dayAfter)
            }
        }
        return days
    }
}

struct MonthlyView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyView(journalViewModel: JournalViewModel())
    }
}


