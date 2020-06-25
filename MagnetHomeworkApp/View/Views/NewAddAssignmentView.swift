//
//  NewAddAssignmentView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/25/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class NewAddAssignmentView: ProgrammaticView {
    
    var delegate: AddAssignmentViewDelegate?
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        
        let roundedTopMaskLayer = CAShapeLayer()
        roundedTopMaskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 32, height: 32)).cgPath
        backgroundView.layer.mask = roundedTopMaskLayer
        backgroundView.backgroundColor = .white
        
        return backgroundView
    }()
    
    private lazy var assignmentView: AssignmentView = {
        let assignmentView = AssignmentView()
        assignmentView.translatesAutoresizingMaskIntoConstraints = false
        
        return assignmentView
    }()
    
    private lazy var addButton: BouncyButton = {
        let addButton = BouncyButton()
        addButton.cornerRadius = 16
        addButton.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        let title = NSAttributedString(string: "Add", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .heavy), .foregroundColor: UIColor(white: 0.3, alpha: 1.0)])
        addButton.setAttributedTitle(title, for: .normal)
        
        return addButton
    }()
    
    private lazy var assignmentCustomizationCollectionViewController: AssignmentCustomizationCollectionViewController = {
        let controller = AssignmentCustomizationCollectionViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    override func setupView() {
        addSubviews()
        addConstraints()
    }
}

// MARK: - Helper Methods
fileprivate extension NewAddAssignmentView {
    func addSubviews() {
        self.addSubviews([backgroundView, assignmentView])
        backgroundView.addSubviews([addButton, assignmentCustomizationCollectionViewController.view])
    }
    
    func addConstraints() {
        backgroundView.addConstraints(
            bottom: self.bottomAnchor, bottomConstant: 0,
            leading: self.leadingAnchor, leadingConstant: 0,
            trailing: self.trailingAnchor, trailingConstant: 0)
        
        assignmentView.addConstraints(
            top: self.topAnchor, topConstant: 20,
            bottom: backgroundView.topAnchor, bottomConstant: 20,
            leading: self.leadingAnchor, leadingConstant: 32,
            trailing: self.trailingAnchor, trailingConstant: 32)
        
        assignmentCustomizationCollectionViewController.view.addConstraints(
            top: backgroundView.topAnchor, topConstant: 16,
            leading: backgroundView.leadingAnchor, leadingConstant: 0,
            trailing: backgroundView.trailingAnchor, trailingConstant: 0)
        
        addButton.addConstraints(
            top: assignmentCustomizationCollectionViewController.view.bottomAnchor, topConstant: 16,
            bottom: backgroundView.bottomAnchor, bottomConstant: 16,
            centerX: backgroundView.centerXAnchor,
            widthConstant: 80,
            heightConstant: 50)
    }
}
