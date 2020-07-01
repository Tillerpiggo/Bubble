//
//  AppDelegate.swift
//  MagnetHomeworkApp
//
//  Created by Tyler Gee on 10/23/18.
//  Copyright © 2018 Beaglepig. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications
import Reachability

protocol NotificationDelegate {
    func fetchChanges(completion: @escaping (Bool) -> Void)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var cloudController = CloudController()
    lazy var coreDataController = { () -> CoreDataController in
        let coreDataStack = CoreDataStack(modelName: "MagnetHomeworkApp")
        let coreDataController = CoreDataController(coreDataStack: coreDataStack)
        return coreDataController
    }()
    
    lazy var dataController = {
        return DataController(coreDataController: coreDataController, cloudController: cloudController)
    }()
    
    var notificationDelegate: NotificationDelegate?
    
    var classTableViewControllerReference: ClassTableViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //UIApplication.shared.statusBarView?.backgroundColor = .primaryColor
        
        application.applicationIconBadgeNumber = 0
        
        /*
        if let tabBarController = window?.rootViewController as? UITabBarController,
            let navigationController = tabBarController.viewControllers?.first as? UINavigationController,
            let classTableViewController = navigationController.topViewController as? ClassTableViewController,
            let toDoNavigationController = tabBarController.viewControllers?.last as? UINavigationController,
            let toDoTableViewController = toDoNavigationController.topViewController as? ToDoTableViewController {
            
            toDoTableViewController.cloudController = cloudController
            toDoTableViewController.coreDataController = coreDataController
            
            // Dependency inject the CoreData/CloudKit Objects
            classTableViewController.cloudController = cloudController
            classTableViewController.coreDataController = coreDataController
            
            tabBarController.tabBar.tintColor = .primaryColor
//            tabBarController.tabBar.barTintColor = .tabBarTintColor
            //tabBarController.tabBar.addDropShadow(color: .black, opacity: 0.2, radius: 2)
            
            classTableViewControllerReference = classTableViewController
        }
        */
        
        if let plusButtonViewController = window?.rootViewController as? PlusButtonViewController {
            //addAssignmentViewController.cloudController = cloudController
            //addAssignmentViewController.coreDataController = coreDataController
            plusButtonViewController.dataController = dataController
        }
        
        if let classCollectionViewController = window?.rootViewController as? ClassCollectionViewController {
            //classCollectionViewController.cloudController = cloudController
            //classCollectionViewController.coreDataController = coreDataController
            classCollectionViewController.dataController = dataController
        }
        
        if let classViewController = window?.rootViewController as? ClassViewController {
            classViewController.`class` = Class(withName: "Test Class", color: Color.red, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID)
            //classViewController.coreDataController = coreDataController
            classViewController.dataController = dataController
        }
        
        /*
        coreDataController.fetchClasses { (classes) in
            if let classPickerViewController = self.window?.rootViewController as? TestClassPickerViewController {
                classPickerViewController.classes = classes
            }
        }
 */
        /*
        if let classPickerViewController = self.window?.rootViewController as? TestClassPickerViewController {
            classPickerViewController.classes = [
                Class(withName: "Test Class", color: Color.red, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID),
                Class(withName: "Very berry long", color: Color.pink, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID),
                Class(withName: "Coolio", color: Color.blue, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID),
                Class(withName: "Lime", color: Color.lime, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID),
                Class(withName: "B", color: Color.lightBlue, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID),
                Class(withName: "Purple", color: Color.purple, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID)
            ]
        }
        
        if let datePickerViewController = self.window?.rootViewController as? TestDatePickerViewController {
            datePickerViewController.dates = [
                DueDate(withDate: NSDate(timeIntervalSinceNow: 0 * 86400), managedContext: coreDataController.managedContext),
                DueDate(withDate: NSDate(timeIntervalSinceNow: 1 * 86400), managedContext: coreDataController.managedContext),
                DueDate(withDate: NSDate(timeIntervalSinceNow: 2 * 86400), managedContext: coreDataController.managedContext),
                DueDate(withDate: NSDate(timeIntervalSinceNow: 3 * 86400), managedContext: coreDataController.managedContext),
                DueDate(withDate: NSDate(timeIntervalSinceNow: 4 * 86400), managedContext: coreDataController.managedContext),
                DueDate(withDate: NSDate(timeIntervalSinceNow: 5 * 86400), managedContext: coreDataController.managedContext),
                DueDate(withDate: NSDate(timeIntervalSinceNow: 6 * 86400), managedContext: coreDataController.managedContext)
            ]
        }
 */
        
