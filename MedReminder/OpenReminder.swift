//
//  CreateReminderController.swift
//  MedReminder
//
//  Created by Borislav Hristov on 26.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import UIKit

class OpenReminder: UITabBarController{
    
}

class OpenReminderController: BasicController{
    var reminder: ReminderData?
    let dateFormatter = DateFormatter()
    
    @IBAction func doneAciton(_ sender: Any) {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reminder = MedReminder.getInstance().tmpReminder
        self.dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
    }
    
}

class InfoCell: UITableViewCell{
    
    @IBOutlet weak var info: UILabel!
    
}
