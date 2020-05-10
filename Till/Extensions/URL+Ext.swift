//
//  URL+Ext.swift
//  Till
//
//  Created by Isis Ramirez on 09/05/20.
//  Copyright © 2020 Isis Ramirez. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class NSCustomPersistentContainer: NSPersistentCloudKitContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.isisnaomi.till.Till")
        storeURL = storeURL?.appendingPathComponent("till.sqlite")
        return storeURL!
    }

}
