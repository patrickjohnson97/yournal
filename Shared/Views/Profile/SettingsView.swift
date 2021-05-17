//
//  SettingsView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import UserNotifications
struct SettingsView: View {
    @State var theme: String = "Parchment"
    @AppStorage("user.dailynotifications") var isNotificationsOn: Bool = false
    @State var showTipSheet: Bool = false
    var body: some View {
        ZStack{
            Background()
            ScrollView{
                VStack{
                    Divider()
                    HStack{
                        Text("General").textCase(.uppercase).font(.caption).foregroundColor(Color("Secondary-Text"))
                        Spacer()
                    }
                    VStack{
                        NavigationLink(destination: PromptsView(), label: {
                        HStack{
                            Image(systemName: "quote.bubble.fill").foregroundColor(.accentColor)
                            Text("Prompt List")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }.contentShape(Rectangle())
                    })
                    .buttonStyle(PlainButtonStyle())
                    }.padding().background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name: "Card", theme: theme)))
                    
                    HStack{
                        Text("Appearance").textCase(.uppercase).font(.caption).foregroundColor(Color("Secondary-Text"))
                        Spacer()
                    }
                    VStack{
                    NavigationLink(destination: ThemePickerView(), label: {
                        HStack{
                            Image(systemName: "paintbrush.fill").foregroundColor(.accentColor)
                            Text("Theme")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        } .contentShape(Rectangle())
                    })
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                    NavigationLink(destination: IconPickerView(), label: {
                        HStack{
                            Image(systemName: "face.smiling.fill").foregroundColor(.accentColor)
                            Text("Icon")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                    })
                    .buttonStyle(PlainButtonStyle())
                    }.padding().background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name: "Card", theme: theme)))
                    
                    HStack{
                        Text("Alerts").textCase(.uppercase).font(.caption).foregroundColor(Color("Secondary-Text"))
                        Spacer()
                    }
                    VStack{
                    HStack{
                        Image(systemName: "bell.fill").foregroundColor(.accentColor)
                        Text("Journal Reminders").lineLimit(1)
                        Spacer()
                        Toggle(isOn: $isNotificationsOn, label: {
                            EmptyView()
                        })
                        
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    }
                    }.padding().background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name: "Card", theme: theme)))
                    
                    HStack{
                        Text("Support").textCase(.uppercase).font(.caption).foregroundColor(Color("Secondary-Text"))
                        Spacer()
                    }
                    VStack{
                        Button(action: {showTipSheet = true}, label: {
                            HStack{
                                Image(systemName: "gift.fill").foregroundColor(.accentColor)
                                Text("Leave a Tip")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
                            }
                            .contentShape(Rectangle())
                        })
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showTipSheet, content: {
                            TipJarView()
                        })
                        Divider()
                        Button(action: {UIApplication.shared.open(URL(string: "mailto:support@yournal.io")!)}, label: {
                            HStack{
                                Image(systemName: "envelope.fill").foregroundColor(.accentColor)
                                Text("Contact Support")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
                            }
                            .contentShape(Rectangle())
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                    }.padding().background(RoundedRectangle(cornerRadius: 12).foregroundColor(getThemeColor(name: "Card", theme: theme)))
                }
                .padding(.horizontal)
                .onChange(of: isNotificationsOn, perform: { _ in
                    toggleNotificationSettings()
                })
            }
        }.navigationTitle("Settings")
        .onAppear(perform: {
            theme = UserDefaults.standard.string(forKey: "user.theme") ?? "Parchment"
        })
    }
    
    func toggleNotificationSettings(){
        if(isNotificationsOn){
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(true, forKey: "user.dailynotifications")
            }
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  {
                success, error in
                if success {
                    print("authorization granted")
                } else if error != nil{}
                
                
            }
            let content = UNMutableNotificationContent()
            content.title = "Do it for the streak 😤"
            content.body = "It's time for your daily journal📔"
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 20
            dateComponents.minute = 45
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        } else{
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(false, forKey: "user.dailynotifications")
            }
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
