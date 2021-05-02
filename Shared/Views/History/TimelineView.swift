//
//  TimelineView.swift
//  yournal
//
//  Created by Patrick Johnson on 4/16/21.
//

import SwiftUI

struct TimelineView: View {
    @State var journals: [JournalEntry] = []
    @Binding var selectedDate: Date?
    @Binding var currentMonth: Date
    @ObservedObject var journalViewModel: JournalViewModel
    @AppStorage("user.theme") var theme: String = "Parchment"
    init(selectedDate: Binding<Date?>, currentMonth: Binding<Date>, journalViewModel: JournalViewModel){
        self._selectedDate = selectedDate
        self._currentMonth = currentMonth
        self.journalViewModel = journalViewModel
        self.journals = journalViewModel.monthEntries(at: Date())
    }
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView{
                VStack(spacing: 0){
                    ForEach(getJournalDates(), id: \.self){ date in
                        let entries = journalViewModel.entries(at: date)
                        HStack(alignment: .top){
                            VStack(spacing: 0){
                                Circle().frame(width: 10, height: 10, alignment: .center).foregroundColor(getThemeColor(name:"Chosen", theme: theme)).opacity(entries.isEmpty ? 0 : 1).padding(5).overlay(Circle().stroke(lineWidth: 4))
                                Rectangle().frame(width: 6)
                                Spacer()
                            }
                            .padding(.trailing, 5)
                            VStack(spacing: 0){
                                HStack{
                                    Text(date.journalDateString).font(.headline)
                                    Spacer()
                                }
                                    JournalListView(journals: entries, journalViewModel: journalViewModel)
                                        .padding(.top)
                            }
                            .padding(.bottom)
                        }.id(date)
                        .padding(.top, 2)
                    }
                }.padding()
            }
            .onChange(of: selectedDate, perform: { value in
                if value != nil{
                    withAnimation {
                        proxy.scrollTo(value, anchor: .top)
                    }
                }
            })
            .onAppear(perform: {
                journals = journalViewModel.monthEntries(at: selectedDate ?? currentMonth)
                if selectedDate != nil{
                    withAnimation {
                        proxy.scrollTo(selectedDate, anchor: .top)
                    }
                }
            })
        }
        .onChange(of: currentMonth, perform: { value in
            DispatchQueue.main.async {
                journals = journalViewModel.monthEntries(at: currentMonth)
            }
        })
    }
    func getJournalDates() -> [Date]{
        var dates = [Date]()
        journals.forEach({ journal in
            let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: journal.createdAt ?? Date()))
            if date != nil && !dates.contains(date!){
                dates.append(date!)
            }
        })
        
        let currentDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))!
        if(!journals.contains(where: { journal in
            let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: journal.createdAt ?? Date()))!
            return (date == currentDate)
        }) && currentMonth.year == currentDate.year && currentMonth.month == currentDate.month){
            dates.append(currentDate)
        }
        
        return dates.sorted(by: {$0<$1})
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(selectedDate: .constant(nil), currentMonth: .constant(Date()), journalViewModel: JournalViewModel())
    }
}
