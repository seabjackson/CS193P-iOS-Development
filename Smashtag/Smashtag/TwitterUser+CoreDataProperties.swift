//
//  TwitterUser+CoreDataProperties.swift
//  Smashtag
//
//  Created by lily on 8/26/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TwitterUser {

    @NSManaged var name: String?
    @NSManaged var screenName: String?
    @NSManaged var tweets: NSSet?

}
