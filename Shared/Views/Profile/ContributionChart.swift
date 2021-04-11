//
//  ContributionChart.swift
//  yournal
//
//  Created by Patrick Johnson on 4/2/21.
//

import SwiftUI

struct ContributionChart: View {
    @ObservedObject var journalViewModel: JournalViewModel
    @AppStorage("user.theme") var theme: String = "Standard"
    var body: some View {
        let boxSize: CGFloat = 18
        let rows: [GridItem] = Array(repeating: GridItem(.flexible(minimum: boxSize)), count: 7)
        VStack{
            LazyHGrid(rows: rows) {
                ForEach((0...89).reversed(), id: \.self){ daysAgo in
                    let entries = journalViewModel.entries(at: Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!)
                    RoundedRectangle(cornerRadius: 3).foregroundColor(entries.isEmpty ? getThemeColor(name:"Background", theme: theme): Color.accentColor).brightness(entries.isEmpty ? 0 :  calculateSaturation(entries: Double(entries.count)))
                        .frame(width: boxSize)
                }
            }
        }
    }
    
    func calculateSaturation(entries: Double) -> Double{
        let top = -(pow(entries, 2)*0.55 - 0.7)
        let bottom = pow(entries, 2) + 11
        return top/bottom
    }
}

struct ContributionChart_Previews: PreviewProvider {
    static var previews: some View {
        ContributionChart(journalViewModel: JournalViewModel())
    }
}
