//
//  ReminderDataExtension.swift
//  MedReminder
//
//  Created by Borislav Hristov on 27.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation

extension ReminderData{
    
    
    func addReminderObserver(_ observer: UserObserver?){
        guard let observer = observer else { return }
        self.mutableOrderedSetValue(forKey: "observer").add(observer)
    }
    
    func addTakenTime(_ time: TakeTimes){
        self.mutableOrderedSetValue(forKey: "takenTimes").add(time)
    }
    
    func getObservers() -> [UserObserver]{
        if let observer = self.observer?.array as? [UserObserver]{
            return observer
        }
        return [UserObserver]()
    }
    
    func getTakeTimes() -> [TakeTimes]{
        if let takenTimes = self.takenTimes?.array as? [TakeTimes]{
            return takenTimes
        }
        
        return [TakeTimes]()
    }
    
}
