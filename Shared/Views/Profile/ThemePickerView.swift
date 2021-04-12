//
//  ThemePickerView.swift
//  yournal
//
//  Created by Patrick Johnson on 4/11/21.
//

import SwiftUI

struct ThemePickerView: View {
    @AppStorage("user.theme") var theme: String = "Standard"
    @AppStorage("user.tab") var selection: String = "Profile"
    @AppStorage("user.themeChanged") var themeChanged: Bool = false
    var body: some View {
        ZStack{
            Background()
            List{
                ForEach(themes){ theme in
                    Button(action: {setTheme(name: theme.name)}, label: {
                        HStack{
                            RoundedRectangle(cornerRadius: 8).frame(width: 30).foregroundColor(Color("\(theme.name)/Background")).overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 3).foregroundColor(Color("\(theme.name)/Inferred"))).overlay(Circle().frame(width: 8).foregroundColor(Color("\(theme.name)/Chosen")))
//                            Circle().stroke(lineWidth: 3).foregroundColor(Color("Chosen-\(theme.name)")).frame(width: 30)
//                            Circle().stroke(lineWidth: 3).padding(3).frame(width: 30).opacity(0.4).foregroundColor(.accentColor)
                            Text(theme.displayName)
                            Spacer()
//                            RoundedRectangle(cornerRadius: 8).frame(width: 30).foregroundColor(Color("Background-\(theme.name)")).overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 3).opacity(0.4))
//                            Circle().stroke(lineWidth: 3).foregroundColor(Color("Inferred-\(theme.name)")).frame(width: 30)
//                            Circle().stroke(lineWidth: 3).foregroundColor(Color("Chosen-\(theme.name)")).frame(width: 30)
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .listRowBackground(getThemeColor(name:"Background", theme: theme))
            }
        }.navigationTitle("Themes")
    }
    func setTheme(name: String){
        if(theme != name){
            DispatchQueue.main.async {
                theme = name
                selection = "Profile"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                themeChanged.toggle()
            })
        }
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView()
    }
}
