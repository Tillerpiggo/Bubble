//
//  TabBarController.swift
//  MagnetHomeworkApp
//
//  Created by Tyler Gee on 1/6/19.
//  Copyright © 2019 Beaglepig. All rights reserved.
//

import UIKit

class AddAssignmentTabBarController: UITabBarController {
    
    var cloudController: CloudController!
    var coreDataController: CoreDataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load addAssignmentView from nib
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) {
        if let viewController = viewController as? ToDoTableViewController {
            viewController.cloudController = cloudController
            viewController.coreDataController = coreDataController
        }
    }
    
}
