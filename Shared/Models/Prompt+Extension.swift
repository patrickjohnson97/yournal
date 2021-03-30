//
//  JournalEntry+Extension.swift
//  yournal
//
//  Created by Patrick Johnson on 3/23/21.
//

import Foundation
import CoreData
import UIKit

extension Prompt {
    
    // MARK: - Class functions for CRUD operations
    
    // this whole bunch of static functions lets me do a simple fetch and
    // CRUD operations through the AppDelegate, including one called saveChanges(),
    // so that i don't have to litter a whole bunch of try? moc.save() statements
    // out in the Views.
    
    static func count() -> Int {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Prompt> = Prompt.fetchRequest()
        
        do {
            let itemCount = try context.count(for: fetchRequest)
            return itemCount
        }
        catch let error as NSError {
            print("Error counting ShoppingItems: \(error.localizedDescription), \(error.userInfo)")
        }
        return 0
    }

    static func allPrompts() -> [Prompt] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Prompt> = Prompt.fetchRequest()
        let promptPredicate = NSPredicate(format: "softDelete == false")
        fetchRequest.predicate = promptPredicate
        do {
            let items = try context.fetch(fetchRequest)
            return items
        }
        catch let error as NSError {
            print("Error getting ShoppingItems: \(error.localizedDescription), \(error.userInfo)")
        }
        return [Prompt]()
    }
    
    static func softDeletedPrompts() -> [Prompt] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Prompt> = Prompt.fetchRequest()
        let promptPredicate = NSPredicate(format: "softDelete == true")
        fetchRequest.predicate = promptPredicate
        do {
            let items = try context.fetch(fetchRequest)
            return items
        }
        catch let error as NSError {
            print("Error getting ShoppingItems: \(error.localizedDescription), \(error.userInfo)")
        }
        return [Prompt]()
    }
    
    // addNewItem is the user-facing add of a new entity.  since these are
    // Identifiable objects, this makes sure we give the entity a unique id, then
    // hand it back so the user can fill in what's important to them.
    static func addNewPrompt() -> Prompt {
        let context = PersistenceController.shared.container.viewContext
        let newItem = Prompt(context: context)
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

    static func delete(prompt: Prompt, saveChanges: Bool = false) {
        // let anyone who is interested we're about to kill this ShoppingItem
        NotificationCenter.default.post(name: .promptWillBeDeleted, object: prompt, userInfo: nil)
        // now delete and save (default)
        prompt.softDelete = true
        if saveChanges {
            Self.saveChanges()
        }
    }
    
}
