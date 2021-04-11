//
//  Theme.swift
//  yournal
//
//  Created by Patrick Johnson on 4/11/21.
//

import SwiftUI
import Foundation


var themes: [ThemeSelection] = [ThemeSelection(displayName: "Parchment"),
                                ThemeSelection(name: "Growth", displayName: "Growth"),
                                ThemeSelection(name: "Opposites", displayName: "Opposites"),
                                ThemeSelection(name: "Sunset", displayName: "Sunset"),
                                ThemeSelection(name: "Pastel", displayName: "Pastel")]

struct ThemeSelection: Identifiable{
    var id = UUID()
    var name: String = "Standard"
    var displayName: String
}
