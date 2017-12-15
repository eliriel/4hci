//
//  MedReminder.swift
//  MedReminder
//
//  Created by Borislav Hristov on 26.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import CoreData

class MedReminder {
    private init(){}
    private static let instance: MedReminder = MedReminder()
    private var user: UserData?
    private var mainObserver: MainObserver?
    var tmpReminder: ReminderData?
    
    func setMainObserver(mainObserver: MainObserver){
        self.mainObserver = mainObserver
    }
    
    func getMainObserver() ->MainObserver{
        return self.mainObserver!
    }
    
    func setUser(_ user: UserData){
        self.user = user
    }
    
    func getUser() -> UserData{
        return self.user!
    }
    
    static func getInstance() -> MedReminder{
        return self.instance
    }
    
    internal func searchSingle(_ object: NSManagedObject.Type, predicate: NSPredicate? = nil) -> NSManagedObject?{
        if let results = self.search(object, predicate: predicate){
            if let result = results.first{
                return result
            }
        }
        return nil
    }
    
    internal func search(_ object: NSManagedObject.Type, predicate: NSPredicate? = nil) -> [NSManagedObject]?{
        
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        if #available(iOS 10.0, *) {
            fetchRequest = object.fetchRequest()
        } else {
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: object.description().description)
        }
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }

        do {
            return try managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch let error{
            print (error)
        }
        return nil
    }
    
    static func toJSonString(data : Any) -> String {
        var jsonString = "";
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
        } catch {
            print(error.localizedDescription)
        }
        
        return jsonString;
    }
    
    static func fromJSonString(data: String) -> UserObserverData? {
        let dataDecoder: Data = data.data(using: String.Encoding.utf8)!
        
        if let decoded = try? JSONDecoder().decode(UserObserverData.self, from: dataDecoder) {
            return decoded
        }
        
        return nil
    }
}

public struct UserObserverData: Codable {
    let number: String
    let token: String
    let names: String
}
