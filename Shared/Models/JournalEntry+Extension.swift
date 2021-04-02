//
//  JournalEntry+Extension.swift
//  yournal
//
//  Created by Patrick Johnson on 3/23/21.
//

import Foundation
import CoreData
import UIKit

extension JournalEntry {
    
    // MARK: - Class functions for CRUD operations
    
    // this whole bunch of static functions lets me do a simple fetch and
    // CRUD operations through the AppDelegate, including one called saveChanges(),
    // so that i don't have to litter a whole bunch of try? moc.save() statements
    // out in the Views.
    
    static func count() -> Int {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        
        do {
            let itemCount = try context.count(for: fetchRequest)
            return itemCount
        }
        catch let error as NSError {
            print("Error counting ShoppingItems: \(error.localizedDescription), \(error.userInfo)")
        }
        return 0
    }

    static func allJournals() -> [JournalEntry] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        do {
            let items = try context.fetch(fetchRequest)
            return items
        }
        catch let error as NSError {
            print("Error getting ShoppingItems: \(error.localizedDescription), \(error.userInfo)")
        }
        return [JournalEntry]()
    }
    
    static func dailyJournals(date: Date) -> [JournalEntry] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "%@ >= %@", date as NSDate, dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "%@ < %@", date as NSDate, dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        fetchRequest.predicate = datePredicate
        do {
            let items = try context.fetch(fetchRequest)
            print(items.first?.createdAt)
            return items
        }
        catch let error as NSError {
            print("Error getting ShoppingItems: \(error.localizedDescription), \(error.userInfo)")
        }
        return [JournalEntry]()
    }
    
    // addNewItem is the user-facing add of a new entity.  since these are
    // Identifiable objects, this makes sure we give the entity a unique id, then
    // hand it back so the user can fill in what's important to them.
    static func addNewItem() -> JournalEntry {
        let context = PersistenceController.shared.container.viewContext
        let newItem = JournalEntry(context: context)
        newItem.id = UUID()
        return newItem
    }

    static func saveChanges() {
        do{
            try PersistenceController.shared.container.viewContext.save()
        }catch{
            print("Could not save persistent controller")
        }
    }

    static func delete(entry: JournalEntry, saveChanges: Bool = false) {
        // let anyone who is interested we're about to kill this ShoppingItem
        NotificationCenter.default.post(name: .journalEntryWillBeDeleted, object: entry, userInfo: nil)
        // now delete and save (default)
        entry.managedObjectContext?.delete(entry)
        if saveChanges {
            Self.saveChanges()
        }
    }
    
}
