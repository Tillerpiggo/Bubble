//
//  ProgrammaticClassTableViewController.swift
//  Bubble
//
//  Created by Tyler Gee on 3/25/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

protocol ClassCollectionViewControllerDelegate {
    func classDeleted()
    var `class`: Class! { get set }
}

// MARK: - ClassCollectionViewController
// ClassTableViewController but it's programmatic and it's a collectionViewController.
class ClassCollectionViewController: UICollectionViewController {
    
    var cloudController: CloudController!
    var coreDataController: CoreDataController!
    let addClassCollectionViewCellIdentifier = "AddClassViewCell"
    
    private var addClassViewHeight: CGFloat = 128
    private let addClassViewHeightSmall: CGFloat = 128
    private let addClassViewHeightExpanded: CGFloat = 800
    
    private var blockOperation = BlockOperation()
    
    // Add Class View
    private var isAddClassViewExpanded = false
    private let addClassViewHeightShrunk: CGFloat = 86
    private let addClassViewHeightExpanded: CGFloat = UIScreen.main.bounds.height - 200
    
    
    // MARK: - Properties
    var delegate: ClassCollectionViewControllerDelegate?
    
    // This is where the magic happens - it is the source of the class data and where all the classes come from
    lazy var fetchedResultsController: NSFetchedResultsController<Class> = {
        let fetchRequest: NSFetchRequest<Class> = Class.fetchRequest()
        let sortByCreationDate = NSSortDescriptor(key: #keyPath(Class.creationDate), ascending: true)
        fetchRequest.sortDescriptors = [sortByCreationDate]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataController.managedContext,
            sectionNameKeyPath: nil,
            cacheName: "MagnetHomeworkApp"
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
        
        collectionView.register(AddClassCollectionViewCell.self, forCellWithReuseIdentifier: addClassCollectionViewCellIdentifier)
        collectionView.backgroundColor = .white
        
        updateWithCloud()
        
        /*
        // Allow for autosizing cells
        if let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
 */
        
        // Configure row height and visuals
        
        
        collectionView.reloadData() // Remove for optimization?
        collectionView.pinEdgesToView(view)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ClassCollectionViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Rest blockOperation
        blockOperation = BlockOperation()
    }
    
    // Change sections
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        let sectionIndexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            blockOperation.addExecutionBlock {
                self.collectionView.insertSections(sectionIndexSet)
            }
        case .delete:
            blockOperation.addExecutionBlock {
                self.collectionView.deleteSections(sectionIndexSet)
            }
        case .update:
            blockOperation.addExecutionBlock {
                self.collectionView.reloadSections(sectionIndexSet)
            }
        case .move:
            assertionFailure() // This shouldn't happen
            break
        }
    }
    
    // Change items
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        // Each time this is called, add the appropriate action to the blockOperation
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { break }
            
            blockOperation.addExecutionBlock {
                self.collectionView.insertItems(at: [newIndexPath])
            }
        case .delete:
            guard let indexPath = indexPath else { break }
            
            blockOperation.addExecutionBlock {
                self.collectionView?.deleteItems(at: [indexPath])
            }
        case .update:
            guard let indexPath = indexPath else { break }
            
            blockOperation.addExecutionBlock {
                self.collectionView?.reloadItems(at: [indexPath])
            }
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            
            blockOperation.addExecutionBlock {
                self.collectionView?.moveItem(at: indexPath, to: newIndexPath)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            self.blockOperation.start()
        }, completion: nil)
    }
}

