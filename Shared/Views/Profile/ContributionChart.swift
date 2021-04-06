//
//  ContributionChart.swift
//  yournal
//
//  Created by Patrick Johnson on 4/2/21.
//

import SwiftUI

struct ContributionChart: View {
    @ObservedObject var journalViewModel: JournalViewModel
    var body: some View {
        let boxSize: CGFloat = 18
        let rows: [GridItem] = Array(repeating: GridItem(.flexible(minimum: boxSize)), count: 7)
        VStack{
            HStack{
                Text("Streaks").font(.system(.headline, design: .serif)).foregroundColor(Color("Inverse-Background"))
                Spacer()
            }
            LazyHGrid(rows: rows) {
                ForEach((0...89).reversed(), id: \.self){ daysAgo in
                    let entries = journalViewModel.entries(at: Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!)
                    RoundedRectangle(cornerRadius: 3).foregroundColor(entries.isEmpty ? Color("Background"): Color.accentColor).brightness(entries.isEmpty ? 0 :  calculateSaturation(entries: Double(entries.count)))
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
