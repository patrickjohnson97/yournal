//
//  JournalDetailView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI

struct JournalDetailView: View {
    @AppStorage("user.theme") var theme: String = "Standard"
    var entry: JournalEntry
    var body: some View {
        ZStack{
            Background()
            VStack{
                ScrollView{
                    VStack(alignment: .leading){
                        HStack{
                            Spacer()
                            ForEach(Emotions.allCases, id: \.self){ emotion in
                                Image("\(emotion)-twitter").resizable().aspectRatio(contentMode: .fit).frame(height: 40).clipped().padding(6).overlay(Circle().stroke(lineWidth: 4).foregroundColor( getThemeColor(name:"Chosen", theme: theme))).saturation(entry.emotionSelected == emotion.getString()  ? 1.0 : 0.0)
                                Spacer()
                            }
                        }
                        Text(entry.createdAt!.journalDateString).font(.title2).bold().padding(.top)
                        if(entry.prompt != nil && entry.prompt!.value != ""){
                            HStack{
                                Text(entry.prompt!.value!).font(.system(.headline, design: .serif)).fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }
                            .padding().background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Card", theme: theme)))
                        }
                        Divider()
                        Text(entry.text!).font(.system(.body, design: .serif))
                            .padding(.top)
                            .fixedSize(horizontal: false, vertical: true)
                    }.padding()
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }
}

struct JournalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        JournalDetailView(entry: JournalEntry())
    }
}
