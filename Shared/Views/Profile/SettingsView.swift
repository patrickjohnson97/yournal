//
//  SettingsView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI

struct SettingsView: View {
    @State var isNotificationsOn = false
    var body: some View {
        ZStack{
            Background()
            ScrollView{
                VStack{
                    Divider()
                    NavigationLink(destination: PromptsView(), label: {
                        HStack{
                            Image(systemName: "quote.bubble.fill").foregroundColor(.accentColor)
                            Text("Prompt List")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                    NavigationLink(destination: PromptsView(), label: {
                        HStack{
                            Image(systemName: "paintbrush.fill").foregroundColor(.accentColor)
                            Text("Theme")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                    
                    HStack{
                        Image(systemName: "bell.fill").foregroundColor(.accentColor)
                        Text("Journal Reminders")
                        Spacer()
                        Toggle(isOn: $isNotificationsOn, label: {
                            
                        }).toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    }
                    
                    Divider()
                    HStack{
                        Image(systemName: "eyeglasses").foregroundColor(.accentColor)
                        Text("Emotional Assistant")
                        Spacer()
                        Toggle(isOn: $isNotificationsOn, label: {
                            
                        }).toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    }
                    ExtraSettings()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Settings")
    }
}

struct ExtraSettings: View{
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack{
            Divider()
            Button(action: {UIApplication.shared.open(URL(string: "mailto:patrick@patrickjohnson.co")!)}, label: {
                HStack{
                    Image(systemName: "gift.fill").foregroundColor(.accentColor)
                    Text("Leave a Tip")
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(.gray)
                }
            })
            .buttonStyle(PlainButtonStyle())
            Divider()
            Link(destination: URL(string: "https://www.apple.com")!) {
                HStack{
                    Image(systemName: "safari.fill").foregroundColor(.accentColor)
                    Text("App Website")
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(.gray)
                }
            }
            .buttonStyle(PlainButtonStyle())
            Divider()
            Button(action: {UIApplication.shared.open(URL(string: "mailto:patrick@patrickjohnson.co")!)}, label: {
                HStack{
                    Image(systemName: "envelope.fill").foregroundColor(.accentColor)
                    Text("Contact Support")
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(.gray)
                }
            })
            .buttonStyle(PlainButtonStyle())
           
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
