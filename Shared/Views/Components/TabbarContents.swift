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
    @AppStorage("user.tab") var selection: String = "Home"
    var body: some View {
        TabView(selection: $selection) {
            NavigationView{
                HistoryView(journalViewModel: journalViewModel, promptViewModel: promptViewModel)
            }
            .tabItem {
                Label("Home", systemImage: selection == "Home" ? "doc.append.fill" : "doc.append")
            }
            .tag("Home")
            NavigationView{
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: selection == "Settings" ? "gearshape.fill" : "gearshape")
            }
            .tag("Settings")
        }
        
    }
}
