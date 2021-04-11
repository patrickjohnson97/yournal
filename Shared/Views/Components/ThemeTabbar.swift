//
//  Tabbar.swift
//  yournal (iOS)
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import UIKit
struct ThemeTabbar: View {
    @ObservedObject var journalViewModel: JournalViewModel
    @ObservedObject var promptViewModel: PromptViewModel
    init(journalViewModel: JournalViewModel, promptViewModel: PromptViewModel, theme: String){
        self.journalViewModel = journalViewModel
        self.promptViewModel = promptViewModel
        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = UIColor(getThemeColor(name: "Background", theme: theme))
        UITabBar.appearance().standardAppearance = tabAppearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(getThemeColor(name: "Background", theme: theme))
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().showsVerticalScrollIndicator = false
    }
    var body: some View {
        TabbarContents(journalViewModel: journalViewModel, promptViewModel: promptViewModel)
    }
}
