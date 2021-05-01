//
//  ContributionView.swift
//  yournal
//
//  Created by Patrick Johnson on 4/29/21.
//

import SwiftUI

struct StreaksView: View {
    var numRows: Int
    @AppStorage("user.theme") var theme: String = "Parchment"
    @ObservedObject var journalViewModel: JournalViewModel
    var body: some View {
        HStack(spacing: 4){
            ForEach((0...numRows).reversed(), id: \.self){ week in
                VStack(spacing: 4){
                    ForEach((0...6).reversed(), id: \.self){ dayOfWeek in
                        let daysAgo = -(week*7+dayOfWeek)+(7-Calendar.current.component(.weekday, from: Date()))
                        DailyStreakView(allEntries: journalViewModel.journals, theme: theme, daysAgo: daysAgo)
                    }
                }
            }
        }.padding()
    }
}

struct StreaksView_Previews: PreviewProvider {
    static var previews: some View {
        StreaksView(numRows: 20, journalViewModel: JournalViewModel())
    }
}


struct DailyStreakView: View {
    var allEntries: [JournalEntry]
    @State var theme: String
    @Environment(\.colorScheme) var colorScheme
    var daysAgo: Int
    var body: some View {
        VStack{
            let day = Calendar.current.date(byAdding: .day, value: daysAgo, to: Date())!
            if(!day.isFuture){
                let entries = getEntriesFromDay(at: day)
                RoundedRectangle(cornerRadius: 3).foregroundColor(entries.isEmpty ? getThemeColor(name:"Background", theme: theme) : .accentColor).brightness(entries.isEmpty ? 0 :  calculateBrightness(entries: Double(entries.count)))
            } else{
                RoundedRectangle(cornerRadius: 3).hidden()
            }
        }
    }
    
    func getEntriesFromDay(at day: Date) -> [JournalEntry] {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: day) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        return allEntries.filter({ $0.createdAt! <  dateTo! && $0.createdAt! >= dateFrom})
    }
    
    func calculateBrightness(entries: Double) -> Double{
        if colorScheme == .light{
            if entries == 1 {
                return 0.2
            }else if entries == 2{
                return 0
            } else if entries == 3{
                return -0.2
            } else if entries == 4{
                return -0.4
            } else {
                return -0.5
            }
        } else{
            if entries == 1 {
                return 0
            }else if entries == 2{
                return -0.25
            } else if entries == 3{
                return -0.45
            } else if entries == 4{
                return -0.65
            } else {
                return -0.8
            }
        }
    }
}
