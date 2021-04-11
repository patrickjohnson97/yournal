//
//  Sidebar.swift
//  yournal (iOS)
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI

struct MacSidebar: View {
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
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MacSidebar_Previews: PreviewProvider {
    static var previews: some View {
        MacSidebar()
    }
}
