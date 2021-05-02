//
//  Sidebar.swift
//  yournal (iOS)
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI

struct IpadSidebar: View {
    @ObservedObject var promptViewModel = PromptViewModel()
    @ObservedObject var journalViewModel = JournalViewModel()
    @AppStorage("user.theme") var currentTheme: String = "Parchment"
    init(){
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().showsVerticalScrollIndicator = false
    }
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: TodayView(journalViewModel: journalViewModel, promptViewModel: promptViewModel)) {
                        Label("Today", systemImage: "doc.append")
                }
                NavigationLink(destination: HistoryView(journalViewModel: journalViewModel, promptViewModel: promptViewModel)) {
                        Label("History", systemImage: "calendar")
                }
                NavigationLink(destination: ProfileView(journalViewModel: journalViewModel)) {
                        Label("Profile", systemImage: "person")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Menu")
            .onAppear(perform: {
//                showWelcomeScreen = !UserDefaults.standard.bool(forKey: "userWelcomed")
                promptViewModel.loadPrompts()
                journalViewModel.loadAllJournals()
            })
            TodayView(journalViewModel: journalViewModel, promptViewModel: promptViewModel)
        }
        .accentColor(getThemeColor(name: "Inferred", theme: currentTheme))
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        IpadSidebar()
    }
}
