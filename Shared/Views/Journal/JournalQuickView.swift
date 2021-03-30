//
//  JournalQuickView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI

struct JournalQuickView: View {
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
                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color("Background")))
                .padding(3)
            }
            HStack(alignment: .top){
                Image("\(entry.emotionSelected!)-twitter").resizable().aspectRatio(contentMode: .fit).frame(height: 30).clipped().padding(6).overlay(Circle().stroke(lineWidth: 4).foregroundColor(.pink)).padding(.trailing, 8)
//                Image("\(entry.emotionSelected)-twitter").resizable().aspectRatio(contentMode: .fit).frame(width: 40).clipped()
                VStack(alignment: .leading){
                    Text(entry.text!).font(.system(.body, design: .serif)).lineLimit(2)
                }
                Spacer()
            }
//            Spacer()
        }
    }
}

struct JournalQuickView_Previews: PreviewProvider {
    static var previews: some View {
        JournalQuickView(entry: JournalEntry())
    }
}
