//
//  ThemeUtilities.swift
//  yournal
//
//  Created by Patrick Johnson on 4/10/21.
//

import Foundation
import SwiftUI

func getThemeColor(name: String, theme: String) -> Color{
    return Color("\(theme)/\(name)")
}

