//
//  Event.swift
//  Till
//
//  Created by Isis Ramirez on 17/10/19.
//  Copyright © 2019 Isis Ramirez. All rights reserved.
//

import Foundation
import CoreData
import Combine

public class Event: NSManagedObject, Identifiable {
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var image: String?
    @NSManaged public var calendarEventIdentifier: String?
    @NSManaged public var isAllDay: NSNumber

    public func daysUntil() -> String {
        let calendar = Calendar.current
        
        guard let date = self.date else { return "undefined"}
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        let day = components.day ?? 0
        var verbose = ""
        if day >= 0 {
            verbose = abs(day) == 1 ? "day left" : "days left"
        } else {
            verbose = abs(day) == 1 ? "day ago" : "days ago"
        }
        return "\(abs(day)) \(verbose)"
    }
    
    public func future() -> Bool {
        let calendar = Calendar.current
        
        guard let date = self.date else { return false}
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        let day = components.day ?? 0
        return day >= 0
    }
    
}

extension Event {
    static func getAllEvents() -> NSFetchRequest<Event> {
        let request: NSFetchRequest<Event> = NSFetchRequest<Event>(entityName: "Event")

        
        let sortDescriptor = NSSortDescriptor(key: "date",ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    public override func willChangeValue(forKey key: String) {
         super.willChangeValue(forKey: key)
        self.objectWillChange.send()
    }
    
//    override public func willChangeValue(forKey key: String) {
//        super.willChangeValue(forKey: key)
//        self.objectWillChange.send()
//    }
}
