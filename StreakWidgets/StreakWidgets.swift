//
//  StreakWidgets.swift
//  StreakWidgets
//
//  Created by Patrick Johnson on 4/18/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    @ObservedObject var journalViewModel = JournalViewModel()
    func placeholder(in context: Context) -> JournalsEntry {
        journalViewModel.loadAllJournals()
        return JournalsEntry(date: Date(), configuration: ConfigurationIntent(), entries: [], theme: "Parchment")
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (JournalsEntry) -> ()) {

        let entry = JournalsEntry(date: Date(), configuration: ConfigurationIntent(), entries: [], theme: "Parchment")
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [JournalsEntry] = []
        let theme = UserDefaults(suiteName: "com.yournal.defaults")?.string(forKey: "user.theme") ?? "Parchment"
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = JournalsEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
        entries.append(JournalsEntry(date: Date(), configuration: ConfigurationIntent(), entries: journalViewModel.journals, theme: theme))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct JournalsEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let entries : [JournalEntry]
    let theme : String
}

struct StreakWidgetsEntryView : View {
    var entry: Provider.Entry
    
    
    var body: some View {
        HStack(spacing: 4){
            ForEach((0...16).reversed(), id: \.self){ week in
                VStack(spacing: 4){
                    ForEach((0...6).reversed(), id: \.self){ dayOfWeek in
                        let daysAgo = -(week*7+dayOfWeek)+(7-Calendar.current.component(.weekday, from: Date()))
                        DailyStreakView(allEntries: entry.entries, theme: entry.theme, daysAgo: daysAgo)
                    }
                }
            }
        }.padding()
    }
}

@main
struct StreakWidgets: Widget {
    let kind: String = "StreakWidgets"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            StreakWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Streaks")
        .description("See your journaling progress over the past 90 days.")
        .supportedFamilies([])
    }
}

struct StreakWidgets_Previews: PreviewProvider {
    static var previews: some View {
        StreakWidgetsEntryView(entry: JournalsEntry(date: Date(), configuration: ConfigurationIntent(), entries: [], theme: "Parchment"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

struct DailyStreakView: View {
    @State var allEntries: [JournalEntry]
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
