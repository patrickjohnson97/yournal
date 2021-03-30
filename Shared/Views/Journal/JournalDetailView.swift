//
//  JournalDetailView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI

struct JournalDetailView: View {
    var entry: JournalEntry
    var emotions = ["happy", "medium-happy", "average", "medium-sad", "sad"]
    var body: some View {
        ZStack{
            Background()
            VStack{
                ScrollView{
                    VStack(alignment: .leading){
                        HStack{
                            Spacer()
                            ForEach(emotions, id: \.self){ emotion in
                                Image("\(emotion)-twitter").resizable().aspectRatio(contentMode: .fit).frame(height: 40).clipped().padding(6).overlay(Circle().stroke(lineWidth: 4).foregroundColor( .pink)).saturation(entry.emotionSelected == emotion  ? 1.0 : 0.0)
                                Spacer()
                            }
                        }
                        if(entry.prompt != nil && entry.prompt!.value != ""){
                            VStack{
                                    HStack{
                                        Text("Prompt").font(.title2).bold()
                                        Spacer()
                                    }
                                    HStack{
                                        Text(entry.prompt!.value!).font(.system(.headline, design: .serif)).fixedSize(horizontal: false, vertical: true)
                                        Spacer()
                                    }
                                    .padding().background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color("Card")))
                            }.padding(.top)
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