        if let controller = self.window?.rootViewController as? AssignmentCustomizationCollectionViewController {
            controller.classes = [
                Class(withName: "Test Class", color: Color.red, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID),
                Class(withName: "Very berry long", color: Color.pink, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID)
                //Class(withName: "Coolio", color: Color.blue, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID),
                //Class(withName: "Lime", color: Color.lime, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID),
                //Class(withName: "B", color: Color.lightBlue, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID),
                //Class(withName: "Purple", color: Color.purple, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID)
            ]
        }
        
        /*
        if let assignmentCollectionViewController = window?.rootViewController as? AssignmentCollectionViewController {
            
            
            let testClass = Class(withName: "Test Class", color: Color.red, managedContext: coreDataController.managedContext, zoneID: cloudController.zoneID)
            
            /*
            let assignments: [Assignment] = [
                Assignment(withText: "Do your damn HW", managedContext: coreDataController.managedContext, owningClass: testClass, zoneID: cloudController.zoneID, toDoZoneID: cloudController.zoneID),
                Assignment(withText: "Second thing", managedContext: coreDataController.managedContext, owningClass: testClass, zoneID: cloudController.zoneID, toDoZoneID: cloudController.zoneID),
                Assignment(withText: "Third!", managedContext: coreDataController.managedContext, owningClass: testClass, zoneID: cloudController.zoneID, toDoZoneID: cloudController.zoneID)
            ]
            
            for assignment in assignments {
                // Modify model
                testClass.addToAssignments(assignment)
                assignment.owningClass = testClass
                testClass.ckRecord["latestAssignment"] = assignment.text as CKRecordValue?
                testClass.dateLastModified = NSDate()
            }
 */
            
            assignmentCollectionViewController.class = testClass
            assignmentCollectionViewController.coreDataController = coreDataController
        }
 */
        
        // Try to register for notifications
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { authorized, error in
            if authorized {
                DispatchQueue.main.sync() { application.registerForRemoteNotifications() }
            }
        })
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping(UIBackgroundFetchResult) -> Void) {
        
        print("RECIEVED NOTIFICATION!")

        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        
        var didReceiveData: Bool = false
        
        if notification.subscriptionID == "cloudkit-privateClass-changes2" || notification.subscriptionID == "cloudkit-privateAssignment-changes2" || notification.subscriptionID == "cloudkit-sharedDatabase-changes" || notification.subscriptionID == "cloudkit-privateToDo-changes2" {
            notificationDelegate?.fetchChanges() { (didFetchChanges) in
                if !didReceiveData {
                    completionHandler(.noData)
                    didReceiveData = true
                }
            }
        }
        if !didReceiveData {
            completionHandler(.noData)
        }
    }
    
    // MARK: - CloudKit Sharing
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        cloudController.acceptShare(withShareMetadata: cloudKitShareMetadata) {
            self.notificationDelegate?.fetchChanges() { _ in
                // TODO: Send the user to tyhe approriate location (the new class)
                DispatchQueue.main.async {
                    if let navigationController = self.window?.rootViewController as? UINavigationController,
                        let classTableViewController = navigationController.topViewController as? ClassTableViewController {
                        // classTableViewController.openClass(withRecordID: cloudKitShareMetadata.rootRecordID)
                        print("Tried to open class (not currently implemented)")
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Did register for remote notifications with device token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Did fail to register for remote notifications with device token")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataController.save()
        
        // TODO: Save Cloud Stuff (persistent)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.notificationDelegate?.fetchChanges() { _ in }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataController.save()
        
        // TODO: Save Cloud Stuff (persistent)
    }
}

