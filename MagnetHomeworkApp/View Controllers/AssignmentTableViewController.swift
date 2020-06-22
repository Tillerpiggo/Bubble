//
//  AssignmentTableViewController.swift
//  Bubble
//
//  Created by Tyler Gee on 6/19/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class AssignmentTableViewController: UITableViewController {
    
    var `class`: Class!
    var coreDataController: CoreDataController!
    
    private lazy var predicate: NSPredicate = {
        return NSPredicate(format: "owningClass == %@", self.class)
    }()
    
    private let sectionNameKeyPath = #keyPath(Assignment.dueDateString)
    
    private lazy var sortDescriptors: [NSSortDescriptor] = {
        let sortBySectionNumber = NSSortDescriptor(key: #keyPath(Assignment.dueDateSection), ascending: true)
        let sortByDueDate = NSSortDescriptor(key: #keyPath(Assignment.dueDate.date), ascending: true)
        let sortByCreationDate = NSSortDescriptor(key: #keyPath(Assignment.creationDate), ascending: true)
        let sortByCompletionDate = NSSortDescriptor(key: #keyPath(Assignment.toDo.completionDate), ascending: false)
        
        return [sortBySectionNumber, sortByCompletionDate, sortByDueDate, sortByCreationDate]
    }()
    
    private func cacheName() -> String? {
        return self.class.ckRecord.recordID.recordName
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Assignment> = {
        let fetchRequest: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        
        let isInClassPredicate = predicate
        fetchRequest.predicate = isInClassPredicate
        
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
    
}

extension AssignmentTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .top)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            
            /* TODO: add when ProgrammaticAssignmentTableViewCell created
            guard let cell = tableView.cellForRow(at: indexPath!) as? ProgrammaticAssignmentTableViewCell else {
                print("Cell in AssignmentTableViewControler not found")
            }
            cell.configure(withAssignment: cell.assignment!)
 */
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections([sectionIndex], with: .fade)
        case .insert:
            self.tableView.insertSections([sectionIndex], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
