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
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().showsVerticalScrollIndicator = false
    }
    var body: some View {
        TabbarContents(journalViewModel: journalViewModel, promptViewModel: promptViewModel)
    }
}
