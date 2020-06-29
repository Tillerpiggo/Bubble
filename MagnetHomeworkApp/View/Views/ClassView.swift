//
//  ClassView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/19/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

// TODO: - definitely create a ClassViewController to manage all of the data of the two AssignmentTableViewControllers

class ClassView: ProgrammaticView {
    
    var `class`: Class
    
    // TODO: - refactor this out; the view shouldn't have to know about this (maybe use a view model? idk I have to learn what that is)
    //var coreDataController: CoreDataController
    var dataController: DataController
    
    private var bubbleView: UIView = {
        let bubbleView = UIView()
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        // Round corners
        bubbleView.layer.cornerRadius = 30
        bubbleView.layer.masksToBounds = true
        bubbleView.backgroundColor = .white
        
        return bubbleView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        titleLabel.textColor = `class`.color.uiColor
        titleLabel.text = `class`.name
        
        return titleLabel
    }()
    
    private lazy var numberOfAssignmentsView: NumberView = {
        let numberOfAssignmentsView = NumberView()
        numberOfAssignmentsView.translatesAutoresizingMaskIntoConstraints = false
        numberOfAssignmentsView.setNumber(to: 0)
        numberOfAssignmentsView.setColor(to: `class`.color)
        
        return numberOfAssignmentsView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Doing", "Done"]
        let segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = `class`.color.uiColor
        segmentedControl.backgroundColor = `class`.color.uiColor.withAlphaComponent(0.4)
        segmentedControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .bold), .foregroundColor: UIColor.white], for: .normal)
        
        return segmentedControl
    }()
    
    private lazy var assignmentCollectionViewController: AssignmentCollectionViewController = {
        let assignmentCollectionViewController = AssignmentCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        assignmentCollectionViewController.dataController = dataController
        assignmentCollectionViewController.class = self.class
        assignmentCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return assignmentCollectionViewController
    }()
    
    /*
    private lazy var assignmentPageViewController: UIPageViewController = {
        let assignmentPageViewController = UIPageViewController()
        
        return assignmentPageViewController
    }()
 */
    
    
    
    private lazy var progressBar: ProgrammaticProgressBarView = {
        let progressBar = ProgrammaticProgressBarView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.color = `class`.color.uiColor
        
        return progressBar
    }()
    
    override func setupView() {
        // Do something
        addSubviews()
        addConstraints()
        
        progressBar.setProgress(to: 0.7, animated: true)
        
        UIView.animate(withDuration: 0.5, delay: 5.0, animations: {
            print("hello")
        })
    }
    
    @objc func segmentedControlChangedValue() {
        
    }
    
    init(`class`: Class, dataController: DataController) {
        self.`class` = `class`
        self.dataController = dataController
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension ClassView {
    func addSubviews() {
        self.addSubview(bubbleView)
        bubbleView.addSubviews([titleLabel, numberOfAssignmentsView, segmentedControl, progressBar, assignmentCollectionViewController.view])
    }
    
    func addConstraints() {
        self.pinEdgesToView(bubbleView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 40.0),
            titleLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: numberOfAssignmentsView.leadingAnchor, constant: -16.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 24.0),
            
            numberOfAssignmentsView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            numberOfAssignmentsView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16.0),
            numberOfAssignmentsView.widthAnchor.constraint(equalToConstant: 30.0),
            numberOfAssignmentsView.heightAnchor.constraint(equalToConstant: 30.0),
            
            segmentedControl.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            segmentedControl.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16.0),
            segmentedControl.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16.0),
            
            progressBar.heightAnchor.constraint(equalToConstant: 12.0),
            progressBar.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16.0),
            progressBar.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16.0),
            progressBar.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -16.0),
            
            assignmentCollectionViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            assignmentCollectionViewController.view.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -16),
            assignmentCollectionViewController.view.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
            assignmentCollectionViewController.view.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16)
        ])
    }
}
