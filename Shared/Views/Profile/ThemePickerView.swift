//
//  ThemePickerView.swift
//  yournal
//
//  Created by Patrick Johnson on 4/11/21.
//

import SwiftUI

struct ThemePickerView: View {
//    @AppStorage("user.theme") var theme: String = "Parchment"
    @State var theme: String = "Parchment"
//    @AppStorage("user.tab") var selection: String = "Profile"
//    @AppStorage("user.themeChanged") var themeChanged: Bool = false
    var body: some View {
        ZStack{
            Background()
            VStack{
            ScrollView{
                ForEach(themes.sorted(by: {$0.displayName < $1.displayName})){ theme in
                    Button(action: {setTheme(name: theme.name)}, label: {
                        HStack{
                            RoundedRectangle(cornerRadius: 8).frame(width: 30).foregroundColor(Color("\(theme.name)/Background")).overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 3).foregroundColor(Color("\(theme.name)/Inferred"))).overlay(Circle().frame(width: 8).foregroundColor(Color("\(theme.name)/Chosen")))
                            VStack(alignment: .leading){
                                Text(theme.displayName).font(.caption).bold()
                                Text(theme.caption).font(.caption2).foregroundColor(Color("Secondary-Text"))
                            }
                            Spacer()
                            if(self.theme == theme.name){
                                Image(systemName: "checkmark").foregroundColor(.accentColor)
                            }
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                }
                .padding()
//                .listRowBackground(getThemeColor(name:"Background", theme: theme))
            }
                Spacer()
            }
        }.navigationTitle("Themes")
    }
    func setTheme(name: String){
        if(theme != name){
            theme = name
            UserDefaults.standard.setValue(name, forKey: "user.theme")
//            DispatchQueue.main.async {
//                theme = name
////                selection = "Profile"
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
//                themeChanged.toggle()
//            })
        }
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView()
    }
}
