//
//  ProfileView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import Charts
import AlertToast

struct ProfileView: View {
    @ObservedObject var journalViewModel : JournalViewModel
    @AppStorage("user.theme") var theme: String = "Standard"
    @AppStorage("user.themeChanged") var themeChanged: Bool = false
    @State var showPopup: Bool = false
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
                            Spacer()
                        }
                        ContributionChart(journalViewModel: journalViewModel)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Card", theme: theme)))
                        Divider()
                        HStack{
                            Text("Lists")
                                .font(.title2).bold()
                            Spacer()
                        }
                        HStack{
                            NavigationLink(destination: HighestHighsView(journalViewModel: journalViewModel), label: {
                                VStack{
                                    HStack{
                                        Text("Highest Highs")
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
                                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Chosen", theme: theme)))
                            })
                            NavigationLink(destination: LowestLowsView(journalViewModel: journalViewModel), label: {
                                VStack{
                                    HStack{
                                        Text("Lowest Lows")
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
                                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Inferred", theme: theme)))
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                        NavigationLink(destination: EmptyView(), label: {
                        VStack{
                            HStack{
                                Text("Time Capsule")
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
            .onChange(of: themeChanged, perform: { value in
                showPopup = true
            })
            
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
        .toast(isPresenting: $showPopup, duration: 6.0, tapToDismiss: true, alert: {
            AlertToast(displayMode: .hud, type: .complete(getThemeColor(name: "Chosen", theme: theme)), title: "Theme changed!" , subTitle: "Time to give these colors a spin😎")
        }, completion: {_ in
            DispatchQueue.main.async {
                showPopup = false
            }
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(journalViewModel: JournalViewModel()).preferredColorScheme(.dark)
        ProfileView(journalViewModel: JournalViewModel()).preferredColorScheme(.light)
    }
}
