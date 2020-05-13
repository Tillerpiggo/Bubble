//
//  RecordType.swift
//  MagnetHomeworkApp
//
//  Created by Tyler Gee on 10/25/18.
//  Copyright © 2018 Beaglepig. All rights reserved.
//

import Foundation
import CloudKit

enum RecordType: String, Equatable {
    case `class` = "Class"
    case assignment = "Assignment"
    case toDo = "ToDo"
    
    var string: String {
        switch self {
        case .class:
            return "Class"
        case .assignment:
            return "Assignment"
        case .toDo:
            return "ToDo"
        }
    }
    
    // Priority when fetching records... higher means it is used first
    var priority: Int {
        switch self {
        case .class: return 3
        case .assignment: return 2
        case .toDo: return 1
        }
    }
    
    init?(withCKRecordType ckRecordType: CKRecord.RecordType) {
        switch ckRecordType {
        case RecordType.class.string: self = RecordType.class
        case RecordType.assignment.string: self = RecordType.assignment
        case RecordType.toDo.string: self = RecordType.toDo
        default: return nil
        }
    }
}

