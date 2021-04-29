//
//  SettingsView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import UserNotifications
struct SettingsView: View {
    @State var isNotificationsOn: Bool = UserDefaults.standard.bool(forKey: "user.dailynotifications")
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
                        }.contentShape(Rectangle())
                    })
                    .buttonStyle(PlainButtonStyle())
                    Divider()
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
                    Divider()
                    
                    HStack{
                        Image(systemName: "bell.fill").foregroundColor(.accentColor)
                        Text("Journal Reminders").lineLimit(1)
                        Spacer()
                        Toggle(isOn: $isNotificationsOn, label: {
                            
                        })
                        .onReceive([self.isNotificationsOn].publisher.first()) { (value) in
                            print("New value is: \(value)")
                            toggleNotificationSettings()
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    }
                    ExtraSettings()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Settings")
    }
    
    func toggleNotificationSettings(){
        if(isNotificationsOn){
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UserDefaults.standard.setValue(true, forKey: "user.dailynotifications")
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  {
                success, error in
                if success {
                    print("authorization granted")
                } else if error != nil{}
                
                
            }
            // 2.
            let content = UNMutableNotificationContent()
            content.title = "Do it for the streak 😤"
            content.body = "It's time for your daily journal📔"
            content.sound = UNNotificationSound.default
            
            // 4.
            var dateComponents = DateComponents()
            dateComponents.hour = 20
            dateComponents.minute = 45
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
            
            // 5.
            UNUserNotificationCenter.current().add(request)
        } else{
            UserDefaults.standard.setValue(false, forKey: "user.dailynotifications")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
}

struct ExtraSettings: View{
    @Environment(\.openURL) var openURL
    @State var showTipSheet = false
    var body: some View {
        VStack{
            Divider()
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
            //            Divider()
            //            Link(destination: URL(string: "https://www.apple.com")!) {
            //                HStack{
            //                    Image(systemName: "safari.fill").foregroundColor(.accentColor)
            //                    Text("App Website")
            //                    Spacer()
            //                    Image(systemName: "chevron.right").foregroundColor(.gray)
            //                }
            //            }
            //            .buttonStyle(PlainButtonStyle())
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
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
