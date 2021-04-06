//
//  ProfileView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import Charts

struct ProfileView: View {
    @ObservedObject var journalViewModel : JournalViewModel
    var body: some View {
        NavigationView{
            ZStack{
                Background()
                ScrollView{
                    VStack{
                        ContributionChart(journalViewModel: journalViewModel)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color("Card")))
                        Divider()
                        HStack{
                            NavigationLink(destination: HighestHighsView(journalViewModel: journalViewModel), label: {
                                VStack{
                                    HStack{
                                        Text("Highest Highs").font(.system(.headline, design: .serif)).foregroundColor(Color("Background"))
                                        Spacer()
                                    }
                                    .padding()
                                    Spacer()
                                    Chart(data: [1, 4, 1])
                                        .chartStyle(
                                            LineChartStyle(.quadCurve, lineColor: Color("Background"), lineWidth: 3)
                                        )
                                        .frame(height:14)
                                        .padding(.top)
                                }
                                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color.pink).saturation(0.1))
                            })
                            NavigationLink(destination: LowestLowsView(journalViewModel: journalViewModel), label: {
                                VStack{
                                    HStack{
                                        Text("Lowest Lows").font(.system(.headline, design: .serif)).foregroundColor(Color("Background"))
                                        Spacer()
                                    }.padding()
                                    Spacer()
                                    Chart(data: [4, 1, 4])
                                        .chartStyle(
                                            LineChartStyle(.quadCurve, lineColor: Color("Background"), lineWidth: 3)
                                        )
                                        .frame(height:14)
                                        .padding(.top)
                                }
                                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color.blue).saturation(0.1))
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                        NavigationLink(destination: EmptyView(), label: {
                        VStack{
                            HStack{
                                Text("Time Capsule").font(.system(.headline, design: .serif)).foregroundColor(Color("Background"))
                                Spacer()
                            }.padding()
                            Spacer()
                            Chart(data: [1, 1.5, 0.5, 2, 0.25, 2, 0.5, 1.5, 1])
                                .chartStyle(
                                    LineChartStyle(.quadCurve, lineColor: Color("Background"), lineWidth: 3)
                                )
                                .frame(height:20)
                                .padding(.top)
                        }
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color("Inverse-Card")))
                        })
                    }.padding(.horizontal)
                    EmptyView()
                }
            }
            .navigationTitle("Profile")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    NavigationLink(destination: SettingsView(), label: {
                        Image(systemName: "gear")
                    })
                    .buttonStyle(PlainButtonStyle())
                })
            })
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(journalViewModel: JournalViewModel())
    }
}
