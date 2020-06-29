//
//  ClassViewController.swift
//  Bubble
//
//  Created by Tyler Gee on 6/19/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit
import CoreData

class ClassViewController: UIViewController {
    
    var `class`: Class!
    //var coreDataController: CoreDataController!
    var dataController: DataController!
    
    lazy var classView: ClassView = {
        let classView = ClassView(class: `class`, dataController: dataController)
        classView.translatesAutoresizingMaskIntoConstraints = false
        classView.addDropShadow(color: .black, opacity: 0.18, radius: 30)
        
        return classView
    }()
    
    override func viewDidLoad() {
        view.addSubview(classView)
        
        NSLayoutConstraint.activate([
            classView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            classView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            classView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            classView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
    }
}
