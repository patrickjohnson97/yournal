//
//  JournalViewModel.swift
//  yournal
//
//  Created by Patrick Johnson on 3/23/21.
//

import Foundation

class JournalViewModel: ObservableObject{
    @Published var journals = [JournalEntry]()
    @Published var deleteNotification = false
    var hasDataLoaded: Bool = false
    @Published var dataOperationInProgress = false
    init(){
        NotificationCenter.default.addObserver(self, selector: #selector(journalEntryAdded), name: .journalEntryAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(journalEntryWillBeDeleted), name: .journalEntryWillBeDeleted, object: nil)
    }
    
    func loadJournals(date: Date){
        if !hasDataLoaded{
            journals = JournalEntry.dailyJournals(date: date)
            hasDataLoaded = true
        }
    }
    
    func loadAllJournals(){
        if !hasDataLoaded{
            journals = JournalEntry.allJournals()
            hasDataLoaded = true
        }
    }
    
    @objc func journalEntryAdded(_ notification: Notification) {
        // the notification has a reference to the item that has been added.
        // if we're interested in it, now's the time to add it to the items array.
        guard let entry = notification.object as? JournalEntry else { return }
        if !journals.contains(entry){
            addToEntries(entry: entry)
        }
    }
    
    @objc func journalEntryWillBeDeleted(_ notification: Notification) {
        // the notification has a reference to the item that will be deleted.
        // if we're holding on to it, now's the time to remove it from the items array.
        guard let entry = notification.object as? JournalEntry else { return }
        if journals.contains(entry) {
            removeFromEntries(entry: entry)
        }
        self.dataOperationInProgress = false
        self.deleteNotification = true
    }
    
    // MARK: - Private Utility Functions
    
    // we keep the items array sorted at all times.  whenever the content of the items array
    // changes, be sure we call sortItems(), which will trigger an objectWillChange.send().
    private func sortEntries() {
        journals.sort(by: { $0.createdAt! < $1.createdAt! })
    }
    
    // simple utility to remove an item (known to exist)
    private func removeFromEntries(entry: JournalEntry) {
        let index = journals.firstIndex(of: entry)!
        journals.remove(at: index) // will not change the sort order of the item array
    }
    
    // simple utility to add an item (that we know should be on our list)
    private func addToEntries(entry: JournalEntry) {
        journals.append(entry) // may have compromised the sort order
//        sortEntries()
    }
    
    // MARK: - User Intent Handlers
    
    // ALL FUNCTIONS IN THIS AREA do CRUD changes to an item directly and then send
    // a notification to ourself (and to all other shopping list view models) that we've done
    // something to an item. if those view models are interested in the item, then
    // they will adjust their items array accordingly and will publish the change
    
    // deletes an item.
    func delete(entry: JournalEntry) {
        dataOperationInProgress = true
        JournalEntry.delete(entry: entry, saveChanges: true)
    }
    
    func addEntry(prompt: Prompt?, text: String, emotionSelected: String, sentiment: Double){
        let newItem = JournalEntry.addNewItem()
        newItem.createdAt = Date()
        newItem.emotionSelected = emotionSelected
        newItem.prompt = prompt
        newItem.text = text
        newItem.sentiment = sentiment
        NotificationCenter.default.post(name: .journalEntryAdded, object: newItem)
        JournalEntry.saveChanges()
    }
    
    // MARK: - Functions used by a multi-section view model
    func entries(at day: Date) -> [JournalEntry] {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: day) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        return journals.filter({ $0.createdAt! <  dateTo! && $0.createdAt! >= dateFrom})
    }
    
    func monthEntries(at day: Date) -> [JournalEntry] {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.date(from: calendar.dateComponents([.year, .month], from: day))!
        let dateTo = dateFrom.monthAfter
        return journals.filter({ $0.createdAt! <  dateTo && $0.createdAt! >= dateFrom})
    }
    
    // returns the items at a location to drive listing items in each section
    //        func items(at location: Location) -> [ShoppingItem] {
    //            return items.filter({ $0.location! == location }).sorted(by: { $0.name! < $1.name! })
    //        }
}
