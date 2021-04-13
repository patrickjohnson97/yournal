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
                let iconOptions = getIconOptions()
                ForEach(iconOptions.sorted(by: {$0.displayName < $1.displayName})){ icon in
                    Button(action: {setIcon(name: "\(icon.name)-\(theme)")}, label: {
                        HStack{
                            Image("\(icon.name)-\(theme)")
                                .resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40).clipped()
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 3).foregroundColor(.black).opacity(0.5))
                            VStack(alignment: .leading){
                                Text(icon.displayName).font(.caption).bold()
                                Text(icon.caption).font(.caption2).foregroundColor(Color("Secondary-Text"))
                            }
//                            Text(icon ?? "Default")
                            Spacer()
                            if(iconSettings.iconNames[iconSettings.currentIndex] == "\(icon.name)-\(theme)"){
                                Image(systemName: "checkmark").foregroundColor(.accentColor)
                            }
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
}

struct IconOption: Identifiable{
    var id = UUID()
    var name: String
    var displayName: String
    var caption: String
}

func getIconOptions() -> [IconOption]{
    return [IconOption(name: "Enlightened", displayName: "The Enlightened One", caption: "Find the inner you"), IconOption(name: "Original", displayName: "O.G.", caption: "As real as it gets"), IconOption(name: "Chosen", displayName: "The Chosen One", caption: "Pick me!! Pick me!!"), IconOption(name: "Chosen-Light", displayName: "The (Lighter) Chosen One", caption: "Pick me, I'm cute"), IconOption(name: "Inferred", displayName: "The Inferred One", caption: "I knew you'd pick me"), IconOption(name: "Inferred-Light", displayName: "The (Lighter) Inferred One", caption: "I gotta feelin'")]
}

struct IconPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IconPickerView()
    }
}


