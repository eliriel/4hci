//
//  AppDelegate.swift
//  MedReminder
//
//  Created by Borislav Hristov on 26.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import UIKit
import CoreData
import MMDrawerController
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor(red: 0 / 255.0 , green: 153 / 255.0 , blue: 76 / 255.0 , alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            let managedContext = CoreDataManager.sharedInstance.managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName: "UserData", in:managedContext)
            let user = UserData(entity: entity!, insertInto: managedContext)
            MedReminder.getInstance().setUser(user)
            CoreDataManager.sharedInstance.saveContext()
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize()
        } else {
            MedReminder.getInstance().setUser(MedReminder.getInstance().searchSingle(UserData.self) as! UserData)
        }
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let left      = mainStoryboard.instantiateViewController(withIdentifier: "CreateReminderController") as! CreateReminderController
        let middle    = mainStoryboard.instantiateViewController(withIdentifier: "MainController") as! UITabBarController
        let right     = mainStoryboard.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
        
        
        let centerContainer = MMDrawerController(center: middle,
                                                  leftDrawerViewController: UINavigationController(rootViewController:left),
                                                  rightDrawerViewController: UINavigationController(rootViewController:  right))
        
        
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView;
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView;
        
        self.window?.rootViewController = centerContainer
        registerForPushNotifications()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        MedReminder.getInstance().getUser().token = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

