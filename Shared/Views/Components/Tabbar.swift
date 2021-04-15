//
//  Tabbar.swift
//  yournal (iOS)
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import UIKit
import AlertToast
struct Tabbar: View {
    @State var showWelcomeScreen = false
    @ObservedObject var promptViewModel = PromptViewModel()
    @ObservedObject var journalViewModel = JournalViewModel()
    @AppStorage("user.theme") var currentTheme: String = "Parchment"
    @AppStorage("user.themeChanged") var themeChanged: Bool = false
    var body: some View {
        VStack{
            ForEach(themes){ theme in
                if(currentTheme == theme.name){
                    ThemeTabbar(journalViewModel: journalViewModel, promptViewModel: promptViewModel, theme: theme.name)
                }
            }
        }
        .sheet(isPresented: $showWelcomeScreen, onDismiss: {setUpUser()}, content: {
            WelcomeScreenView(showWelcomeScreen: $showWelcomeScreen)
        })
        .accentColor(getThemeColor(name: "Inferred", theme: currentTheme))
        .onAppear(perform: {
            showWelcomeScreen = !UserDefaults.standard.bool(forKey: "userWelcomed")
            promptViewModel.loadPrompts()
            journalViewModel.loadAllJournals()
        })
        .toast(isPresenting: $journalViewModel.deleteNotification, duration: 6.0, tapToDismiss: true, alert: {
            AlertToast(displayMode: .hud, type: .systemImage("trash", getThemeColor(name: "Chosen", theme: currentTheme)), title: "Journal deleted" , subTitle: "Another one bites the dust😕")
        }, completion: {_ in
            DispatchQueue.main.async {
                journalViewModel.deleteNotification = false
            }
        })
        .toast(isPresenting: $themeChanged, duration: 6.0, tapToDismiss: true, alert: {
            AlertToast(displayMode: .hud, type: .systemImage("paintbrush.fill", getThemeColor(name: "Chosen", theme: currentTheme)), title: "Theme changed!" , subTitle: "Time to give these colors a spin😎")
        }, completion: {_ in
            DispatchQueue.main.async {
                themeChanged = false
            }
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
