//
//  HighestHighsView.swift
//  yournal
//
//  Created by Patrick Johnson on 4/4/21.
//

import SwiftUI

struct HighestHighsView: View {
    @ObservedObject var journalViewModel : JournalViewModel

    var body: some View {
        ZStack{
            Background()
            ScrollView{
                JournalListView(journals: getJournals()).padding()
            }
        }.navigationTitle("Highest Highs")
    }
    func getJournals() -> [JournalEntry]{
        var results = [JournalEntry]()
        journalViewModel.journals.sorted(by: {$0.sentiment > $1.sentiment}).forEach({ journal in
            if(results.count < 10 && (journal.emotionSelected! == Emotions.happy.getString() || journal.emotionSelected! == Emotions.mediumHappy.getString()) && journal.sentiment > -0.2){
                results.append(journal)
            }
        })
        return results
    }
}

struct HighestHighsView_Previews: PreviewProvider {
    static var previews: some View {
        HighestHighsView(journalViewModel: JournalViewModel())
    }
}
