//
//  JournalDetailView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import AlertToast
struct JournalDetailView: View {
    @AppStorage("user.theme") var theme: String = "Parchment"
    @ObservedObject var journalViewModel: JournalViewModel
    @State var readyToDelete = false
    @State var showConfirmationModal = false
    @Environment(\.presentationMode) var presentationMode
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
                        if(entry.createdAt != nil){
                            Text(entry.createdAt!.journalDateString).font(.title2).bold().padding(.top)
                        }
                        if(entry.prompt != nil && entry.prompt!.value != ""){
                            HStack{
                                Text(entry.prompt!.value!).font(.system(.headline, design: .serif)).fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }
                            .padding().background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Card", theme: theme)))
                        }
                        Divider()
                        Text(entry.text ??  "").font(.system(.body, design: .serif))
                            .padding(.top)
                            .fixedSize(horizontal: false, vertical: true)
                    }.padding()
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                    Text("")
                }
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {deleteEntry()}, label:{
                    Image(systemName: "trash")
                })
                .foregroundColor(getThemeColor(name: "Chosen", theme: theme))
                .buttonStyle(PlainButtonStyle())
            })
        })
        .alert(isPresented: $showConfirmationModal) {
                    Alert(
                        title: Text("Are you sure you want to delete this?"),
                        message: Text("There is no undo"),
                        primaryButton: .destructive(Text("Delete")) {
                            readyToDelete = true
                            deleteEntry()
                        },
                        secondaryButton: .cancel()
                    )
                }
        .toast(isPresenting: $journalViewModel.dataOperationInProgress, alert: {
            AlertToast(displayMode: .hud, type: .loading)
        }, completion: { _ in
            self.presentationMode.wrappedValue.dismiss()
        })
    }
    
    func deleteEntry(){
        if(readyToDelete){
            journalViewModel.delete(entry: entry)
        } else{
            showConfirmationModal = true
        }
    }
}

struct JournalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        JournalDetailView(journalViewModel: JournalViewModel(), entry: JournalEntry())
    }
}
