//
//  JournalViewModel.swift
//  yournal
//
//  Created by Patrick Johnson on 3/23/21.
//

import Foundation

class PromptViewModel: ObservableObject{
    @Published var prompts = [Prompt]()
    var hasDataLoaded: Bool = false
    init(){
        NotificationCenter.default.addObserver(self, selector: #selector(promptAdded), name: .promptAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(promptWillBeDeleted), name: .promptWillBeDeleted, object: nil)
    }
    
    func loadPrompts(){
        if !hasDataLoaded{
            prompts = Prompt.allPrompts()
            hasDataLoaded = true
        }
    }
    @objc func promptAdded(_ notification: Notification) {
        // the notification has a reference to the item that has been added.
        // if we're interested in it, now's the time to add it to the items array.
        guard let prompt = notification.object as? Prompt else { return }
        if !prompts.contains(prompt){
            addToPrompts(prompt: prompt)
        }
    }
    
    @objc func promptWillBeDeleted(_ notification: Notification) {
        // the notification has a reference to the item that will be deleted.
        // if we're holding on to it, now's the time to remove it from the items array.
        guard let prompt = notification.object as? Prompt else { return }
        if prompts.contains(prompt) {
            removeFromPrompts(prompt: prompt)
        }
    }
    
    // MARK: - Private Utility Functions
    
    // simple utility to remove an item (known to exist)
    private func removeFromPrompts(prompt: Prompt) {
        let index = prompts.firstIndex(of: prompt)!
        prompts.remove(at: index) // will not change the sort order of the item array
    }
    
    // simple utility to add an item (that we know should be on our list)
    private func addToPrompts(prompt: Prompt) {
        prompts.insert(prompt, at: 0) // may have compromised the sort order
    }
    
    // MARK: - User Intent Handlers
    
    // ALL FUNCTIONS IN THIS AREA do CRUD changes to an item directly and then send
    // a notification to ourself (and to all other shopping list view models) that we've done
    // something to an item. if those view models are interested in the item, then
    // they will adjust their items array accordingly and will publish the change
    
    // deletes an item.
    func delete(prompt: Prompt) {
        Prompt.delete(prompt: prompt, saveChanges: true)
    }
    
    func addPrompt(value: String){
        if let softDeletedPrompt = Prompt.softDeletedPrompts().first(where: {$0.value == value}){
            softDeletedPrompt.softDelete = false
            NotificationCenter.default.post(name: .promptAdded, object: softDeletedPrompt)
        }
        else{
            if(!prompts.contains(where: {$0.value == value})){
                let newPrompt = Prompt.addNewPrompt()
                newPrompt.value = value
                NotificationCenter.default.post(name: .promptAdded, object: newPrompt)
            }
        }
        JournalEntry.saveChanges()
    }
    
    // returns the items at a location to drive listing items in each section
    //        func items(at location: Location) -> [ShoppingItem] {
    //            return items.filter({ $0.location! == location }).sorted(by: { $0.name! < $1.name! })
    //        }
}
