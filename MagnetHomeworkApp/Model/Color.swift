//
//  Color.swift
//  Bubble
//
//  Created by Tyler Gee on 6/14/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

enum Color: Int {
    case orange = 0
    case red = 1
    case blue = 2
    case lightBlue = 3
    case lime = 4
    case purple = 5
    case pink = 6
    
    var uiColor: UIColor {
        switch self {
        case .orange: return UIColor(red: 1, green: 0.75, blue: 0.46, alpha: 1)
        case .red: return UIColor(red: 1, green: 0.44, blue: 0.47, alpha: 1)
        case .blue: return UIColor(red: 0.44, green: 0.66, blue: 1, alpha: 1)
        case .lightBlue: return UIColor(red: 0.51, green: 0.87, blue: 0.99, alpha: 1)
        case .lime: return UIColor(red: 0.61, green: 1, blue: 0.74, alpha: 1)
        case .purple: return UIColor(red: 0.85, green: 0.66, blue: 1, alpha: 1)
        case .pink: return UIColor(red: 1, green: 0.47, blue: 0.63, alpha: 1)
        }
    }
    
    var uiColor2: UIColor {
        switch self {
        case .orange: return Color.orange.uiColor
        case .red: return Color.red.uiColor
        case .blue: return Color.blue.uiColor
        case .lightBlue: return Color.lightBlue.uiColor
        case .lime: return Color.lime.uiColor
        case .purple: return Color.purple.uiColor
        case .pink: return Color.pink.uiColor
        }
    }
    
    var name: String {
        switch self {
        case .orange: return "Orange"
        case .red: return "Red"
        case .blue: return "Blue"
        case .lightBlue: return "Light Blue"
        case .lime: return "Lime"
        case .purple: return "Purple"
        case .pink: return "Pink"
        }
    }
}
