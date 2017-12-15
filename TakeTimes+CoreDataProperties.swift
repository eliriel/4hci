//
//  TakeTimes+CoreDataProperties.swift
//  
//
//  Created by Borislav Hristov on 30.11.17.
//
//

import Foundation
import CoreData


extension TakeTimes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TakeTimes> {
        return NSFetchRequest<TakeTimes>(entityName: "TakeTimes")
    }

    @NSManaged public var shouldHaveTaken: NSDate?
    @NSManaged public var takenTime: NSDate?
    @NSManaged public var reminder: ReminderData?

}
