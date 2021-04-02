//
//  DailyView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/29/21.
//

import SwiftUI

struct DailyView: View {
    var date: Date
    @ObservedObject var journalViewModel: JournalViewModel
    var body: some View {
        let journalEntries = journalViewModel.entries(at: date)
        VStack{
            if !journalEntries.isEmpty {
                Image("\(journalEntries.last!.emotionSelected!)-twitter").resizable().aspectRatio(contentMode: .fit).frame(height: 30).clipped().padding(6).overlay(Circle().stroke(lineWidth: 4).foregroundColor(.pink))
            } else{
                Image("happy-twitter").resizable().aspectRatio(contentMode: .fit).frame(height: 30).clipped().padding(6).opacity(0).overlay(Circle().stroke(lineWidth: 4).foregroundColor(.pink)).saturation(0)
            }
            let day = date.get(.day)
            Text(String(day))
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(lineWidth: journalEntries.isEmpty ? 0 : 4).foregroundColor(Color("Card")))
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView(date: Date(), journalViewModel: JournalViewModel())
    }
}
