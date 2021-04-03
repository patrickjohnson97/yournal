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
                    RoundedRectangle(cornerRadius: 3).foregroundColor(Color.accentColor).saturation(Double(journalViewModel.entries(at: Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!).count) * 0.39)
                        .frame(width: boxSize)
                }
            }
        }
    }
}

struct ContributionChart_Previews: PreviewProvider {
    static var previews: some View {
        ContributionChart(journalViewModel: JournalViewModel())
    }
}
