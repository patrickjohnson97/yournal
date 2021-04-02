//
//  Date+Extensions.swift
//  yournal
//
//  Created by Patrick Johnson on 4/1/21.
//

import Foundation

extension Date {
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var isFuture: Bool {
        return (Calendar.current.compare(Date(), to: self, toGranularity: .nanosecond) == .orderedAscending)
    }
    
    var monthAfter: Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    
    var monthBefore: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
    
    var weekAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 7, to: self)!
    }

    var weekBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!
    }
    
    var isStartOfMonth: Bool {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        let startOfMonth = Calendar.current.date(from: components)
        let day = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self))
        return day == startOfMonth
    }
    
    var isEndOfMonth: Bool {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        let startOfMonth = Calendar.current.date(from: components)
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = Calendar.current.date(byAdding: comps2 as DateComponents, to: startOfMonth!)
        let day = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self))
        return day == endOfMonth
    }
}
