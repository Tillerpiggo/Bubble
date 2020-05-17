//
//  AddAssignmentViewController.swift
//  Bubble
//
//  Created by Tyler Gee on 9/15/19.
//  Copyright © 2019 Beaglepig. All rights reserved.
//

import UIKit

protocol AddAssignmentViewControllerDelegate {
    func addedAssignment(_ assignment: Assignment)
}

class AddAssignmentViewController: UIViewController {
    
    var cloudController: CloudController!
    var coreDataController: CoreDataController!
    
    var addAssignmentViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint() // Placeholder value since inits are annoying. This must be set later
    
    private var addAssignmentViewHeight: CGFloat = 60
    var addAssignmentView = AddAssignmentView()
    
    var delegate: AddAssignmentViewControllerDelegate?
    
    override var canBecomeFirstResponder: Bool { return true }
    override var inputAccessoryView: UIView? {
        return addAssignmentView
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add views:
        view.addSubview(addAssignmentView)
        view.backgroundColor = .white
        
        addAssignmentView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        // Configure views:
        addAssignmentViewConstraints()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let addObjectViewController as AddObjectViewController:
            addObjectViewController.cloudController = cloudController
            addObjectViewController.coreDataController = coreDataController
        case let classCollectionViewController as ClassCollectionViewController:
            classCollectionViewController.cloudController = cloudController
            classCollectionViewController.coreDataController = coreDataController
        default:
            break
        }
    }
    
    
    private func addAssignmentViewConstraints() {
        // Add constraints
        
        // addAssignmentView will be fine on its own after setting frame and making it the inputAccessoryView
        addAssignmentView.translatesAutoresizingMaskIntoConstraints = false
        
        addAssignmentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        addAssignmentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        //addAssignmentViewHeightConstraint = NSLayoutConstraint(item: addAssignmentView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .height, multiplier: 1.0, constant: addAssignmentViewHeight)
        print("SAFE AREA INSETS: \(view.safeAreaInsets.bottom)")
        //addAssignmentView.addConstraint(addAssignmentViewHeightConstraint)
    }
    
    /*
    // MARK: - Keyboard Notifications
    
    @objc func keyboardWillShow(_ note: NSNotification) {
        // Change height constraint to normal level (no padding)
        addAssignmentViewHeightConstraint.constant = addAssignmentViewHeight
        
        print(note)
    }
    
    @objc func keyboardWillHide(_ note: NSNotification) {
        // Change height constraint to include padding (for iPhone X)
        addAssignmentViewHeightConstraint.constant = addAssignmentViewHeight + view.safeAreaInsets.bottom
    }
 */
    
    private func setVisuals() {
        // Add shadow to addAssignmentView
        
        
        // Add shadow
        let shadowLayer = CAShapeLayer()
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 20
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.frame = addAssignmentView.frame
        shadowLayer.path = UIBezierPath(roundedRect: addAssignmentView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 24, height: 24)).cgPath
        //shadowLayer.path = roundedTopMaskLayer.path
        
        view.layer.insertSublayer(shadowLayer, above: addAssignmentView.layer)
    }
}

extension AddAssignmentViewController: AddAssignmentViewDelegate {
    func doneButtonPressed(withText text: String) {
        // Implement in subview
        addAssignmentView.roundedExpandingTextView.textView.resignFirstResponder()
        
        // Add an assignment and transfer that to the next delegate:
        
        // Create the assignment
        //let newAssignment = Assignment(withText: text, managedContext: coreDataController.managedContext, owningClass: <#T##Class#>, zoneID: <#T##CKRecordZone.ID#>, toDoZoneID: <#T##CKRecordZone.ID#>)
        
        
        // Add it
        //delegate?.addedAssignment(<#T##assignment: Assignment##Assignment#>)
    }
}
