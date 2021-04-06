//
//  NewJournalView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import NaturalLanguage

struct NewJournalView: View {
    @ObservedObject var journalViewModel: JournalViewModel
    @State var text: String = ""

    @State var prompt: Prompt?
    @Environment(\.presentationMode) var presentationMode
    @State var emotionSelected: Emotions?
    @State var helpButtonSelected: Bool = false
    private var sentiment: Double {
        return Double(performSentimentAnalysis(for: text)) ?? 0.0
    }
    private let tagger = NLTagger(tagSchemes: [.sentimentScore])
    var body: some View {
        ZStack{
            Background()
            VStack{
                HStack{
                    Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                        Text("Cancel")
                    })
                    Spacer()
                    Button(action: {helpButtonSelected = true}, label: {
                        Image(systemName: "info.circle")
                    })
                    Spacer()
                    Button(action: {addJournal()}, label: {
                        Text("Done")
                    })
                }.padding([.top, .horizontal])
                ScrollView{
                    VStack{
                        HStack{
                            Spacer()
                            ForEach(Emotions.allCases, id: \.self){ emotion in
                                Button(action: {selectEmotion(emotion: emotion)}, label: {
                                    Image("\(emotion)-twitter").resizable().aspectRatio(contentMode: .fit).frame(height: 40).clipped().padding(6).overlay(Circle().stroke(lineWidth: 4).foregroundColor(emotionSelected == emotion ? .pink : .accentColor)).saturation(isEmotionSelected(emotion: emotion) ? 1.0 : 0.0)
                                })
                                Spacer()
                            }
                        }.padding(.bottom)
                        PromptSection(prompt: $prompt)
                        ZStack(alignment: .topLeading){
                            Text(text == "" ? "Today was a good day ..." : text).opacity(text == "" ? 0.25 : 0).font(.system(.body, design: .serif))
                            TextEditor(text: $text).font(.system(.body, design: .serif))
                        }
                        .padding(.top)
                        .fixedSize(horizontal: false, vertical: true)
                    }.padding()
                    Spacer()
                }
            }
            if(helpButtonSelected){
                Rectangle().edgesIgnoringSafeArea(.all).foregroundColor(.black).opacity(0.6)
                SentimentOnboardingView(isShowing: self.$helpButtonSelected)
            }
        }.edgesIgnoringSafeArea(.bottom)
        .onAppear(perform: {
            helpButtonSelected = !UserDefaults.standard.bool(forKey: "userOnboardedSentiment")
        })
            
            
    }
    
    private func addJournal(){
        journalViewModel.addEntry(prompt: prompt, text: text, emotionSelected: getEmotionSelected()!.getString(), sentiment: sentiment)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func performSentimentAnalysis(for string: String) -> String {
        tagger.string = string
        let (sentiment, _) = tagger.tag(at: string.startIndex,
                                        unit: .paragraph,
                                        scheme: .sentimentScore)
        return sentiment?.rawValue ?? ""
    }
    
    func selectEmotion(emotion: Emotions){
        if(emotionSelected == nil){
            emotionSelected = emotion
        } else if(emotion == emotionSelected){
            emotionSelected = nil
        } else{
            emotionSelected = emotion
        }
    }
    
    func isEmotionSelected(emotion: Emotions) -> Bool{
        return emotion == getEmotionSelected()
    }
    
    func getEmotionSelected() -> Emotions?{
        if(emotionSelected != nil){
            return emotionSelected!
        }
        if(emotionSelected == nil){
            if self.sentiment > 0.6{
                return .happy
            }
            if self.sentiment > 0.2 && self.sentiment <= 0.6 {
                return .mediumHappy
            }
            if self.sentiment > -0.2 && self.sentiment <= 0.2 {
                return .average
            }
            if self.sentiment > -0.6 && self.sentiment <= -0.2 {
                return .mediumSad
            }
            if self.sentiment >= -1 && self.sentiment <= -0.6 {
                return .sad
            }
        }
        return nil
    }
}

