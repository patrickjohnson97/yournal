//
//  HistoryView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/29/21.
//

import SwiftUI

struct HistoryView: View {
    @State var view: String = "month"
    @ObservedObject var journalViewModel: JournalViewModel
    @State var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    var body: some View {
        NavigationView{
        ZStack{
            Background()
            VStack{
//                Picker(selection: $view, label: Text("View"), content: {
//                    Text("Week").tag("week")
//                    Text("Month").tag("month")
//                }).pickerStyle(SegmentedPickerStyle())
                if(view == "week"){
                    WeekView(selectedDate: $selectedDate, journalViewModel: journalViewModel)
                } else{
                    MonthlyView(selectedDate: $selectedDate, journalViewModel: journalViewModel)
                }
                Spacer()
                
            }
            
        }.navigationTitle("History")
        }
        .onAppear(perform: {
            journalViewModel.loadAllJournals()
        })
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(journalViewModel: JournalViewModel())
    }
}
