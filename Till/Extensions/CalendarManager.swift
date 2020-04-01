//
//  CalendarManager.swift
//  Till
//
//  Created by Isis Ramirez on 31/03/20.
//  Copyright © 2020 Isis Ramirez. All rights reserved.
//

import Foundation
import EventKit

class CalendarManager {
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, location: String?, completion: ((_ identifier: String, _ error: NSError?) -> Void)? = nil) {
     DispatchQueue.global(qos: .background).async { () -> Void in
         let eventStore = EKEventStore()

         eventStore.requestAccess(to: .event, completion: { (granted, error) in
             if (granted) && (error == nil) {
                 let alarm = EKAlarm(relativeOffset: -3600.0)
                 let event = EKEvent(eventStore: eventStore)
                 event.title = title
                 event.startDate = startDate
                 event.endDate = endDate
                 event.notes = description
                 event.alarms = [alarm]
                 event.location = location
                 event.calendar = eventStore.defaultCalendarForNewEvents
                 do {
                     try eventStore.save(event, span: .thisEvent)
                 } catch let e as NSError {
                     completion?("", e)
                     print ("\(#file) - \(#function) error: \(e.localizedDescription)")
                     return
                 }
                completion?(eventStore.eventStoreIdentifier, nil)
             } else {
                 completion?("", error as NSError?)
                 print ("\(#file) - \(#function) error: \(error)")
             }
         })
     }
    }
}
