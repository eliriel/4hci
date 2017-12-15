//
//  History.swift
//  MedReminder
//
//  Created by Borislav Hristov on 30.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import UIKit

class History: BasicController{
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var tableView: UITableView!
    internal var pickerData: [String] = [String]()
    internal var results: [ReminderData]!
    let dateFormatter = DateFormatter()
    
    @IBAction func textChange(_ sender: UITextField) {
        self.dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        self.loadResults(sender.text)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadResults(nil)
        self.populatePickerData()
        self.createPicker()
    }
    
    func loadResults(_ name: String?){
        var results = [ReminderData]()
        if let name = name{
            if let r = MedReminder.getInstance().search (ReminderData.self , predicate: NSPredicate(format: "(name == %@)", name)) as? [ReminderData]{
                print (r)
                results = r
            }
        } else {
            if let r = MedReminder.getInstance().search (ReminderData.self) as? [ReminderData]{
                results = r
            }
        }

        self.results = results
    }
    
    func populatePickerData(){
        var data = [String]()
        for result in results{
            let name = result.name ?? "Undefined"
            if !data.contains(name){
                data.append(name)
            }
        }
        self.pickerData = data
    }
    
    func createPicker(){
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        self.textView.inputView = picker
    }
}

extension History: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //OpenReminder
        let reminder = self.results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
        cell.name.text = reminder.name
        cell.time.text = self.dateFormatter.string(from: reminder.time as! Date)
        cell.quantity.text = reminder.quantity
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        MedReminder.getInstance().tmpReminder = self.results[indexPath.row]
        
        self.performSegue(withIdentifier: "OpenReminder", sender: self)
    }
    
}

extension History: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.loadResults(self.pickerData[row])
        self.tableView.reloadData()
        self.textView.text = self.pickerData[row]
    }
    
    
}
