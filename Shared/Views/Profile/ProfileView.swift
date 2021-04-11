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
    @AppStorage("user.theme") var theme: String = "Standard"
    var body: some View {
        NavigationView{
            ZStack{
                Background()
                ScrollView{
                    VStack{
                        Divider()
                        HStack{
                            Text("Streaks")
                                .font(.title2).bold()
//                                    .font(.system(.headline, design: .serif))
//                                .foregroundColor(getThemeColor(name:"Inverse-Background"))
                            Spacer()
                        }
                        VStack{
                            
                            ContributionChart(journalViewModel: journalViewModel)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Card", theme: theme)))
                        Divider()
                        HStack{
                            Text("Lists")
                                .font(.title2).bold()
//                                    .font(.system(.headline, design: .serif))
//                                .foregroundColor(getThemeColor(name:"Inverse-Background"))
                            Spacer()
                        }
                        HStack{
                            NavigationLink(destination: HighestHighsView(journalViewModel: journalViewModel), label: {
                                VStack{
                                    HStack{
                                        Text("Highest Highs")
//                                            .font(.headline)
                                            .font(.system(.headline, design: .serif))
                                            .foregroundColor(getThemeColor(name:"Background", theme: theme))
                                        Spacer()
                                    }
                                    .padding()
                                    Spacer()
                                    Chart(data: [1, 4, 1])
                                        .chartStyle(
                                            LineChartStyle(.quadCurve, lineColor: getThemeColor(name:"Background", theme: theme), lineWidth: 3)
                                        )
                                        .frame(height:14)
                                        .padding(.top)
                                }
                                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Chosen", theme: theme)).saturation(0.1))
                            })
                            NavigationLink(destination: LowestLowsView(journalViewModel: journalViewModel), label: {
                                VStack{
                                    HStack{
                                        Text("Lowest Lows")
//                                            .font(.headline)
                                            .font(.system(.headline, design: .serif))
                                            .foregroundColor(getThemeColor(name:"Background", theme: theme))
                                        Spacer()
                                    }.padding()
                                    Spacer()
                                    Chart(data: [4, 1, 4])
                                        .chartStyle(
                                            LineChartStyle(.quadCurve, lineColor: getThemeColor(name:"Background", theme: theme), lineWidth: 3)
                                        )
                                        .frame(height:14)
                                        .padding(.top)
                                }
                                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Inferred", theme: theme)).saturation(0.1))
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                        NavigationLink(destination: EmptyView(), label: {
                        VStack{
                            HStack{
                                Text("Time Capsule")
//                                    .font(.system(.headline, design: .serif))
                                    .foregroundColor(getThemeColor(name:"Background", theme: theme))
                                Spacer()
                            }.padding()
                            Spacer()
                            Chart(data: [1, 1.5, 0.5, 2, 0.25, 2, 0.5, 1.5, 1])
                                .chartStyle(
                                    LineChartStyle(.quadCurve, lineColor: getThemeColor(name:"Background", theme: theme), lineWidth: 3)
                                )
                                .frame(height:20)
                                .padding(.top)
                        }
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Inverse-Card", theme: theme)))
                        })
                        .hidden()
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
