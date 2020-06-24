//
//  TestClassPickerView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/22/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class TestClassPickerViewController: UIViewController {
    
    var classes: [Class?]!
    
    private lazy var classPickerView: ClassPickerView = {
        let classPickerView = ClassPickerView(items: classes)
        classPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return classPickerView
    }()
    
    override func viewDidLoad() {
        view.addSubview(classPickerView)
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            classPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classPickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            classPickerView.widthAnchor.constraint(equalToConstant: view.bounds.width - 32)
        ])
        
        classPickerView.layoutIfNeeded()
    }
}

class TestDatePickerViewController: UIViewController {
    
    var dates: [DueDate?]!
    
    private lazy var datePickerView: DatePickerView = {
        let datePickerView = DatePickerView(items: dates)
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return datePickerView
    }()
    
    override func viewDidLoad() {
        view.addSubview(datePickerView)
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            datePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            datePickerView.widthAnchor.constraint(equalToConstant: view.bounds.width - 32)
        ])
        
        datePickerView.layoutIfNeeded()
    }
}
