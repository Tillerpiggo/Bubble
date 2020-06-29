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
    
    var delegate: AddAssignmentViewControllerDelegate?
    
    //var cloudController: CloudController!
    //var coreDataController: CoreDataController!
    var dataController: DataController!
    
    var addAssignmentViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint() // Placeholder value since inits are annoying. This must be set later
    
    
    private var addAssignmentViewHeight: CGFloat = 60
    private var keyboardIsShowing = false
    
    override var canBecomeFirstResponder: Bool { return true }
    override var inputAccessoryView: UIView? {
        print("inputAccessoryView: \(addAssignmentView)")
        if keyboardIsShowing {
            return addAssignmentView
        } else {
            return nil
        }
    }
    
    private lazy var plusButton: BouncyButton = {
        let plusButton = BouncyButton()
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.cornerRadius = 32
        plusButton.backgroundColor = .white
        plusButton.addDropShadow(color: .black, opacity: 0.15, radius: 20)
        plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        plusButton.setImage(to: UIImage(named: "addSymbol")!)
        
        return plusButton
    }()
    
    private var addAssignmentView: NewAddAssignmentView?

    private func initializeAddAssignmentView(with classes: [Class]) {
        let addAssignmentView = NewAddAssignmentView(classes: classes)
        addAssignmentView.translatesAutoresizingMaskIntoConstraints = false
        addAssignmentView.delegate = self
        
        self.addAssignmentView = addAssignmentView
        
    }
    
    /*
    private lazy var addAssignmentView: NewAddAssignmentView = {
        let addAssignmentView = NewAddAssignmentView()
        addAssignmentView.translatesAutoresizingMaskIntoConstraints = false
        
        return addAssignmentView
    }()
 */
    //private var addAssignmentView: AddAssignmentView = AddAssignmentView()
    /*
    private lazy var addAssignmentView: AddAssignmentView = {
        return AddAssignmentView()
    }()
 */
    
    /*
    func configureAddAssignmentView() {
        coreDataController.fetchClasses { (classes) in
            print("Classes: \(classes)")
            self.addAssignmentView.setClasses(to: classes)
            self.addAssignmentView.translatesAutoresizingMaskIntoConstraints = false
            self.addAssignmentView.delegate = self
        
            //self.addAssignmentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
            
            //self.view.addSubview(self.addAssignmentView)
            
            //self.view.layoutSubviews()
        }
    }
 */
    
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
        
        self.view.addSubview(self.plusButton)
            
        self.plusButton.addConstraints(
            bottom: self.view.bottomAnchor, bottomConstant: 32,
            centerX: self.view.centerXAnchor,
            widthConstant: 64,
            heightConstant: 64)
            
        dataController.getLocallyStoredClasses { [unowned self] (classes) in
            self.initializeAddAssignmentView(with: classes)
            
            self.view.addSubview(self.addAssignmentView!)
            
            self.addAssignmentView!.addConstraints(
                top: self.view.bottomAnchor, topConstant: 0,
                leading: self.view.leadingAnchor, leadingConstant: 0,
                trailing: self.view.trailingAnchor, trailingConstant: 0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
            /*
        case let addObjectViewController as AddObjectViewController:
            addObjectViewController.cloudController = cloudController
            addObjectViewController.coreDataController = coreDataController
 */
        case let classCollectionViewController as ClassCollectionViewController:
            //classCollectionViewController.cloudController = cloudController
            //classCollectionViewController.coreDataController = coreDataController
            classCollectionViewController.dataController = dataController
        default:
            break
        }
    }
    
    @objc func plusButtonPressed() {
        guard let addAssignmentView = addAssignmentView else { return }
        
        reloadInputViews()
        
        keyboardIsShowing = true
        
        addAssignmentView.display()
    }
}


extension AddAssignmentViewController: AddAssignmentViewDelegate {
    func addedAssignment(withText text: String, class owningClass: Class?, dueDate: DateModel) {
        // TODO - make it so that if the class is nil, it will automatically use the "All Homework" class
        guard let owningClass = owningClass else { return }
        
        let zoneID = owningClass.ckRecord.recordID.zoneID
        let newAssignment = Assignment(withText: text, owningClass: owningClass, dataController: dataController)
        delegate?.addedAssignment(newAssignment)
        
        
    }
    
}