struct NewJournalView_Previews: PreviewProvider {
    static var previews: some View {
        NewJournalView(journalViewModel: JournalViewModel())
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct PromptSection: View {
    @ObservedObject var viewModel = PromptViewModel()
    @Binding var prompt: Prompt?
    var body: some View {
        VStack{
            if(prompt != nil && prompt!.value != ""){
                HStack{
                    Text("Prompt").font(.title2).bold()
                    Spacer()
                    Button(action: {getPrompt()}, label: {
                        Image(systemName: "arrow.clockwise").foregroundColor(.blue)
                            .padding(7)
                            .background(RoundedRectangle(cornerRadius: 7).foregroundColor(Color.blue.opacity(0.12)))
                    }).padding(.trailing, 6)
                    Button(action: {prompt = nil}, label: {
                        Image(systemName: "trash").foregroundColor(.red)
                            .padding(7)
                            .background(RoundedRectangle(cornerRadius: 7).foregroundColor(Color.red.opacity(0.12)))
                    })
                }
                HStack{
                    Text(prompt!.value!).font(.system(.headline, design: .serif)).fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding().background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color("Card")))
            }
            else{
                Button(action: {getPrompt()}, label: {
                    HStack{
                        Spacer()
                        Text("Generate Prompt").font(.headline)
                        Spacer()
                    }
                })
                .buttonStyle(GenericButtonStyle(foregroundColor: .accentColor, backgroundColor: Color.accentColor.opacity(0.14), pressedColor: Color.accentColor.opacity(0.2), internalPadding: 10))
            }
        }.onAppear(perform: {
            viewModel.loadPrompts()
//            viewModel.addPrompt(value: "Tell me about a risk you want to take...")
        })
    }
    func getPrompt(){
        prompt = viewModel.prompts.randomElement()
    }
}

struct SentimentOnboardingView: View {
    @Binding var isShowing: Bool
    @State var emotionSelected: Emotions?
    var sentiment: Double = 0.5
    @State var acknowledgeFirst: Bool = false
    @State var acknowledgeSecond: Bool = false
    @State var acknowledgeThird: Bool = false
    var body: some View {
        VStack{
            Spacer()
            VStack(alignment: .leading){
                HStack{
                    Spacer()
                    ForEach(Emotions.allCases, id: \.self){ emotion in
                        Button(action: {selectEmotion(emotion: emotion)}, label: {
                            Image("\(emotion.getString())-twitter").resizable().aspectRatio(contentMode: .fit).frame(height: 40).clipped().padding(6).overlay(Circle().stroke(lineWidth: 4).foregroundColor(emotionSelected == emotion ? .pink : .accentColor)).saturation(isEmotionSelected(emotion: emotion) ? 1.0 : 0.0)
                        })
                        Spacer()
                    }
                }
                Divider()
                VStack{
                    if(!acknowledgeFirst){
                        HStack{
                            Text("👋 Hello there! ").bold() +
                                Text("I am an ") +
                                Text("Artificial Assistant").bold().foregroundColor(.pink) +
                                Text(" here to help you assess your emotions.")
                        }
                    }else if(!acknowledgeSecond){
                        HStack{
                            Text("Once you start writing, I'll put a ") +
                            Text("blue").bold().foregroundColor(.blue) +
                            Text(" circle around your predicted emotion. If you disagree, change my mind by selecting a different emotion.")
                        }
                    } else if(!acknowledgeThird){
                        HStack{
                            Text("To go back to my selection, just press ") +
                            Text("your selection").bold().foregroundColor(.pink) +
                            Text(" again and I will take care of the rest!")
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color("Card")))
                .padding()
                
                HStack{
                    Spacer()
                    Button(action: {proceed()}, label: {
                        Text("Continue").font(.headline).foregroundColor(.white)
                    })
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.blue))
                    Spacer()
                }
                //                        Button(action: {acknowledgeThird = true}, label: {
                //                            Text("Continue").foregroundColor(.white)
                //                        })
                //                        .padding()
                //                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.blue))
                Rectangle().frame(height: 100).hidden()
            }
            .padding()
            .background(Rectangle().foregroundColor(Color("Background")))
            .cornerRadius(30, corners: [.topLeft, .topRight])
        }
    }
    
    func selectEmotion(emotion: Emotions){
        if(emotionSelected == nil){
            emotionSelected = emotion
        } else if(emotion == emotionSelected){
            emotionSelected = nil
        } else{
            emotionSelected = emotion
        }
    }
    
    func isEmotionSelected(emotion: Emotions) -> Bool{
        getEmotionSelected() == emotion
    }
    
    func getEmotionSelected() -> Emotions?{
        if(emotionSelected != nil){
            return emotionSelected!
        }
        if(emotionSelected == nil){
            if self.sentiment > 0.6{
                return .happy
            }
            if self.sentiment > 0.2 && self.sentiment <= 0.6 {
                return .mediumHappy
            }
            if self.sentiment > -0.2 && self.sentiment <= 0.2 {
                return .average
            }
            if self.sentiment > -0.6 && self.sentiment <= -0.2 {
                return .mediumSad
            }
            if self.sentiment >= -1 && self.sentiment <= -0.6 {
                return .sad
            }
        }
        return nil
    }
    
    func proceed(){
        if(!acknowledgeFirst){
            acknowledgeFirst = true
            return
        }
        if(!acknowledgeSecond){
            acknowledgeSecond = true
            return
        }
        if(!acknowledgeThird){
            acknowledgeThird = true
            isShowing = false
            // Set user defaults
            UserDefaults.standard.set(true, forKey: "userOnboardedSentiment")
            return
        }
    }
}
