//
//  Tabbar.swift
//  yournal (iOS)
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import UIKit
struct Tabbar: View {
    @State var showWelcomeScreen = false
    @ObservedObject var promptViewModel = PromptViewModel()
    @ObservedObject var journalViewModel = JournalViewModel()
    init(){
        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = UIColor(Color("Background"))
        UITabBar.appearance().standardAppearance = tabAppearance
//        UITabBar.appearance().backgroundColor = UIColor(Color("Background"))
//
//        UITabBar.appearance().barTintColor = UIColor(Color("Background"))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(Color("Background"))
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().showsVerticalScrollIndicator = false
    }
    var body: some View {
        TabView {
            
            NavigationView{
                TodayView(journalViewModel: journalViewModel)
            }
            .tabItem {
                Label("Today", systemImage: "doc.append")
            }
            
            HistoryView(journalViewModel: journalViewModel)
            .tabItem {
                Label("History", systemImage: "calendar")
            }
            ProfileView(journalViewModel: journalViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .sheet(isPresented: $showWelcomeScreen, onDismiss: {setUpUser()}, content: {
            WelcomeScreenView(showWelcomeScreen: $showWelcomeScreen)
        })
        .onAppear(perform: {
            showWelcomeScreen = !UserDefaults.standard.bool(forKey: "userWelcomed")
//            showWelcomeScreen = true
            promptViewModel.loadPrompts()
            journalViewModel.loadAllJournals()
        })
    }
    
    func setUpUser(){
        UserDefaults.standard.set(true, forKey: "userWelcomed")
        if(promptViewModel.prompts.count == 0){
            initializePrompts(promptViewModel: promptViewModel)
        }
    }
}

struct Tabbar_Previews: PreviewProvider {
    static var previews: some View {
        Tabbar()
    }
}
