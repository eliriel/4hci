//
//  SettingsController.swift
//  MedReminder
//
//  Created by Borislav Hristov on 26.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: BasicController{
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = MedReminder.getInstance().getUser()
        if let names = user.names{
            self.name.text = names
        }

        if let number = user.number{
            self.number.text = number
        }

    }
    
    @IBAction func nameChange(_ sender: UITextField) {
        MedReminder.getInstance().getUser().names = sender.text
        CoreDataManager.sharedInstance.saveContext()
    }
    
    
    @IBAction func numberChange(_ sender: UITextField) {
        MedReminder.getInstance().getUser().number = sender.text
        CoreDataManager.sharedInstance.saveContext()
    }
}
