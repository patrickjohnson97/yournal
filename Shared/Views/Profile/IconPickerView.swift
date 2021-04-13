//
//  ThemePickerView.swift
//  yournal
//
//  Created by Patrick Johnson on 4/11/21.
//

import SwiftUI

struct IconPickerView: View {
    @AppStorage("user.theme") var theme: String = "Parchment"
    @ObservedObject var iconSettings = IconNames()
    var body: some View {
        ZStack{
            Background()
            List{
                let themedIcons = iconSettings.iconNames
                    .filter({
                    $0 != nil && $0!.contains(theme)
                })
                ForEach(themedIcons, id: \.self){ icon in
                    Button(action: {setIcon(name: icon ?? "Original-\(theme)")}, label: {
                        HStack{
                            Image("\(icon ?? "Original-\(theme)")")
                                .resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40).clipped()
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 3).foregroundColor(.black).opacity(0.5))
                            Text(icon ?? "Default")
                            Spacer()
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .listRowBackground(getThemeColor(name:"Background", theme: theme))
            }
        }.navigationTitle("Icons")
    }
    
    func setIcon(name: String){
        if UIApplication.shared.supportsAlternateIcons {
        let nameIndex = iconSettings.iconNames.firstIndex(where: {
            $0 == name
        })
        if iconSettings.currentIndex != nameIndex {
            UIApplication.shared.setAlternateIconName(
                self.iconSettings.iconNames[nameIndex ?? 0]
                , completionHandler: { error in
                if error != nil {
                    print(error)
                }
                self.iconSettings.currentIndex = nameIndex ?? 0
            })
        }
        } else{
            print("ALTERNATE ICONS NOT SUPPORTED")
        }
    }
//    func setTheme(name: String){
//        if(theme != name){
//            DispatchQueue.main.async {
//                theme = name
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
//                themeChanged.toggle()
//            })
//        }
//    }
}

struct IconPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IconPickerView()
    }
}
