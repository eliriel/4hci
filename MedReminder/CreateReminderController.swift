//
//  CreateReminderController.swift
//  MedReminder
//
//  Created by Borislav Hristov on 26.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class CreateReminderController: BasicController{
    let dateFormatter = DateFormatter()
    
    private var observerAData: UserObserverData? = nil
    private var observerBData: UserObserverData? = nil
    
    @IBOutlet weak var medName: UITextField!
    @IBOutlet weak var medQuantity: UITextField!
    @IBOutlet weak var medTime: UITextField!
    @IBOutlet weak var repeatTime: UITextField!
    @IBOutlet weak var repeatNumber: UITextField!
    @IBOutlet weak var observerA: UILabel!
    @IBOutlet weak var observerB: UILabel!
    @IBOutlet weak var clearObserverA: UIButton!
    @IBOutlet weak var clearObserverB: UIButton!
    
    @IBOutlet weak var observerAButton: UIButton!
    @IBOutlet weak var observerBButton: UIButton!
    
    @IBAction func observerAAction(_ sender: Any) {
        self.performSegue(withIdentifier: "ObserverA", sender: self)
    }
    
    @IBAction func observerBAction(_ sender: Any) {
        self.performSegue(withIdentifier: "ObserverB", sender: self)
    }
    
    @IBAction func clearObserverAAction(_ sender: Any) {
        self.observerAData = nil
        self.displayA()
        
    }
    
    @IBAction func clearObserverBAction(_ sender: Any) {
        self.observerBData = nil
        self.displayB()
    }
    
    @IBAction func clearAction(_ sender: Any) {
        self.medName.text = ""
        self.medQuantity.text = ""
        self.medTime.text = ""
        self.repeatTime.text = ""
        self.repeatNumber.text = ""
        
        self.observerAData = nil
        self.displayA()
        
        self.observerBData = nil
        self.displayB()
    }
    
    @IBAction func createAction(_ sender: Any) {
        guard let name = self.medName.text else { return }
        guard let quantity = self.medQuantity.text else { return }
        guard let time = self.medTime.text else { return }
        let repeatTime = self.repeatTime.text
        let repeatNumber = self.repeatNumber.text
        
        if name.count == 0 { return }
        if quantity.count == 0 { return }
        if time.count == 0 { return }
        
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "ReminderData", in:managedContext)
        let reminder = ReminderData(entity: entity!, insertInto: managedContext)

        reminder.name = name
        reminder.quantity = quantity
        reminder.time = dateFormatter.date(from: time) as NSDate?
        reminder.addReminderObserver(self.createObserver(observerAData))
        reminder.addReminderObserver(self.createObserver(observerBData))
        reminder.owner = MedReminder.getInstance().getUser()
        
        if repeatTime?.count != 0 {
            let repeatDate = dateFormatter.date(from: repeatTime!) as NSDate?
            reminder.repeatInt = (repeatDate?.timeIntervalSince(reminder.time as! Date)) ?? 0
        }
        
        if repeatNumber?.count != 0 {
            reminder.repeatTimes = Int64(Int(repeatNumber!) ?? 0)
        }
        
        CoreDataManager.sharedInstance.saveContext()
        MedReminder.getInstance().getMainObserver().updateList()
        
        self.medName.text = ""
        self.medQuantity.text = ""
        self.medTime.text = ""
        self.repeatTime.text = ""
        self.repeatNumber.text = ""

        self.observerAData = nil
        self.displayA()
        
        self.observerBData = nil
        self.displayB()
    }
    
    
    func createObserver(_ observer: UserObserverData?) -> UserObserver?{
        guard let observer = observer else { return nil }
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        var user = MedReminder.getInstance().searchSingle(UserObserver.self , predicate: NSPredicate(format: "(number == %@)", observer.number ))

        if user == nil {
            let entity =  NSEntityDescription.entity(forEntityName: "UserObserver", in:managedContext)
            user = UserObserver(entity: entity!, insertInto: managedContext)
        }
        
        if let user = user as? UserObserver{
            user.names = observer.names
            user.number = observer.number
            user.token = observer.token
            CoreDataManager.sharedInstance.saveContext()
        
            return user
        }

        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SelectObserver
        vc.side = segue.identifier == "ObserverA"
        vc.crp = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"

        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.addTarget(self, action: #selector(CreateReminderController.pickerChagned(sender:)), for: .valueChanged)
        self.medTime.inputView = picker
        
        let picker2 = UIDatePicker()
        picker2.datePickerMode = .dateAndTime
        picker2.addTarget(self, action: #selector(CreateReminderController.pickerReChagned(sender:)), for: .valueChanged)
        self.repeatTime.inputView = picker2
        
    }
    
    
    @objc internal func pickerChagned(sender: UIDatePicker){
        self.medTime.text = self.dateFormatter.string(from: sender.date)
    }
    
    @objc internal func pickerReChagned(sender: UIDatePicker){
        self.repeatTime.text = self.dateFormatter.string(from: sender.date)
    }
}

extension CreateReminderController: CreateReminderProtocol{
    
    func updateObserverA(_ observer: UserObserverData?){
        self.observerAData = observer
        self.displayA()
    }
    
    
    func updateObserverB(_ observer: UserObserverData?){
        self.observerBData = observer
        self.displayB()
    }
    
    private func displayA(){
        if let observer = self.observerAData{
            self.observerA.text = observer.names
            self.observerAButton.isHidden = true
            self.clearObserverA.isHidden = false
            self.observerA.isHidden = false
        } else {
            self.observerA.text = ""
            self.observerAButton.isHidden = false
            self.clearObserverA.isHidden = true
            self.observerA.isHidden = true
        }
    }
    
    private func displayB(){
        if let observer = self.observerBData{
            self.observerB.text = observer.names
            self.observerBButton.isHidden = true
            self.clearObserverB.isHidden = false
            self.observerB.isHidden = false
        } else {
            self.observerB.text = ""
            self.observerBButton.isHidden = false
            self.clearObserverB.isHidden = true
            self.observerB.isHidden = true
        }
    }
}
