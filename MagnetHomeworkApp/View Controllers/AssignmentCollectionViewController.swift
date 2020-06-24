//
//  AssignmentCollectionViewController.swift
//  Bubble
//
//  Created by Tyler Gee on 6/20/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit
import CoreData

// Ignore warning; dunno how to get rid of it, pressing "Fix" doesn't work, and adding @objc in front of the functions doesn't work. The actual protocol does work tho.
class AssignmentCollectionViewController: UICollectionViewController, CollectionFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    var coreDataController: CoreDataController!
    var `class`: Class!
    
    private var assignmentCollectionViewCellIdentifier = "AssignmentCell"
    
    internal var blockOperation = BlockOperation()
    
    private var sectionNameKeyPath: String = #keyPath(Assignment.dueDateString)
    
    private var sortDescriptors: [NSSortDescriptor] = {
        let sortBySectionNumber = NSSortDescriptor(key: #keyPath(Assignment.dueDateSection), ascending: true)
        let sortByDueDate = NSSortDescriptor(key: #keyPath(Assignment.dueDate.date), ascending: true)
        let sortByCreationDate = NSSortDescriptor(key: #keyPath(Assignment.creationDate), ascending: true)
        let sortByCompletionDate = NSSortDescriptor(key: #keyPath(Assignment.toDo.completionDate), ascending: false)
        
        return [sortBySectionNumber, sortByCompletionDate, sortByDueDate, sortByCreationDate]
    }()
    
    private func predicate() -> NSPredicate {
        return NSPredicate(format: "owningClass == %@", self.class)
    }
    
    private func cacheName() -> String? {
        return `class`.ckRecord.recordID.recordName
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Assignment> = {
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Bubble2")
        
        let fetchRequest: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        let sortByCreationDate = NSSortDescriptor(key: #keyPath(Class.creationDate), ascending: true)
        fetchRequest.sortDescriptors = [sortByCreationDate]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataController.managedContext,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName()
        )
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        
        return fetchedResultsController
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(AssignmentCollectionViewCell.self, forCellWithReuseIdentifier: assignmentCollectionViewCellIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pinEdgesToView(view)
        
        /*
        // Allow for autosizing cells
        if let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = CGSize(width: collectionView.bounds.width, height: 36)
        }
 */
    }
    
    
    override func viewDidLayoutSubviews() {
        // Allow for autosizing cells
        if let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = CGSize(width: collectionView.bounds.width, height: 36)
        }
        
        //collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Data Source and Delegate
extension AssignmentCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: assignmentCollectionViewCellIdentifier, for: indexPath) as! AssignmentCollectionViewCell
        
        if let sectionInfo = fetchedResultsController.sections?[indexPath.section], let assignments = sectionInfo.objects as? [Assignment] {
            cell.configure(withAssignment: assignments[indexPath.row])
        }
        
        return cell
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let section = fetchedResultsController.sections?[indexPath.section] else {
            if let assignments = section.objects as? [Assignment] {
                let assignment = assignments[indexPath.row]
                
                
            }
        }
        
        
    }
 */
}
