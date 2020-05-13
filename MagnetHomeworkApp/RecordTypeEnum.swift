//
//  RecordType.swift
//  Bubble
//
//  Created by Tyler Gee on 3/25/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import Foundation

enum RecordType {
    case `class`, assignment, todo
    
    var string: String {
        switch self {
        case .class: return "Class"
        case .assignment: return "Assignment"
        case .todo: return "ToDo"
        }
    }
}
