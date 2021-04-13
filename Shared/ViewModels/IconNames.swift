//
//  IconNames.swift
//  yournal (iOS)
//
//  Created by Patrick Johnson on 4/12/21.
//

import Foundation
import SwiftUI
import UIKit
class IconNames: ObservableObject{
    var iconNames: [String?] = [nil]
    @Published var currentIndex = 0
    init(){
        getAlternateIcons()
        if let currentIcon = UIApplication.shared.alternateIconName{
            self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
    }
    
    func getAlternateIcons(){
        if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String : Any],
           let alternateIcons = icons["CFBundleAlternateIcons"] as? [String : Any] {
            for(_, value) in alternateIcons{
                guard let iconList = value as? Dictionary<String, Any> else { return }
                guard let iconFiles = iconList["CFBundleIconFiles"] as? [String] else {return}
                guard let icon = iconFiles.first else {return}
                iconNames.append(icon)
            }
        }
    }
}
