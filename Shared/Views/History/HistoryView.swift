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
    @ObservedObject var promptViewModel: PromptViewModel
    @State var showNewJournalSheet: Bool = false

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
//        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            journalViewModel.loadAllJournals()
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {showNewJournalSheet = true}, label: {
                    Image(systemName: "plus")
                })
                
            }
            ToolbarItem(placement: .principal){
                Text("Y").font(.system(.headline, design: .serif))
            }
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: {}, label: {
                    Image(systemName: "info.circle")
                })
            }
        })
        .sheet(isPresented: $showNewJournalSheet, content: {
            NewJournalView(journalViewModel: journalViewModel, promptViewModel: promptViewModel)
        })
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(journalViewModel: JournalViewModel(), promptViewModel: PromptViewModel())
    }
}
