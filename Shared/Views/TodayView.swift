//
//  TodayView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI

struct TodayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var journalViewModel: JournalViewModel
    @ObservedObject var promptViewModel: PromptViewModel
    @State var showNewJournalSheet: Bool = false
    var body: some View {
        ZStack{
            Background()
            ScrollView{
                Button(action: {showNewJournalSheet = true}, label: {
                    HStack{
                        Spacer()
                        Image(systemName: "plus")
                        Spacer()
                    }
                })
                .buttonStyle(GenericButtonStyle(foregroundColor: .accentColor, backgroundColor: Color.accentColor.opacity(0.14), pressedColor: Color.accentColor.opacity(0.2), internalPadding: 15))
                .padding()
                .sheet(isPresented: $showNewJournalSheet, content: {
                    NewJournalView(journalViewModel: journalViewModel, promptViewModel: promptViewModel)
                })
                let journals = journalViewModel.entries(at: Date())
                if !journals.isEmpty {
                    Divider().padding(.horizontal)
                    HStack{
                        Text("Journals").font(.title2).bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    JournalListView(journals: journals, journalViewModel: journalViewModel)
                        .padding(.horizontal)

                }
            }
        }
        .navigationTitle("My Day")
        .onAppear(perform: {
            self.journalViewModel.loadJournals(date: Date())
        })
    }
}

struct GenericButtonStyle: ButtonStyle {
    var foregroundColor: Color
    var backgroundColor: Color
    var pressedColor: Color
    var internalPadding: CGFloat
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(internalPadding)
            .foregroundColor(foregroundColor)
            .background(configuration.isPressed ? pressedColor : backgroundColor)
            .cornerRadius(12)
    }
}

struct TodayView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            NavigationView{
                TodayView(journalViewModel: JournalViewModel(), promptViewModel: PromptViewModel())
            }
            .preferredColorScheme(.dark)
            NavigationView{
                TodayView(journalViewModel: JournalViewModel(), promptViewModel: PromptViewModel())
            }
            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
            .preferredColorScheme(.dark)
        }
    }
}

struct JournalListView: View {
    var journals: [JournalEntry]
    @ObservedObject var journalViewModel: JournalViewModel
    @AppStorage("user.theme") var theme: String = "Standard"
    var body: some View {
        VStack(alignment: .leading){
            ForEach(journals.indices, id: \.self){ index in
                NavigationLink(
                    destination: JournalDetailView(journalViewModel: journalViewModel, entry: journals[index]),
                    label: {
                        JournalQuickView(entry: journals[index])
                    }).buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 5)
                if(index != journals.count-1){
                    Divider()
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name:"Card", theme: theme)))
    }
}
