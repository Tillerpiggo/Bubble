//
//  NewAddAssignmentView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/25/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

protocol AddAssignmentViewDelegate {
    func addedAssignment(withText text: String, class: Class?, dueDate: DateModel)
}

class NewAddAssignmentView: ProgrammaticView {
    
    var delegate: AddAssignmentViewDelegate?
    var presentationDelegate: PresentationDelegate?
    var classes: [Class]
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        backgroundView.addDropShadow(color: .black, opacity: 0.15, radius: 40)
        
        return backgroundView
    }()
    
    private lazy var assignmentView: NewAssignmentView = {
        let assignmentView = NewAssignmentView()
        assignmentView.translatesAutoresizingMaskIntoConstraints = false
        
        return assignmentView
    }()
    
    private lazy var addButton: BouncyButton = {
        let addButton = BouncyButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.cornerRadius = 16
        addButton.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        let title = NSAttributedString(string: "Add", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .heavy), .foregroundColor: UIColor(white: 0.2, alpha: 1.0)])
        addButton.setAttributedTitle(title, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        return addButton
    }()
    
    //var assignmentCustomizationCollectionViewController: AssignmentCustomizationCollectionViewController?
    
    /*
    func setClasses(to classes: [Class]) {
        initializeAssignmentCustomizationCollectionViewController(with: classes)
    }
 */
    
    /*
    private func initializeAssignmentCustomizationCollectionViewController(with classes: [Class]) {
        let controller = AssignmentCustomizationCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), classes: classes)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        assignmentCustomizationCollectionViewController = controller
    }
 */
    
    private lazy var assignmentCustomizationCollectionViewController: AssignmentCustomizationCollectionViewController = {
        let controller = AssignmentCustomizationCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), classes: classes)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        //controller.delegate = self
        
        return controller
    }()
    
    override func setupView() {
        addSubviews()
        addConstraints()
        
        backgroundView.backgroundColor = .white
        
        let roundedTopMaskLayer = CAShapeLayer()
        roundedTopMaskLayer.path = UIBezierPath(roundedRect: backgroundView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 24, height: 24)).cgPath
        //backgroundView.layer.mask = roundedTopMaskLayer
        backgroundView.backgroundColor = .white
    }
    
    func display() {
        assignmentView.select()
    }
    
    func reset() {
        assignmentView.reset()
        assignmentCustomizationCollectionViewController.reset()
    }
    
    @objc func addButtonPressed() {
        guard let owningClass = assignmentCustomizationCollectionViewController.selectedItems[0] as? Class else { return }
        guard let dueDate = assignmentCustomizationCollectionViewController.selectedItems[1] as? DateModel else { return }
        
        delegate?.addedAssignment(withText: assignmentView.text, class: owningClass, dueDate: dueDate)
    }
    
    init(classes: [Class]) {
        self.classes = classes
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
extension NewAddAssignmentView: PresentationDelegate {
    func present(_ viewController: UIViewController) {
        presentationDelegate?.present(viewController)
    }
}
 */

// MARK: - Helper Methods
fileprivate extension NewAddAssignmentView {
    func addSubviews() {
        self.addSubviews([backgroundView, assignmentView])
        backgroundView.addSubviews([addButton, assignmentCustomizationCollectionViewController.view])
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
        
        assignmentCustomizationCollectionViewController.view.addConstraints(
            top: backgroundView.topAnchor, topConstant: 0,
            bottom: addButton.topAnchor, bottomConstant: 0,
            leading: backgroundView.leadingAnchor, leadingConstant: 0,
            trailing: backgroundView.trailingAnchor, trailingConstant: 0)
    }
}
