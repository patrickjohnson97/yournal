//
//  Sidebar.swift
//  yournal (iOS)
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI

struct IpadSidebar: View {
    var body: some View {
        NavigationView{
            List {
                NavigationLink(destination: TodayView()) {
                        Label("Today", systemImage: "doc.append")
                }
                NavigationLink(destination: CalendarView(content: { date in
                    Text("\(date.get(.day))").font(.caption)
                        .padding(8).overlay(date <= Date() ?  Circle().stroke(lineWidth: 2).frame(width: 26, height: 26, alignment: .center) : nil)
                })) {
                        Label("History", systemImage: "calendar")
                }
                NavigationLink(destination: ProfileView()) {
                        Label("Profile", systemImage: "person")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Menu")
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        IpadSidebar()
    }
}