// MARK: - Data source and delegate
extension ClassCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 // Temporary, use logic below afte addClassView is done
        
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections.count + 1 // +1 for the top section, the DueDateFilterView
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
        
        if section == 0 { return 1 }
        
        guard let sectionInfo = fetchedResultsController.sections?[section - 1] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: isAddClassViewExpanded ? addClassViewHeightExpanded : addClassViewHeightShrunk)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: Create Class cell programmatically, look up how to do this efficiently
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addClassCollectionViewCellIdentifier, for: indexPath) as! AddClassCollectionViewCell
        
        //cell.contentView.widthAnchor.constraint(equalToConstant: 600.0).isActive = true
        //cell.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        cell.addClassView.expandButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        cell.layoutIfNeeded()
        
        // TODO: Add an if statement to check that this is the addClassView (unless the other views happen to be dynamic)
        //cell.dynamicViewDelegate = self
        cell.delegate = self
        
        return cell
    }
    
    
    @objc func buttonPressed() {
        print("Button pressed; target added in collectionViewControlller")
        let addClassViewCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! AddClassCollectionViewCell
        addClassViewCell.expand()
        
        expandAddClassView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Change to check for section later
        if indexPath.row == fetchedResultsController.fetchedObjects?.count {
            if let cell = collectionView.cellForItem(at: indexPath) as? AddClassCollectionViewCell {
                cell.expand()
                print("Detected it through didSelectItemAt")
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout() // layout update
        }, completion: nil)
    }
    
    func expandAddClassView() {
        addClassViewHeight = addClassViewHeightExpanded
    }
    
    func shrinkAddClassView() {
        addClassViewHeight = addClassViewHeightSmall
    }
}

// MARK: - Notification Delegate

extension ClassCollectionViewController: NotificationDelegate {
    func fetchChanges(completion: @escaping (Bool) -> Void) {
        self.updateWithCloud { (didFetchRecords) in
            completion(didFetchRecords)
        }
    }
}

// MARK: - ProgrammaticAddClassViewDelegate
extension ClassCollectionViewController: ProgrammaticAddClassViewDelegate {
    
    func addClass(withText text: String) {
        // TODO: - actually add a class
    }
    
    func didExpand() {
        isAddClassViewExpanded = true
        //collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
        collectionView.performBatchUpdates({})
    }
    
    func didShrink() {
        isAddClassViewExpanded = false
        //collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
        collectionView.performBatchUpdates({})
    }
}

// TODO: - conform to AssignmentCollectionViewControllerDelegate

extension ClassCollectionViewController {
    
}

// TODO: - conform to ClassCollectionViewCellDelegate

// MARK: - Helper Methods



