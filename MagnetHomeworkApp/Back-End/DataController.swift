//
//  DataController.swift
//  Bubble
//
//  Created by Tyler Gee on 6/28/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class DataController {
    
    var managedContext: NSManagedObjectContext {
        return coreDataController.managedContext
    }
    
    var zoneID: CKRecordZone.ID {
        return cloudController.zoneID
    }
    
    // Interface
    func add(_ object: Any) {
        switch object {
        case let assignment as Assignment:
            addAssignment(assignment)
        case let `class` as Class:
            addClass(`class`)
        default: break
        }
    }
    
    func save(_ object: Any) {
        switch object {
        case let assignment as Assignment:
            saveAssignment(assignment)
        case let `class` as Class:
            saveClass(`class`)
        case let toDo as ToDo:
            saveToDo(toDo)
        default: break
        }
        
    }
    
    func delete(_ object: Any) {
        switch object {
        case let assignment as Assignment:
            deleteAssignment(assignment)
        case let `class` as Class:
            deleteClass(`class`)
        default: break
        }
    }
    
    func getLocallyStoredClasses(completion: @escaping ([Class]) -> Void) {
        coreDataController.fetchClasses { (classes) in
            completion(classes)
        }
    }
    
    // Pull stuff from the cloud
    func syncWithCloud(completion: @escaping (Bool) -> Void = { (didFetchRecords) in }) {
        var didFetchChanges = false
        
        // Delete zones
        let zonesDeleted: ([CKRecordZone.ID]) -> Void = { [unowned self] (zoneIDs) in
            self.deleteZones(withZoneIDs: zoneIDs, fetchedChanges: {
                didFetchChanges = true
            })
        }
        
        // Define what should be done with the fetched changes
        let saveChanges: ([CKRecord], [CKRecord.ID], DatabaseType) -> Void =
        { [unowned self] (recordsChanged, recordIDsDeleted, databaseType) in
            self.saveChanges(recordsChanged: recordsChanged, recordIDsDeleted: recordIDsDeleted, databaseType: databaseType, fetchedChanges: {
                didFetchChanges = true
            })
        }
        
        // Fetch all changes with the Cloud Controller, first in prviate, then in shared databases
        cloudController.fetchDatabaseChanges(inDatabase: .private, zonesDeleted: zonesDeleted, saveChanges: saveChanges)
        {
            //completion(didFetchChanges) // TODO - figure out if this should be a thing
            
            self.cloudController.fetchDatabaseChanges(inDatabase: .shared, zonesDeleted: zonesDeleted, saveChanges: saveChanges)
            {
                completion(didFetchChanges)
            }
        }
    }
    
    
    fileprivate var coreDataController: CoreDataController
    fileprivate var cloudController: CloudController
    
    init(coreDataController: CoreDataController, cloudController: CloudController) {
        self.coreDataController = coreDataController
        self.cloudController = cloudController
    }
}

