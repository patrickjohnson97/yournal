//
//  Theme.swift
//  yournal
//
//  Created by Patrick Johnson on 4/11/21.
//

import SwiftUI
import Foundation


var themes: [ThemeSelection] = [ThemeSelection(name: "Parchment", displayName: "Parchment", caption:"Pen and paper, baby"),
                                ThemeSelection(name: "Growth", displayName: "Growth", caption: "Be better today"),
                                ThemeSelection(name: "Opposite", displayName: "Opposites", caption: "...Polarizing"),
                                ThemeSelection(name: "Sunset", displayName: "Sunset", caption: "Wow, so pretty!"),
                                ThemeSelection(name: "Pastel", displayName: "Pastel", caption: "Okay this one's cute")]

struct ThemeSelection: Identifiable, Hashable{
    var id = UUID()
    var name: String
    var displayName: String
    var caption: String
}
