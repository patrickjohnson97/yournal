//
//  ThemeViewModel.swift
//  yournal
//
//  Created by Patrick Johnson on 4/11/21.
//

import Foundation
import SwiftUI

class ThemeViewModel: ObservableObject{
    @AppStorage("user.theme") var theme: String = "Standard"{
        willSet { objectWillChange.send() }
    }
    @Published var observedTheme: String
    init(){
        observedTheme = "Standard"
    }
    
    func observeTheme(){
        self.observedTheme = theme
    }
    
    func updateTheme(name: String){
        theme = name
        self.observedTheme = name
    }
}
