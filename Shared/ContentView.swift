//
//  ContentView.swift
//  Shared
//
//  Created by Patrick Johnson on 3/21/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    @ViewBuilder var body: some View {
        
        #if os(iOS)
        if horizontalSizeClass == .compact {
            Tabbar()
        } else {
            IpadSidebar()
            
        }
        #elseif os(watchOS)
        Tabbar()
        #elseif os(tvOS)
        Tabbar()
        #elseif os(macOS)
//        NavigationView {
//            MacSidebar().frame(minWidth: 900, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
//            TodayView()
//        }
        MacSidebar()
            .frame(minWidth: 900, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        #endif
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            ContentView().preferredColorScheme(.dark).previewDevice("iPad Pro (12.9-inch) (4th generation)").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
