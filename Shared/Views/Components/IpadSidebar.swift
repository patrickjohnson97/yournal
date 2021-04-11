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
//                NavigationLink(destination: TodayView()) {
//                        Label("Today", systemImage: "doc.append")
//                }
                NavigationLink(destination: EmptyView()) {
                        Label("History", systemImage: "calendar")
                }
//                NavigationLink(destination: ProfileView()) {
//                        Label("Profile", systemImage: "person")
//                }
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
