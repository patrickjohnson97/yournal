//
//  yournalApp.swift
//  Shared
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI

@main
struct yournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            Text("hello")
//                .frame(width: 800, height: 800, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }.commands(content: {
            SidebarCommands()
        })
    }
}
