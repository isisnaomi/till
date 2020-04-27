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
        let date1 = Date()
        let dateStart =  calendar.startOfDay(for: date1)
        let date2 = date

        let componentsDay = calendar.dateComponents([.day,], from: dateStart, to: date2)
        let componentsHour = calendar.dateComponents([.hour, .minute], from: date1, to: date2)

        var verbose = verboseCountDown(day: componentsDay.day!, hour: componentsHour.hour!, minutes: componentsHour.minute!)
        return verbose
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
    
    private func verboseCountDown(day: Int, hour: Int, minutes: Int) -> String {
        if day == 0 {
            if isAllDay.boolValue {
                return "Today"
            } else {
                if hour == 0 {
                    if minutes == 0 {
                        return "Happening now"
                    } else if minutes < 0 {
                        return "\(abs(minutes)) minutes ago"
                    } else {
                        return "In \(minutes) minutes"
                    }
                } else if hour < 0 {
                    return "\(abs(hour)) hours and \(abs(minutes)) minutes ago"
                }
                return "In \(hour) hours and \(minutes) minutes"
            }
        } else if day > 0 {
            if abs(day) == 1 {
                return "Tomorrow"
            } else {
                return "In \(abs(day)) days"
            }
        } else {
            if abs(day) == 1 {
                return "Yesterday"
            } else {
                return "\(abs(day)) days ago"
            }
        }
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
