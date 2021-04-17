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
    var body: some View {
        ZStack{
            Background()
            VStack{
//                if(view == "week"){
//                    WeekView(selectedDate: $selectedDate, journalViewModel: journalViewModel)
//                } else{
                    MonthlyView(journalViewModel: journalViewModel)
//                }
                Spacer()
                
            }
        }
        .navigationTitle("History")
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
