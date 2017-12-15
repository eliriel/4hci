//
//  UserObserver+CoreDataProperties.swift
//  
//
//  Created by Borislav Hristov on 30.11.17.
//
//

import Foundation
import CoreData


extension UserObserver {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserObserver> {
        return NSFetchRequest<UserObserver>(entityName: "UserObserver")
    }

    @NSManaged public var names: String?
    @NSManaged public var number: String?
    @NSManaged public var token: String?
    @NSManaged public var reminder: NSOrderedSet?

}

// MARK: Generated accessors for reminder
extension UserObserver {

    @objc(insertObject:inReminderAtIndex:)
    @NSManaged public func insertIntoReminder(_ value: ReminderData, at idx: Int)

    @objc(removeObjectFromReminderAtIndex:)
    @NSManaged public func removeFromReminder(at idx: Int)

    @objc(insertReminder:atIndexes:)
    @NSManaged public func insertIntoReminder(_ values: [ReminderData], at indexes: NSIndexSet)

    @objc(removeReminderAtIndexes:)
    @NSManaged public func removeFromReminder(at indexes: NSIndexSet)

    @objc(replaceObjectInReminderAtIndex:withObject:)
    @NSManaged public func replaceReminder(at idx: Int, with value: ReminderData)

    @objc(replaceReminderAtIndexes:withReminder:)
    @NSManaged public func replaceReminder(at indexes: NSIndexSet, with values: [ReminderData])

    @objc(addReminderObject:)
    @NSManaged public func addToReminder(_ value: ReminderData)

    @objc(removeReminderObject:)
    @NSManaged public func removeFromReminder(_ value: ReminderData)

    @objc(addReminder:)
    @NSManaged public func addToReminder(_ values: NSOrderedSet)

    @objc(removeReminder:)
    @NSManaged public func removeFromReminder(_ values: NSOrderedSet)

}
