//
//  CoreData.swift
//  MedReminder
//
//  Created by Borislav Hristov on 09/01/2017.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

//
//  CareData.swift
//  RateFreak
//
//  Created by Borislav Hristov on 09/01/2017.
//  Copyright © 2017 SanderHristov. All rights reserved.
//

import Foundation
import CoreData

protocol NotificationsNSManagedObject: class{
    func notify(_ object: NSManagedObject)
}


public struct CoreDataManagerObserverAction {
    var state: CoreDataContextObserverState
    weak var view: NotificationsNSManagedObject?
}

class CoreDataManager {
    // MARK: - Core Data stack
    
    static let sharedInstance = CoreDataManager()
    
    init(){
        NotificationCenter.default.addObserver(self, selector: #selector(CoreDataManager.sharedInstance.handleContextObjectDidChangeNotification(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: self.managedObjectContext)
    }
    
    private lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "MedReminder", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("MedReminder.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext: NSManagedObjectContext?
        if #available(iOS 10.0, *){
            managedObjectContext = self.persistentContainer.viewContext
        }
        else{
            // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
            let coordinator = self.persistentStoreCoordinator
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext?.persistentStoreCoordinator = coordinator
            
        }
        
        return managedObjectContext!
    }()
    // iOS-10
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MedReminder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        //print("\(self.applicationDocumentsDirectory)")
        return container
    }()
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                print ("CoreDataManager saved")
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    public var enabled: Bool = true
    public var contextChangeBlock: CoreDataContextObserverContextChangeBlock?
    
    private var notificationObserver: NSObjectProtocol?
    private(set) var actionsForManagedObjectID: Dictionary<NSManagedObjectID,[CoreDataManagerObserverAction]> = [:]
    
    deinit {
        self.unobserveAllObjects()
        if let notificationObserver = notificationObserver {
            NotificationCenter.default.removeObserver(notificationObserver)
        }
    }
    
    @objc func handleContextObjectDidChangeNotification(notification: NSNotification) {
        guard let _ = notification.object as? NSManagedObjectContext else {
                return
        }
        
        let insertedObjectsSet = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? Set<NSManagedObject>()
        let updatedObjectsSet = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? Set<NSManagedObject>()
        let deletedObjectsSet = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> ?? Set<NSManagedObject>()
        let refreshedObjectsSet = notification.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject> ?? Set<NSManagedObject>()
        
        
        var combinedObjectChanges = insertedObjectsSet.map({ CoreDataObserverObjectChange.Inserted($0) })
        combinedObjectChanges += updatedObjectsSet.map({ CoreDataObserverObjectChange.Updated($0) })
        combinedObjectChanges += deletedObjectsSet.map({ CoreDataObserverObjectChange.Deleted($0) })
        combinedObjectChanges += refreshedObjectsSet.map({ CoreDataObserverObjectChange.Refreshed($0) })
        
        contextChangeBlock?(notification,combinedObjectChanges)
        
        
        let combinedSet = insertedObjectsSet.union(updatedObjectsSet).union(deletedObjectsSet)
        let allObjectIDs = Array(actionsForManagedObjectID.keys)
        let filteredObjects = combinedSet.filter({ allObjectIDs.contains($0.objectID) })
        
        for object in filteredObjects {
            guard let actionsForObject = actionsForManagedObjectID[object.objectID] else { continue }
            
            for action in actionsForObject {
                if action.state.contains(.Inserted) && insertedObjectsSet.contains(object) {
                    action.view?.notify(object)
                } else if action.state.contains(.Updated) && updatedObjectsSet.contains(object) {
                    action.view?.notify(object)
                } else if action.state.contains(.Deleted) && deletedObjectsSet.contains(object) {
                    action.view?.notify(object)
                } else if action.state.contains(.Refreshed) && refreshedObjectsSet.contains(object) {
                    action.view?.notify(object)
                }
            }
        }        
    }
    
    public func observeObject(object: NSManagedObject, state: CoreDataContextObserverState = .All, view: NotificationsNSManagedObject) {
        let action = CoreDataManagerObserverAction(state: state, view: view)
        if var actionArray = actionsForManagedObjectID[object.objectID] {
            actionArray.append(action)
            actionsForManagedObjectID[object.objectID] = actionArray
        } else {
            actionsForManagedObjectID[object.objectID] = [action]
        }
        
    }
    
    public func unobserveObjects(object: NSManagedObject, forState state: CoreDataContextObserverState = .All , view: NotificationsNSManagedObject) {
        if let actionsForObject = actionsForManagedObjectID[object.objectID] {
            if state == .All {
                actionsForManagedObjectID[object.objectID] = actionsForObject.filter({ if let savedView = $0.view{ return !(savedView === view)  } else { return false }  })
            } else {
                actionsForManagedObjectID[object.objectID] = actionsForObject.filter({ !$0.state.contains(state) && !($0.view === view) })
            }
        }
    }
    
    public func unobserveAllObjects() {
        actionsForManagedObjectID.removeAll()
    }
    
    public func unobserveAllObjectsForView(_ view: NotificationsNSManagedObject) {
        for (key , value) in self.actionsForManagedObjectID{
            self.actionsForManagedObjectID[key] = value.filter({if let savedView = $0.view{ return !(savedView === view)  } else { return false }})
        }
    }
}