fileprivate extension ClassCollectionViewController {
    
    // MARK: Update with Cloud
    // This shouldn't really be entirely ClassCollectionViewController's responsibility
    func updateWithCloud(completion: @escaping (Bool) -> Void = { (didFetchRecords) in }) {
        var didFetchChanges: Bool = false
        
        // Delete zones
        let zonesDeleted: ([CKRecordZone.ID]) -> Void = { [unowned self] (zoneIDs) in
            self.deleteZones(withZoneIDs: zoneIDs, fetchedChanges: {
                didFetchChanges = true
            })
        }
        
        // MARK: - Save Changes
        // TODO: - Abstract this into a different class
        let saveChanges: ([CKRecord], [CKRecord.ID], DatabaseType) -> Void =
        { (recordsChanged, recordIDsDeleted, databaseType) in
            self.saveChanges(recordsChanged: recordsChanged, recordIDsDeleted: recordIDsDeleted, databaseType: databaseType, fetchedChanges:
            {
                didFetchChanges = true
            })
        }
        
        // Now hand it over to the cloudController
        
        cloudController.fetchDatabaseChanges(inDatabase: .private, zonesDeleted: zonesDeleted, saveChanges: saveChanges) {
            completion(didFetchChanges)
            
            self.cloudController.fetchDatabaseChanges(inDatabase: .shared, zonesDeleted: zonesDeleted, saveChanges: saveChanges) {
                completion(didFetchChanges)
            }
        }
    }
    
    func deleteZones(withZoneIDs zoneIDs: [CKRecordZone.ID], fetchedChanges: (() -> Void)) {
        if zoneIDs.count > 0 {
            fetchedChanges()
            
            guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else { return }
            
            // TODO: Implement this later (when you add zones), for now it will just delete everything
            for `class` in fetchedObjects {
                self.coreDataController.delete(`class`)
                
                guard let assignments = `class`.assignments?.array as? [Assignment] else { break }
                
                for assignment in assignments {
                    self.coreDataController.delete(assignment)
                }
            }
        }
    }
    
    func saveChanges(recordsChanged: [CKRecord], recordIDsDeleted: [CKRecord.ID], databaseType: DatabaseType, fetchedChanges: (() -> Void)) {
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error fetching classes: \(error)")
        }
        
        print("Number of records changed: \(recordsChanged.count)")
        print("Number of records deleted: \(recordIDsDeleted.count)")
        
        // TODO: Figure out wth this does
        let sortedRecordsChanged = recordsChanged.sorted(by:
        {
            // Turn CKRecord.RecordType (string) into my own custom RecordType enum
            guard let firstRecordType = RecordType(withCKRecordType: $0.recordType) else { return false }
            guard let secondRecordType = RecordType(withCKRecordType: $1.recordType) else { return false }
            
            // If priority is higher, return false
            if firstRecordType.priority == secondRecordType.priority {
                // Earlier creation date first
                return $0.creationDate! < $1.creationDate!
            } else {
                // Higher priority first
                return firstRecordType.priority < secondRecordType.priority
            }
        })
        
        for record in sortedRecordsChanged {
            addOrModify(record, databaseType: databaseType, fetchedChanges: fetchedChanges)
            
            // Save changes to core data
            DispatchQueue.main.sync { self.coreDataController.save() }
        }
        
        for recordID in recordIDsDeleted {
            delete(recordWithRecordID: recordID, fetchedChanges: fetchedChanges)
            
            // Maybe save? (I'm not sure)
        }
        
        // Save everything:
        
        DispatchQueue.main.sync {
            self.coreDataController.save()
            self.collectionView.reloadData()
        }
    }
    
    func addOrModify(_ record: CKRecord, databaseType: DatabaseType, fetchedChanges: (() -> Void)) {
        // If the record is being modified (the record is already on the phone). This will be a class since we're fetching classes.
        if let index = self.fetchedResultsController.fetchedObjects?.index(where: { $0.ckRecord.recordID == record.recordID })
        {
            fetchedChanges()
            
            // Modify the record
            self.fetchedResultsController.fetchedObjects?[index].update(withRecord: record)
            
            // Save changes to core data
            //DispatchQueue.main.async { self.coreDataController.save() }
        }
        
        // If a class is being added
        else if record.recordType == RecordType.class.string
        {
            fetchedChanges()
            
            // Create new class
            let newClass = Class(fromRecord: record, managedContext: self.coreDataController.managedContext)
            
            switch databaseType {
            case .private:
                newClass.isUserCreated = true
            case .shared:
                newClass.isUserCreated = false
            }
            
            newClass.isSynced = true // Just was received from the Cloud, so it is synced
            
            // Save changes to core data
            //DispatchQueue.main.async { self.coreDataController.save() }
        }
        
        // If an assignment is being added
        else if record.recordType == RecordType.assignment.string {
            fetchedChanges()
            
            // Search for the owning class of the record (and the assignments of that class)
            if let owningClass = self.fetchedResultsController.fetchedObjects?.first(where: { record["owningClass"] as? CKRecord.Reference == CKRecord.Reference(record: $0.ckRecord, action: .deleteSelf) }),
                let assignments = owningClass.assignmentArray
            {
                
                // Check if the assignment is already in the owningClass and find it if it is
                if let assignment = assignments.first(where: { $0.ckRecord.recordID == record.recordID }) {
                    assignment.update(withRecord: record)
                } else { // Assignment is completely new
                    let assignment = Assignment(fromRecord: record, owningClass: owningClass, managedContext: self.coreDataController.managedContext)
                    assignment.setIsSynced(to: true) // Just was received from the Cloud, so it is synced
                    
                    // Add it to the class
                    owningClass.addToAssignments(assignment)
                }
                
                owningClass.dateLastModified = NSDate()
            } else {
                print("ERR: Couldn't find owning class of assignment while applying changes.")
                print("Assignment: \(String(describing: record["text"] as? String))")
            }
            
            // Save changes to core data
            //DispatchQueue.main.sync { self.coreDataController.save() }
        } else if record.recordType == RecordType.toDo.string {
            fetchedChanges()
            
            // Find the owning class of the toDo, and then the owning assignment:
            if let owningClass = self.fetchedResultsController.fetchedObjects?.first(where: { record["classRecordName"] as? String == $0.ckRecord.recordID.recordName }),
                let assignments = owningClass.assignmentArray
            {
                if let owningAssignment = assignments.first(where: { $0.ckRecord.recordID.recordName == record["assignmentRecordName"] as? String })
                {
                    // Now find the toDo and modify it
                    if let toDo = owningAssignment.toDo {
                        toDo.update(withRecord: record)
                        owningAssignment.isCompleted = toDo.isCompleted
                    } else {
                        owningAssignment.toDo = ToDo(fromRecord: record, managedContext: self.coreDataController.managedContext)
                        owningAssignment.toDo?.isSynced = true
                    }
                } else {
                    print("ERR: Couldn't find the owning assignment (or the owning class) of a toDo... don't know where to place it.")
                }
            }
            
            // Save changes to core data
            //DispatchQueue.main.sync { self.coreDataController.save() }
        } else {
            print("CloudKit.Share received. Do nothing.")
        }
    }
    
    func delete(recordWithRecordID recordID: CKRecord.ID, fetchedChanges: (() -> Void)) {
        // If it's a class
        if let deletedClass = self.fetchedResultsController.fetchedObjects?.first(where: { $0.ckRecord.recordID == recordID })
        {
            fetchedChanges()
            
            // Delete it
            self.coreDataController.delete(deletedClass)
            
            // Delete all of the assignments (if there are any):
            guard let deletedAssignments = deletedClass.assignments?.array as? [Assignment] else { return }
            
            for assignment in deletedAssignments {
                self.coreDataController.delete(assignment)
            }
            
            // If it was the ClassCollectionViewController's current delegate (if a certain class is open), tell it, so that it can properly close (by animating it)
            if self.delegate?.class.ckRecord.recordID == recordID {
                DispatchQueue.main.sync { self.delegate?.classDeleted() }
            }
            
        }
        
            // If it's an assignment
        else {
            
            // Find it's owning class by looping thru all classes and all assignments
                // this isn't very efficient, so change this if I'm trying to optimize it
                // maybe add some filters on the assignments it filters through?
            for owningClass in self.fetchedResultsController.fetchedObjects ?? [] {
                guard let assignments = owningClass.assignments?.array as? [Assignment] else {  return }
                if let deletedAssignment = assignments.first(where: { $0.ckRecord.recordID == recordID }) {
                    fetchedChanges()
                    
                    // Delete from coreData
                    self.coreDataController.delete(deletedAssignment)
                    owningClass.removeFromAssignments(deletedAssignment)
                }
            }
        }
    }
    
    // MARK: - Other stuff
    func registerAsNotificationDelegate() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.notificationDelegate = self
        
        print("ClassCollectionViewController registered as the notification delegate")
    }
    
    func openClass(withRecordID recordID: CKRecord.ID) {
        if let openedClass = self.fetchedResultsController.fetchedObjects?.first(where: { $0.ckRecord.recordID == recordID }),
            let openedClassIndexPath = self.fetchedResultsController.indexPath(forObject: openedClass)
        {
            self.collectionView.selectItem(at: openedClassIndexPath, animated: true, scrollPosition: .top)
        }
    }
    
    // I don't think that this should be ClassCollectionViewController's responsibility
    func alertUserOfFailure() {
        let alertController = UIAlertController(title: "Something went wrong!", message: "Check your connection and make sure you have permissions to perform the desired action.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

/*
// MARK: - Dynamic View Delegate
extension ClassCollectionViewController: DynamicViewDelegate {
    func sizeChanged() {
        self.collectionView.performBatchUpdates({})
    }
}
 */

extension ClassCollectionViewController: ProgrammaticAddClassViewDelegate {
    func addClass(withText text: String) {
        // TODO: implement
    }
    
    func didShrink() {
        shrinkAddClassView()
        collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
        //collectionView.performBatchUpdates({})
    }
    
    func didExpand() {
        expandAddClassView()
        //collectionView.performBatchUpdates({})
        collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
    }
}
