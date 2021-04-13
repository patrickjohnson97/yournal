//
//  ContributionChart.swift
//  yournal
//
//  Created by Patrick Johnson on 4/2/21.
//

import SwiftUI

struct ContributionChart: View {
    @ObservedObject var journalViewModel: JournalViewModel
    @AppStorage("user.theme") var theme: String = "Parchment"
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        let boxSize: CGFloat = 18
        let rows: [GridItem] = Array(repeating: GridItem(.flexible(minimum: boxSize)), count: 7)
        VStack{
            LazyHGrid(rows: rows) {
                ForEach((0...89).reversed(), id: \.self){ daysAgo in
                    let entries = journalViewModel.entries(at: Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!)
                    RoundedRectangle(cornerRadius: 3).foregroundColor(entries.isEmpty ? getThemeColor(name:"Background", theme: theme): .accentColor).brightness(entries.isEmpty ? 0 :  calculateBrightness(entries: Double(entries.count)))
                        .frame(width: boxSize)
                }
            }
        }
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

struct ContributionChart_Previews: PreviewProvider {
    static var previews: some View {
        ContributionChart(journalViewModel: JournalViewModel())
    }
}
