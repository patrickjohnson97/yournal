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
        }.commands(content: {
            SidebarCommands()
        })
    }
}
