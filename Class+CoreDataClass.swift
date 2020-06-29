//
//  Class+CoreDataClass.swift
//  MagnetHomeworkApp
//
//  Created by Tyler Gee on 10/24/18.
//  Copyright © 2018 Beaglepig. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit
import UIKit

public class Class: NSManagedObject, CloudUploadable {
    
    // MARK: - Properties
    
    var ckRecord: CKRecord = CKRecord(recordType: "Class")
    var isSynced: Bool = false
    
    // MARK: - Computed Properties
    
    func previewAssignment() -> Assignment? {
        return previewAssignments()?.first
    }
    
    func previewAssignments() -> [Assignment]? {
        let compareBlock: (Assignment, Assignment) -> Bool = {
            return $0.dueDateSection > $1.dueDateSection
        }
        
        let completedAssignments = assignmentArray?.filter({ $0.toDo?.isCompleted ?? false != true })
        
        if let mostImportantAssignment = completedAssignments?.max(by: compareBlock) {
            let sectionName = mostImportantAssignment.dueDateSection
            let assignmentsInSection = completedAssignments?.filter { $0.dueDateSection == sectionName }
            
            //print("Assignments In Section: \(assignmentsInSection?.map({ $0.text }))\nClass Name: \(self.name)\n")
            return assignmentsInSection?.sorted(by: compareBlock)
        } else {
            return nil
        }
    }
    
    var assignmentArray: [Assignment]? {
        if let assignmentArray = assignments?.array as? [Assignment] {
            return assignmentArray
        } else {
            return nil
        }
    }
    
    var progress: CGFloat {
        let assignmentsDueTomorrow = assignmentArray!.filter({ $0.dueDateType == .unscheduled || $0.dueDateType == .late || $0.dueDateType == .dueToday || $0.dueDateType == .dueTomorrow })
        let numberOfAssignmentsDueTomorrow = assignmentsDueTomorrow.count
        let numberOfCompletedAssignmentsDueTomorrow = assignmentsDueTomorrow.filter({ $0.isCompleted == true }).count
        
        guard numberOfAssignmentsDueTomorrow > 0 else { return 0 }
        
        return CGFloat(numberOfCompletedAssignmentsDueTomorrow) / CGFloat(numberOfAssignmentsDueTomorrow)
    }
    
    var numberOfUncompletedAssignments: Int {
        return assignmentArray?.filter({ $0.isCompleted == false }).count ?? 0
    }
    
    var color: Color {
        return Color(rawValue: colorInt)!
    }
    
    // MARK: - Initializers
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        generateRecord()
    }
    
    init(withName name: String, assignments: [Assignment] = [Assignment](), color: Color, managedContext: NSManagedObjectContext, zoneID: CKRecordZone.ID) {
        // Create entity
        let classDescription = NSEntityDescription.entity(forEntityName: "Class", in: managedContext)
        super.init(entity: classDescription!, insertInto: managedContext)
        
        // Configure CKRecord
        let recordName = UUID().uuidString
        let recordID = CKRecord.ID(recordName: recordName, zoneID: zoneID)
        let newCKRecord = CKRecord(recordType: "Class", recordID: recordID)
        newCKRecord["name"] = name as CKRecordValue?
        //newCKRecord["latestAssignment"] = previewAssignment() as CKRecordValue?
        self.ckRecord = newCKRecord
        
        // Set properties
        self.name = name
        self.colorInt = color.rawValue
        self.creationDate = NSDate()
        self.dateLastModified = NSDate()
        self.encodedSystemFields = ckRecord.encoded()
        self.isUserCreated = true
        
        for assignment in assignments {
            self.addToAssignments(assignment)
            assignment.owningClass = self
        }
    }
    
    convenience init(withName name: String, assignments: [Assignment] = [Assignment](), color: Color, dataController: DataController) {
        self.init(withName: name, assignments: assignments, color: color, managedContext: dataController.managedContext, zoneID: dataController.zoneID)
    }
    
    init(fromRecord record: CKRecord, managedContext: NSManagedObjectContext) {
        // Create entity
        let classDescription = NSEntityDescription.entity(forEntityName: "Class", in: managedContext)
        super.init(entity: classDescription!, insertInto: managedContext)
        
        // Set properties
        self.name = record["name"] as? String
        self.colorInt = record["colorInt"] as! Int
        self.creationDate = record.creationDate! as NSDate
        self.dateLastModified = record.modificationDate! as NSDate
        self.encodedSystemFields = record.encoded()
        self.isUserCreated = true // just default value, make sure to set after init
        
        // Set CKRecord
        self.ckRecord = record
    }
    
    /// Changes all of the fields of this Class to match the CKRecord
    func update(withRecord record: CKRecord) {
        self.name = record["name"] as? String
        self.colorInt = record["colorInt"] as! Int
        if let creationDate = record.creationDate as NSDate? { self.creationDate = creationDate }
        if let dateLastModified = record.modificationDate as NSDate? { self.dateLastModified = dateLastModified }
        self.encodedSystemFields = record.encoded()
        
        self.ckRecord = record
        self.isSynced = true
    }
    
    func generateRecord() {
        if let encodedSystemFields = self.encodedSystemFields {
            do {
                let unarchiver = try NSKeyedUnarchiver(forReadingFrom: encodedSystemFields)
                unarchiver.requiresSecureCoding = true
                let newCKRecord = CKRecord(coder: unarchiver)!
                unarchiver.finishDecoding()
            
                newCKRecord["name"] = name as CKRecordValue?
                newCKRecord["colorInt"] = colorInt as CKRecordValue?
                //newCKRecord["latestAssignment"] = previewAssignment() as CKRecordValue?
                
                self.ckRecord = newCKRecord
            } catch {
                print("ERROR: Something went wrong with NSKeyedUnarchiver in Class+CoreDataClass")
            }
        } else {
            print("ERROR: Unable to reconstruct CKRecord from metadata (Class); encodedSystemFields not found")
        }
    }
}

extension Class: CoreDataUploadable {
    var coreData: NSManagedObject {
        return self
    }
}

// Use init(rawValue:) to initialize from Int

