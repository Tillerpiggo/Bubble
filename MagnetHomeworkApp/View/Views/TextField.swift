//
//  TextField.swift
//  Bubble
//
//  Created by Tyler Gee on 3/21/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

// This is my custom textField with a rounded background and customization how I like it. It's just a textField with a background UIView...
// It's just made for easy reusability and consistency throughout the app

class TextField: View {
    // MARK: - Subviews
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Set textField visuals:
        
        // Set text properties
        textField.defaultTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]
        textField.textColor = UIColor(white: 0.837, alpha: 1.0)
        
        return textField
    }()
    
    // Text field wrapper functions:
    var placeholder: String? {
        get {
            return textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }
    
    override func setupView() {
        addSubviews()
        addConstraints()
        setVisuals()
    }
}

// MARK: - Helper functions
fileprivate extension TextField {
    
    func addSubviews() {
        addSubview(textField)
    }
    
    func addConstraints() {
        let views: [String: Any] = ["textField": textField]
        
        // Create constraints
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[textField]-12-|", metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[textField]-0-|", metrics: nil, views: views)
        
        // Add constraints
        addConstraints(horizontalConstraints)
        addConstraints(verticalConstraints)
    }
    
    func setVisuals() {
        // This is doing most of the work that sets this view apart from UITextField
        
        // Round corners
        layer.cornerRadius = 12
        clipsToBounds = true
        
        // Set background color
        backgroundColor = UIColor(white: 0.971, alpha: 1.0)
    }
    
}
