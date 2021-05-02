//
//  Tabbar.swift
//  yournal (iOS)
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import UIKit
struct TabbarContents: View {
    @ObservedObject var journalViewModel: JournalViewModel
    @ObservedObject var promptViewModel: PromptViewModel
    @AppStorage("user.tab") var selection: String = "Today"
    var body: some View {
        TabView(selection: $selection) {
//            NavigationView{
//                TodayView(journalViewModel: journalViewModel, promptViewModel: promptViewModel)
//            }
//            .tabItem {
//                Label("Today", systemImage: "doc.append")
//            }
//            .tag("Today")
            NavigationView{
                HistoryView(journalViewModel: journalViewModel, promptViewModel: promptViewModel)
            }
            .tabItem {
                Label("Home", systemImage: "doc.append")
            }
            .tag("History")
            NavigationView{
                ProfileView(journalViewModel: journalViewModel)
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            .tag("Profile")
        }
        
    }
}