// Actual logic - you'll probably want to use the minimap to find stuff here
// We got addAssignment, addClass, saveAssignment, saveClass, saveToDo, deleteClass, and deleteAssignment
fileprivate extension DataController {
    func addAssignment(_ assignment: Assignment) {
        guard let owningClass = assignment.owningClass else {
            fatalError("Assignment did not have an owning class.")
        }
        
        // Modify the owning class to add the assignment
        owningClass.addToAssignments(assignment)
        owningClass.ckRecord["latestAssignment"] = assignment.text as CKRecordValue?
        owningClass.dateLastModified = NSDate()
        owningClass.isSynced = false
        
        // Save the assignment to Core Data (it was already initialized in the proper core data context)
        coreDataController.save()
        
        // Save the assignment to iCloud
        if owningClass.isUserCreated {
            
            // Create a mutable array of CloudUploadables (so that isSynced can be modified by cloudController.save)
            var cloudUploadables: [CloudUploadable] = [assignment, assignment.toDo!, owningClass]
            
            cloudController.save(&cloudUploadables, inDatabase: .private, recordChanged:
            { [unowned self] (updatedRecord) in
                self.updateAssignment(assignment, with: updatedRecord)
            }) { [unowned self] (error) in
                self.handleError(error)
            }
            
        // Shared database - add the assignment to be shared, but the toDo should stay private
        } else {
            // See above cloudUploadables for why this is necessary
            var privateCloudUploadables: [CloudUploadable] = [assignment.toDo!]
            
            cloudController.save(&privateCloudUploadables, inDatabase: .private, recordChanged:
            { (updatedRecord) in
                assignment.toDo?.update(withRecord: updatedRecord)
            }) { [unowned self] (error) in
                guard let error = error as? CKError else { return }
                self.handleError(error)
            }
            
            var sharedCloudUploadables: [CloudUploadable] = [assignment, owningClass]
            
            cloudController.save(&sharedCloudUploadables, inDatabase: .shared, recordChanged:
            { [unowned self] (updatedRecord) in
                self.updateAssignment(assignment, with: updatedRecord)
            }) { [unowned self] (error) in
                self.handleError(error)
            }
        }
        
        var sharedCloudUploadables: [CloudUploadable] = [assignment, owningClass]
        
        cloudController.save(&sharedCloudUploadables, inDatabase: .shared, recordChanged:
        { [unowned self] (updatedRecord) in
            self.updateAssignment(assignment, with: updatedRecord)
        })
    }
    
    func addClass(_ class: Class) {
        // Save to Core Data
        coreDataController.save()
        
        // Save to iCloud
        var cloudUploadables: [CloudUploadable] = [`class`] // So cloudController can modify isSynced
        `class`.isSynced = false
        
        cloudController.save(&cloudUploadables, inDatabase: .private, recordChanged:
            { (updatedRecord) in
                `class`.update(withRecord: updatedRecord)
        }) { [unowned self] (error) in
            self.handleError(error)
        }
    }
    
    func saveAssignment(_ assignment: Assignment) {
        // Save to Core Data
        self.coreDataController.save()
        
        // Save to iCloud
        let databaseType: DatabaseType = assignment.owningClass?.isUserCreated ?? true ? .private : .shared
        
        var cloudUploadables: [CloudUploadable] = [assignment]
        
        cloudController.save(&cloudUploadables, inDatabase: databaseType, recordChanged:
        { (updatedRecord) in
            assignment.update(withRecord: updatedRecord)
        }) { [unowned self] (error) in
            self.handleError(error)
        }
    }
    
    func saveClass(_ class: Class) {
        // implement later
    }
    
    func saveToDo(_ toDo: ToDo) {
        toDo.assignment?.setIsSynced(to: false)
        toDo.isSynced = false
        
        toDo.completionDate = NSDate()
        toDo.ckRecord["isCompleted"] = toDo.isCompleted as CKRecordValue?
        
        // Save to Core Date
        coreDataController.save()
        
        // Save to iCloud
        var cloudUploadables: [CloudUploadable] = [toDo]
        
        cloudController.save(&cloudUploadables, inDatabase: .private, recordChanged:
        { (updatedRecord) in
            toDo.update(withRecord: updatedRecord)
            toDo.assignment?.setIsSynced(to: true)
        }) { [unowned self] (error) in
            self.handleError(error)
        }
    }
    
    func deleteClass(_ class: Class) {
        // Delete from Core Data
        self.coreDataController.delete(`class`)
        
        // Delete all of the assignments from the Cloud
        if let assignments = `class`.assignments?.array as? [Assignment] {
            for assignment in assignments {
                self.coreDataController.delete(assignment)
            }
        }
        
        self.coreDataController.save()
        
        // Finally, delete the actual class from the Cloud
        cloudController.delete([`class`], inDatabase: .private) {
            print("Successfully deleted Class from the Cloud using DataController")
        }
        
    }
    
    func deleteAssignment(_ assignment: Assignment) {
        // Delete from core data
        self.coreDataController.delete(assignment)
        self.coreDataController.save()
        
        // Delete from cloud
        let databaseType: DatabaseType = assignment.owningClass!.isUserCreated ? .private : .shared
        self.cloudController.delete([assignment], inDatabase: databaseType) {
            print("Successfully deleted Assignment from the Cloud using DataController")
        }
    }
}


// MARK - Helper helpers
fileprivate extension DataController {
    func updateAssignment(_ assignment: Assignment, with updatedRecord: CKRecord) {
        if updatedRecord.recordType == "Assignment" {
            assignment.update(withRecord: updatedRecord)
        } else if updatedRecord.recordType == "ToDo" {
            assignment.toDo?.update(withRecord: updatedRecord)
        } else {
            assignment.owningClass?.update(withRecord: updatedRecord)
        }
    }
    
    func handleError(_ error: Error?) {
        guard let error = error as? CKError else { return }
        
        switch error.code {
        case .requestRateLimited, .zoneBusy, .serviceUnavailable:
            break
        default:
            DispatchQueue.main.async {
                self.coreDataController.save()
            }
        }
    }
}

