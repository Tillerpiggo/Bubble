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
    
    override var intrinsicContentSize: CGSize {
        //preferred content size, calculate it if some internal state changes
        return CGSize(width: 100, height: 200)
    }
    
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        backgroundView.addDropShadow(color: .black, opacity: 0.15, radius: 40)
        
        return backgroundView
    }()
    
    private lazy var assignmentView: AssignmentView = {
        let assignmentView = AssignmentView()
        assignmentView.translatesAutoresizingMaskIntoConstraints = false
        
        return assignmentView
    }()
    
    
    private lazy var addButton: BouncyButton = {
        let addButton = BouncyButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.cornerRadius = 16
        addButton.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        let title = NSAttributedString(string: "Add", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .heavy), .foregroundColor: UIColor(white: 0.3, alpha: 1.0)])
        addButton.setAttributedTitle(title, for: .normal)
        
        return addButton
    }()
    
    var assignmentCustomizationCollectionViewController: AssignmentCustomizationCollectionViewController?
    
    func setClasses(to classes: [Class]) {
        initializeAssignmentCustomizationCollectionViewController(with: classes)
        
        backgroundView.addSubview(assignmentCustomizationCollectionViewController!.view)
        
        assignmentCustomizationCollectionViewController!.view.addConstraints(
            top: backgroundView.topAnchor, topConstant: 16,
            bottom: addButton.topAnchor, bottomConstant: 16,
            leading: backgroundView.leadingAnchor, leadingConstant: 0,
            trailing: backgroundView.trailingAnchor, trailingConstant: 0,
            heightConstant: 300)
        
        let roundedTopMaskLayer = CAShapeLayer()
        roundedTopMaskLayer.path = UIBezierPath(roundedRect: backgroundView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 24, height: 24)).cgPath
        backgroundView.layer.mask = roundedTopMaskLayer
        backgroundView.backgroundColor = .white
    }
    
    private func initializeAssignmentCustomizationCollectionViewController(with classes: [Class]) {
        let controller = AssignmentCustomizationCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), classes: classes)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        assignmentCustomizationCollectionViewController = controller
    }
    
    override func setupView() {
        addSubviews()
        addConstraints()
    }
    
    func display() {
        assignmentView.select()
    }
}

// MARK: - Helper Methods
fileprivate extension NewAddAssignmentView {
    func addSubviews() {
        
        self.addSubviews([backgroundView, assignmentView])
        backgroundView.addSubviews([addButton])
    }
    
    func addConstraints() {
        
        backgroundView.addConstraints(
            top: assignmentView.bottomAnchor, topConstant: 20,
            bottom: self.bottomAnchor, bottomConstant: 0,
            leading: self.leadingAnchor, leadingConstant: 0,
            trailing: self.trailingAnchor, trailingConstant: 0)
        
        assignmentView.addConstraints(
            top: self.topAnchor, topConstant: 20,
            bottom: backgroundView.topAnchor, bottomConstant: 20,
            leading: self.leadingAnchor, leadingConstant: 32,
            trailing: self.trailingAnchor, trailingConstant: 32,
            heightConstant: 36)
        
        addButton.addConstraints(
            bottom: backgroundView.bottomAnchor, bottomConstant: 16,
            centerX: backgroundView.centerXAnchor,
            widthConstant: 80,
            heightConstant: 50)
        
        backgroundView.backgroundColor = .white
    }
}
