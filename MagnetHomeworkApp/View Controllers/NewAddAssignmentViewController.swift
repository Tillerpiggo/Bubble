//
//  AddAssignmentViewController.swift
//  Bubble
//
//  Created by Tyler Gee on 9/15/19.
//  Copyright © 2019 Beaglepig. All rights reserved.
//

import UIKit

/*
protocol AddAssignmentViewControllerDelegate {
    func addedAssignment(_ assignment: Assignment)
}

class AddAssignmentViewController: UIViewController {
    
    var delegate: AddAssignmentViewControllerDelegate?
    
    var cloudController: CloudController!
    var coreDataController: CoreDataController!
    
    var addAssignmentViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint() // Placeholder value since inits are annoying. This must be set later
    
    
    private var addAssignmentViewHeight: CGFloat = 60
    
    override var canBecomeFirstResponder: Bool { return true }
    override var inputAccessoryView: UIView? {
        print("inputAccessoryView: \(addAssignmentView)")
        return addAssignmentView
    }
    
    private lazy var addAssignmentButton: BouncyButton = {
        let addAssignmentButton = BouncyButton()
        addAssignmentButton.translatesAutoresizingMaskIntoConstraints = false
        addAssignmentButton.cornerRadius = 32
        addAssignmentButton.backgroundColor = .white
        addAssignmentButton.addDropShadow(color: .black, opacity: 0.15, radius: 20)
        addAssignmentButton.addTarget(self, action: #selector(addAssignmentButtonPressed), for: .touchUpInside)
        addAssignmentButton.setImage(to: UIImage(named: "addSymbol")!)
        
        return addAssignmentButton
    }()
    
    private var addAssignmentView: NewAddAssignmentView?
    //private var addAssignmentView: AddAssignmentView = AddAssignmentView()
    /*
    private lazy var addAssignmentView: AddAssignmentView = {
        return AddAssignmentView()
    }()
 */
    
    
    
    func initializeAddAssignmentView(completion: @escaping () -> Void) {
        coreDataController.fetchClasses { (classes) in
            let addAssignmentView = NewAddAssignmentView(classes: classes)
            addAssignmentView.translatesAutoresizingMaskIntoConstraints = false
            addAssignmentView.delegate = self
            
            self.addAssignmentView = addAssignmentView
            completion()
        }
    }
    
    /*
    private lazy var addAssignmentView: AddAssignmentView = {
        let addAssignmentView = AddAssignmentView()
        addAssignmentView.translatesAutoresizingMaskIntoConstraints = false
        addAssignmentView.delegate = self
        
        return addAssignmentView
    }()
 */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Add views:
        
        
        initializeAddAssignmentView { [unowned self] in
            self.view.addSubview(self.addAssignmentView!)
            self.view.addSubview(self.addAssignmentButton)
            
            
            self.addAssignmentButton.addConstraints(
                bottom: self.view.bottomAnchor, bottomConstant: 32,
                centerX: self.view.centerXAnchor,
                widthConstant: 64,
                heightConstant: 64)
            
            self.addAssignmentView!.addConstraints(
                bottom: self.view.bottomAnchor, bottomConstant: 0,
                leading: self.view.leadingAnchor, leadingConstant: 0,
                trailing: self.view.trailingAnchor, trailingConstant: 0)
            self.addAssignmentView!.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        }
        //view.addSubviews([addAssignmentView, addAssignmentButton])
        //addAssignmentViewConstraints()
        
//        self.addAssignmentButton.addConstraints(
//        bottom: self.view.bottomAnchor, bottomConstant: 32,
//        centerX: self.view.centerXAnchor,
//        widthConstant: 64,
//        heightConstant: 64)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        // Configure views:
        addAssignmentViewConstraints()
    }
 */
    
    
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
    
    @objc func addAssignmentButtonPressed() {
        guard let addAssignmentView = addAssignmentView else { return }
        addAssignmentView.display()
        //addAssignmentView.roundedExpandingTextView.select()
    }
    
    
    /*
    private func addAssignmentViewConstraints() {
        // Add constraints
        
        // addAssignmentView will be fine on its own after setting frame and making it the inputAccessoryView
        addAssignmentView.translatesAutoresizingMaskIntoConstraints = false
        
        addAssignmentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        addAssignmentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        addAssignmentViewHeightConstraint = NSLayoutConstraint(item: addAssignmentView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .height, multiplier: 1.0, constant: addAssignmentViewHeight)
        print("SAFE AREA INSETS: \(view.safeAreaInsets.bottom)")
        addAssignmentView.addConstraint(addAssignmentViewHeightConstraint)
    }
 */
    /*
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
    */
}


extension AddAssignmentViewController: AddAssignmentViewDelegate {
    func doneButtonPressed(withText text: String) {
        /*
        // Implement in subview
        addAssignmentView.roundedExpandingTextView.dismiss()
        
        // Add an assignment and transfer that to the next delegate:
        
        // Create the assignment
        //let newAssignment = Assignment(withText: text, managedContext: coreDataController.managedContext, owningClass: <#T##Class#>, zoneID: <#T##CKRecordZone.ID#>, toDoZoneID: <#T##CKRecordZone.ID#>)
        
        
        // Add it
        //delegate?.addedAssignment(<#T##assignment: Assignment##Assignment#>)
 */
    }
    
}
*/
