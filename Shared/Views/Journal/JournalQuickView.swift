//
//  JournalQuickView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI

struct JournalQuickView: View {
    @AppStorage("user.theme") var theme: String = "Parchment"
    var entry: JournalEntry
    var body: some View {
        VStack(alignment: .leading){
            if(entry.prompt != nil){
                HStack{
                    Text("Prompt: ").bold() +
                        Text(entry.prompt!.value!).bold()
                    Spacer()
                }.lineLimit(2)
                .foregroundColor(Color("Secondary-Text"))
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Background", theme: theme)))
                .padding(3)
            }
            HStack(alignment: .top){
                Image("\(entry.emotionSelected ?? "happy")-twitter").resizable().aspectRatio(contentMode: .fit).frame(height: 30).clipped().padding(6).overlay(Circle().stroke(lineWidth: 4).foregroundColor(getThemeColor(name:"Chosen", theme: theme))).padding(.trailing, 8)
                VStack(alignment: .leading){
                    Text(entry.text ?? "").font(.system(.body, design: .serif)).lineLimit(2)
                }
                Spacer()
            }
        }
    }
}

struct JournalQuickView_Previews: PreviewProvider {
    static var previews: some View {
        JournalQuickView(entry: JournalEntry())
    }
}
