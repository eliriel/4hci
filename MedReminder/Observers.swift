//
//  Observers.swift
//  MedReminder
//
//  Created by Borislav Hristov on 29.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation


protocol MainObserver {
    func updateList()
    func prepareReminders()
}
