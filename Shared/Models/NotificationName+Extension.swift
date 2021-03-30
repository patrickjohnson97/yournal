//
//  NotificationName+Extension.swift
//  yournal
//
//  Created by Patrick Johnson on 3/23/21.
//

import Foundation

// the whole purpose of the NotificationName+Extensions is to centrally define
// names for the Notifications we pass around to let all view models know that
// something is about to be changed in a journal entry.
//
//
extension Notification.Name {
    static let journalEntryAdded = Notification.Name(rawValue: "journalEntryAdded")
    static let journalEntryWillBeDeleted = Notification.Name(rawValue: "journalEntryWillBeDeleted")
    static let promptAdded = Notification.Name(rawValue: "promptAdded")
    static let promptWillBeDeleted = Notification.Name(rawValue: "promptWillBeDeleted")
}