// MARK - updateWithCloud helpers
fileprivate extension DataController {
    func deleteZones(withZoneIDs zoneIDs: [CKRecordZone.ID], fetchedChanges: @escaping (() -> Void)) {
        if zoneIDs.count > 0 {
            fetchedChanges()
            
            // Delete everything locally stored in a class (change when/if separate zones are implemented)
            getLocallyStoredClasses { [unowned self] (classes) in
                for `class` in classes {
                    self.coreDataController.delete(`class`)
                    
                    guard let assignments = `class`.assignments?.array as? [Assignment] else { break }
                    
                    for assignment in assignments {
                        self.coreDataController.delete(assignment)
                    }
                }
            }
        }
    }
    
    func saveChanges(recordsChanged: [CKRecord], recordIDsDeleted: [CKRecord.ID], databaseType: DatabaseType, fetchedChanges: @escaping (() -> Void))
    {
        // Sort the records so that classes > assignments > toDo so that items can be properly added to their parents
        let sortedRecordsChanged = recordsChanged.sorted(by:
        {
            guard let firstRecordType = RecordType(withCKRecordType: $0.recordType) else {
                fatalError("ERROR: Something went wrong while syncing with iCloud. Couldn't determine the type of a record in iCloud in saveChanges in DataController")
                //return false
            }
            guard let secondRecordType = RecordType(withCKRecordType: $1.recordType) else {
                fatalError("ERROR: Something went wrong while syncing with iCloud. Couldn't determine the type of a record in iCloud in saveChanges in DataController")
                //return false
            }
            
            // This sorts by classes > assignments > toDo (unless I change it)
            if firstRecordType.priority == secondRecordType.priority {
                // Earlier creation date first
                return $0.creationDate! < $1.creationDate!
            } else {
                return firstRecordType.priority < secondRecordType.priority
            }
        })
        
        
        getLocallyStoredClasses { [unowned self] (classes) in
            // Add/modify existing records with the incoming ones
            for record in sortedRecordsChanged {
                self.sync(record, databaseType: databaseType, classes: classes, fetchedChanges: fetchedChanges)
            }
        
            // Delete records
            for recordID in recordIDsDeleted {
                self.delete(recordWithRecordID: recordID, classes: classes, fetchedChanges: fetchedChanges)
            }
        }
        
        // Actually save the changes
        DispatchQueue.main.async { [unowned self] in
            self.coreDataController.save()
        }
    }
    
    func sync(_ record: CKRecord, databaseType: DatabaseType, classes: [Class], fetchedChanges: @escaping (() -> Void)) {
        // Ideally optimize this, it's hella slow
        
        // Search for the record.
        
        
        switch record.recordType {
        case RecordType.class.string:
            fetchedChanges()
            
            if let index = classes.index(where: { $0.ckRecord.recordID == record.recordID }) {
                classes[index].update(withRecord: record)
            } else {
                // Create a new class:
                let newClass = Class(fromRecord: record, managedContext: managedContext)
                
                switch databaseType {
                case .private:
                    newClass.isUserCreated = true
                case .shared:
                    newClass.isUserCreated = false
                }
                
                newClass.isSynced = true
            }
            
        case RecordType.assignment.string:
            fetchedChanges()
            
            if let owningClass = classes.first(where: { record["owningClass"] as? CKRecord.Reference == CKRecord.Reference(record: $0.ckRecord, action: .deleteSelf) }),
                let assignments = owningClass.assignmentArray
            {
                if let assignment = assignments.first(where: { $0.ckRecord.recordID == record.recordID }) {
                    assignment.update(withRecord: record)
                } else {
                    // Create a new assignment
                    let assignment = Assignment(fromRecord: record, owningClass: owningClass, managedContext: managedContext)
                    assignment.setIsSynced(to: true)
                    
                    owningClass.addToAssignments(assignment)
                }
                
                owningClass.dateLastModified = NSDate()
            } else {
                print("ERR: Couldn't find owning class of assignment while syncing with the cloud.")
                print("Assignment: \(String(describing: record["text"] as? String))")
            }
        
        case RecordType.toDo.string:
            fetchedChanges()
            
            // First search to find the owning class, then the owning assignment:
            if let owningClass = classes.first(where: { record["classRecordName"] as? String == $0.ckRecord.recordID.recordName }),
                let assignments = owningClass.assignmentArray
            {
                if let owningAssignment = assignments.first(where: { $0.ckRecord.recordID.recordName == record["assignmentRecordName"] as? String })
                {
                    // TODO - maybe rethink this, since the assignment should always have a todo. Maybe no check is necessary, and the efficiency can therefore be improved.
                    if let toDo = owningAssignment.toDo {
                        toDo.update(withRecord: record)
                        owningAssignment.isCompleted = toDo.isCompleted
                    } else {
                        owningAssignment.toDo = ToDo(fromRecord: record, managedContext: managedContext)
                        owningAssignment.toDo?.isSynced = true
                    }
                }
            } else {
                print("ERR: Couldn't find the owning assignment (or the owning class) of a toDo... don't know where to store the incoming toDo.")
                print("ToDo record: \(record)")
            }
        default: break
        }
    }
    
    func delete(recordWithRecordID recordID: CKRecord.ID, classes: [Class], fetchedChanges: @escaping (() -> Void)) {
        // TODO - make this more efficient
        if let deletedClass = classes.first(where: {
            $0.ckRecord.recordID == recordID })
        {
            fetchedChanges()
            
            
            
            // Delete all of the class's assignments
            if let deletedAssignments = deletedClass.assignments?.array as? [Assignment] {
                for assignment in deletedAssignments {
                    coreDataController.delete(assignment)
                }
            }
            
            // Delete the class
            self.coreDataController.delete(deletedClass)
            
            // TODO - add delegate signal that the class has been deleted so that it can be animated away if you're in it
        }
            
        // It's an assignment
        else {
            for owningClass in classes {
                if let assignments = owningClass.assignments?.array as? [Assignment],
                    let deletedAssignment = assignments.first(where: { $0.ckRecord.recordID == recordID })
                {
                    fetchedChanges()
                    
                    // Delete from Core Data
                    self.coreDataController.delete(deletedAssignment)
                    owningClass.removeFromAssignments(deletedAssignment)
                }
            }
        }
    }
}
