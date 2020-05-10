//
//  TodayViewController.swift
//  Countdowns
//
//  Created by Isis Ramirez on 09/05/20.
//  Copyright © 2020 Isis Ramirez. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData
import Foundation


class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    var upcomingEvents: [Event] =  []
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSCustomPersistentContainer(name: "Till")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchUpcomingEvents() {
      let managedContext = self.persistentContainer.viewContext
        let fetchEvents = Event.getAllEvents()
        let events = try! managedContext.fetch(fetchEvents)
        if events.count > 6 {
            upcomingEvents = Array(events[0..<6])
        } else {
            upcomingEvents = events
        }
    }
    
    // MARK: - Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width:self.view.frame.size.width, height:330)

        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
        fetchUpcomingEvents()
        table.delegate = self
        table.dataSource = self
        let tableViewCellNib = UINib(nibName: "EventCell", bundle: nil)
        table.register(tableViewCellNib, forCellReuseIdentifier: "EventCell")
    }
 
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let height: CGFloat = CGFloat(upcomingEvents.count *  55)
        if activeDisplayMode == NCWidgetDisplayMode.compact
        {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 110)
        }
        else
        {
            self.preferredContentSize = CGSize(width: maxSize.width, height: height)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: - Table

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.nameLabel.text = upcomingEvents[indexPath.row].name
        cell.daysUntilLabel.text =  upcomingEvents[indexPath.row].daysUntil()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingEvents.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
