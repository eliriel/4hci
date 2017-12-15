//
//  InfoReminder.swift
//  MedReminder
//
//  Created by Borislav Hristov on 30.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import UIKit


class InfoReminders: OpenReminderController, UITableViewDelegate, UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name of medecine"
        case 1:
            return "Quantity needed to be taken"
        case 2:
            return "Time to take"
        case 3:
            return "Next repeat cycle"
        case 4:
            return "Times left to be retaken"
        case 5:
            return "First observer"
        case 6:
            return "Second observer"
        default:
            return "Undefined"
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
        cell.info.text = "Undefined"
        
        switch indexPath.section {
        case 0:
            cell.info.text = reminder?.name ?? "Unknown"
            break
        case 1:
            cell.info.text = reminder?.quantity ?? "Unknown"
            break
        case 2:
            cell.info.text = self.dateFormatter.string(from: reminder?.time as! Date) ?? "Unknown"
            break
        case 3:
            var str = "Not required"
            
            if let repeatTimes = reminder?.repeatTimes , let repeatInt = reminder?.repeatInt{
                if repeatTimes > 0 {
                    
                    if let time = reminder?.time?.addingTimeInterval(repeatInt){
                        str = "\(time)"
                    }
                }
            }
            
            cell.info.text = str
            break
        case 4:
            var str = "Not required"
            
            if let repeatTimes = reminder?.repeatTimes{
                if repeatTimes > 0 {
                    str = "\(repeatTimes)"
                }
            }
            
            cell.info.text = str
            break
        case 5:
            if let observers = self.reminder?.getObservers(){
                if observers.count >= 1 {
                    cell.info.text = observers[0].names ?? "Undefined"
                }
            }
            
            break
        case 6:
            if let observers = self.reminder?.getObservers(){
                if observers.count == 2 {
                    cell.info.text = observers[1].names ?? "Undefined"
                }
            }
            break
        default:
            cell.info.text = "Unknown"
            break
        }
        
        return cell
    }
    
    
    @IBOutlet weak var infoTable: UITableView!
    
    
    
}
