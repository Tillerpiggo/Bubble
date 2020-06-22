//
//  ClassPageViewController.swift
//  Bubble
//
//  Created by Tyler Gee on 6/19/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

// The page controller within ClassView; displays AssignmentTableViewControllers
class ClassPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    
    private lazy var assignmentTableViewController1: UITableViewController = {
        let assignmentTableViewController = UITableViewController()
        
        return assignmentTableViewController
    }()
    
    private lazy var assignmentTableViewController2: UITableViewController = {
        let assignmentTableViewController = UITableViewController()
        
        return assignmentTableViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        pages.append(assignmentTableViewController1)
        pages.append(assignmentTableViewController2)
        setViewControllers(pages, direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                // dead end
                return nil
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
            
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // dead end
                return nil
            }
        }
        return nil
    }
}
