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


// Helper helpers
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
