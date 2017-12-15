//
//  TakenReminders.swift
//  MedReminder
//
//  Created by Borislav Hristov on 30.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import UIKit

class TakenReminders: OpenReminderController, UITableViewDataSource{
    var takeTimes: [TakeTimes]!
    @IBOutlet weak var takenTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if var takeTimes = self.reminder?.getTakeTimes(){
            
            takeTimes = takeTimes.sorted {
                if let first = $0.shouldHaveTaken as? Date, let second = $1.shouldHaveTaken as? Date{
                    return first > second
                }
                return false
            }
            
            self.takeTimes = takeTimes
        } else {
            self.takeTimes = [TakeTimes]()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return takeTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let takeTime = self.takeTimes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TakenCell", for: indexPath) as! TakenCell
        
        
        
        if abs(Int32((takeTime.shouldHaveTaken?.timeIntervalSince(takeTime.takenTime as! Date))!)) > 600 {
            cell.backgroundColor = UIColor(red: 255 / 255.0 , green: 148 / 255.0 , blue: 148 / 255.0 , alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 204 / 255.0 , green: 255 / 255.0 , blue: 229 / 255.0 , alpha: 1.0)
        }
        
        
        cell.shouldHave.text = self.dateFormatter.string(from: takeTime.shouldHaveTaken as! Date)
        cell.actuallyDid.text = self.dateFormatter.string(from: takeTime.takenTime as! Date)
        
        return cell
    }
    
}


class TakenCell: UITableViewCell{
    
    @IBOutlet weak var shouldHave: UILabel!
    @IBOutlet weak var actuallyDid: UILabel!
}

