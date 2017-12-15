//
//  MainController.swift
//  MedReminder
//
//  Created by Borislav Hristov on 26.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ReminderCell: UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var taken: UISwitch!
    @IBOutlet weak var openReminder: UIButton!
    
}

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let dateFormatter = DateFormatter()
    private var reminders = [ReminderData]()
    private var tmpRem: ReminderData?
    @IBOutlet weak var remindersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        self.prepareReminders()
        MedReminder.getInstance().setMainObserver(mainObserver: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminder = self.reminders[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
        cell.name.text = reminder.name
        cell.time.text = self.dateFormatter.string(from: reminder.time as! Date)
        cell.quantity.text = reminder.quantity
        
        cell.taken.addTarget(self, action: #selector(MainController.reminderChange(sender:)), for: .valueChanged)
        cell.openReminder.addTarget(self, action: #selector(MainController.openReminder(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc internal func reminderChange(sender: UISwitch){
        if sender.isOn{
            if let cell = sender.superview?.superview as? ReminderCell {
                let indexPath = self.remindersTable.indexPath(for: cell)
                if let index = indexPath?.row{
                    let reminder = self.reminders[index]
                    
                    let managedContext = CoreDataManager.sharedInstance.managedObjectContext
                    let entity =  NSEntityDescription.entity(forEntityName: "TakeTimes", in:managedContext)
                    let taken = TakeTimes(entity: entity!, insertInto: managedContext)
                    
                    taken.shouldHaveTaken = reminder.time
                    taken.takenTime = NSDate()
                    reminder.addTakenTime(taken)
                    
                    if reminder.repeatInt > 0 && reminder.repeatTimes > 0 {
                        reminder.repeatTimes = reminder.repeatTimes - 1
                        reminder.time = reminder.time?.addingTimeInterval(reminder.repeatInt)
                        self.updateList()
                        
                        sender.isOn = false
                    }
                    
                    CoreDataManager.sharedInstance.saveContext()
                }
            }
        }
    }
    
    @objc internal func openReminder(sender: UIButton){
        if let cell = sender.superview?.superview as? ReminderCell {
            let indexPath = self.remindersTable.indexPath(for: cell)
            if let index = indexPath?.row{
                MedReminder.getInstance().tmpReminder = self.reminders[index]
                
                self.tabBarController?.performSegue(withIdentifier: "OpenReminder", sender: self)
                
            }
        }
    }
    
}

extension MainController: MainObserver{
    private func sortReminders(){
        var reminders = self.reminders
        
        reminders = reminders.sorted {
            if let first = $0.time as? Date, let second = $1.time as? Date{
                return first < second
            }
            return false
        }
        
        self.reminders = reminders
    }
    
    
    func prepareReminders() {
        let currentDate = Date()
        let user = MedReminder.getInstance().getUser()
        self.reminders.removeAll()
        if let reminders = user.reminder?.array as? [ReminderData]{
            reminders.forEach{ (r) in
                if (r.time as! Date) > currentDate {
                    self.reminders.append(r)
                }
            }
            
        }
        
        self.sortReminders()
    }
    
    
    func updateList() {
        self.prepareReminders()
        self.remindersTable.reloadData()
    }
    
    
    
}

