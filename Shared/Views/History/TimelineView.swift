//
//  TimelineView.swift
//  yournal
//
//  Created by Patrick Johnson on 4/16/21.
//

import SwiftUI

struct TimelineView: View {
    var journals: [JournalEntry]
    @Binding var selectedDate: Date?
    @ObservedObject var journalViewModel: JournalViewModel
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView{
                VStack(spacing: 0){
                    ForEach(getJournalDates(), id: \.self){ date in
                        HStack(alignment: .top){
                            VStack(spacing: 0){
                                Circle().stroke(lineWidth: 4).frame(width: 20, height: 20)
                                Rectangle().frame(width: 6)
                                Spacer()
                            }
                            .padding(.trailing, 5)
                            VStack(spacing: 0){
                                HStack{
                                    Text(date.journalDateString).font(.headline)
                                    Spacer()
                                }
                                JournalListView(journals: journalViewModel.entries(at: date), journalViewModel: journalViewModel)
                                    .padding(.top)
                            }
                            .padding(.bottom)
                        }.id(date)
                        .padding(.top, 2)
                    }
                }.padding()
            }.onChange(of: selectedDate, perform: { value in
                if value != nil{
                    withAnimation {
                        proxy.scrollTo(value, anchor: .top)
                    }
                }
            })
            .onAppear(perform: {
                if selectedDate != nil{
                    withAnimation {
                        proxy.scrollTo(selectedDate, anchor: .top)
                    }
                }
            })
        }
    }
    func getJournalDates() -> [Date]{
        var dates = [Date]()
        journals.forEach({ journal in
            let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: journal.createdAt!))
            if date != nil && !dates.contains(date!){
                dates.append(date!)
            }
        })
        return dates
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(journals: [], selectedDate: .constant(nil), journalViewModel: JournalViewModel())
    }
}
