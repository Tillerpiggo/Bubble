//
//  AddAssignmentViewController.swift
//  Bubble
//
//  Created by Tyler Gee on 9/15/19.
//  Copyright © 2019 Beaglepig. All rights reserved.
//


import UIKit

class AddAssignmentViewController: UIViewController {
    
    var delegate: AddAssignmentViewDelegate?
    
    private lazy var addAssignmentView: AddAssignmentView = {
        let addAssignmentView = AddAssignmentView()
        addAssignmentView.translatesAutoresizingMaskIntoConstraints = false
        
        addAssignmentView.delegate = self
        
        return addAssignmentView
    }()
    
    override func viewDidLoad() {
        view.addSubview(addAssignmentView)
        addAssignmentView.pinEdgesToView(view)
    }
}

extension AddAssignmentViewController: AddAssignmentViewDelegate {
    func addedAssignment(withText text: String, class: Class?, dueDate: DateModel) {
        delegate?.addedAssignment(withText: text, class: `class`, dueDate: dueDate)
    }
}
