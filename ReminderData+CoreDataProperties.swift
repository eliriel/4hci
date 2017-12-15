//
//  ReminderData+CoreDataProperties.swift
//  
//
//  Created by Borislav Hristov on 30.11.17.
//
//

import Foundation
import CoreData


extension ReminderData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderData> {
        return NSFetchRequest<ReminderData>(entityName: "ReminderData")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: String?
    @NSManaged public var repeatInt: Double
    @NSManaged public var repeatTimes: Int64
    @NSManaged public var taken: Bool
    @NSManaged public var time: NSDate?
    @NSManaged public var observer: NSOrderedSet?
    @NSManaged public var owner: UserData?
    @NSManaged public var takenTimes: NSOrderedSet?

}

// MARK: Generated accessors for observer
extension ReminderData {

    @objc(insertObject:inObserverAtIndex:)
    @NSManaged public func insertIntoObserver(_ value: UserObserver, at idx: Int)

    @objc(removeObjectFromObserverAtIndex:)
    @NSManaged public func removeFromObserver(at idx: Int)

    @objc(insertObserver:atIndexes:)
    @NSManaged public func insertIntoObserver(_ values: [UserObserver], at indexes: NSIndexSet)

    @objc(removeObserverAtIndexes:)
    @NSManaged public func removeFromObserver(at indexes: NSIndexSet)

    @objc(replaceObjectInObserverAtIndex:withObject:)
    @NSManaged public func replaceObserver(at idx: Int, with value: UserObserver)

    @objc(replaceObserverAtIndexes:withObserver:)
    @NSManaged public func replaceObserver(at indexes: NSIndexSet, with values: [UserObserver])

    @objc(addObserverObject:)
    @NSManaged public func addToObserver(_ value: UserObserver)

    @objc(removeObserverObject:)
    @NSManaged public func removeFromObserver(_ value: UserObserver)

    @objc(addObserver:)
    @NSManaged public func addToObserver(_ values: NSOrderedSet)

    @objc(removeObserver:)
    @NSManaged public func removeFromObserver(_ values: NSOrderedSet)

}

// MARK: Generated accessors for takenTimes
extension ReminderData {

    @objc(insertObject:inTakenTimesAtIndex:)
    @NSManaged public func insertIntoTakenTimes(_ value: TakeTimes, at idx: Int)

    @objc(removeObjectFromTakenTimesAtIndex:)
    @NSManaged public func removeFromTakenTimes(at idx: Int)

    @objc(insertTakenTimes:atIndexes:)
    @NSManaged public func insertIntoTakenTimes(_ values: [TakeTimes], at indexes: NSIndexSet)

    @objc(removeTakenTimesAtIndexes:)
    @NSManaged public func removeFromTakenTimes(at indexes: NSIndexSet)

    @objc(replaceObjectInTakenTimesAtIndex:withObject:)
    @NSManaged public func replaceTakenTimes(at idx: Int, with value: TakeTimes)

    @objc(replaceTakenTimesAtIndexes:withTakenTimes:)
    @NSManaged public func replaceTakenTimes(at indexes: NSIndexSet, with values: [TakeTimes])

    @objc(addTakenTimesObject:)
    @NSManaged public func addToTakenTimes(_ value: TakeTimes)

    @objc(removeTakenTimesObject:)
    @NSManaged public func removeFromTakenTimes(_ value: TakeTimes)

    @objc(addTakenTimes:)
    @NSManaged public func addToTakenTimes(_ values: NSOrderedSet)

    @objc(removeTakenTimes:)
    @NSManaged public func removeFromTakenTimes(_ values: NSOrderedSet)

}
