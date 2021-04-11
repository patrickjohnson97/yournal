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
    @AppStorage("user.theme") var currentTheme: String = "Standard"

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
