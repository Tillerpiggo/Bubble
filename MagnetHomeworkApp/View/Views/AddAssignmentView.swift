//
//  AddAssignmentView.swift
//  Bubble
//
//  Created by Tyler Gee on 9/15/19.
//  Copyright © 2019 Beaglepig. All rights reserved.
//

import UIKit

class AddAssignmentView: View {
    
    // MARK: - Subviews
    lazy var contentView: UIView = { UIView(frame: self.frame) }()
    
    lazy var textField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Assignment name"
        
        return textField
    }()
    
    lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.titleLabel?.text = "Done"
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        return doneButton
    }()
    
    override var intrinsicContentSize: CGSize {
        //preferred content size, calculate it if some internal state changes
        return CGSize.zero
    }
    
    // The common initialization. Setup subviews and properties and constraints, etc.
    override func setupView() {
        addSubviews()
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setVisuals()
    }
}

// MARK: - Helper functions
fileprivate extension AddAssignmentView {
    
    func addSubviews() {
        //addSubview(contentView)
        
        // Add all other contents to contentView
        addSubview(textField)
        addSubview(doneButton)
    }
    
    func addConstraints() {
        let views: [String: Any] = ["contentView": contentView, "textField": textField, "doneButton": doneButton]
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[textField]-16-[doneButton]-16-|", metrics: nil, views: views)
        addConstraints(horizontalConstraints)
        
        //addContentViewConstraints(withViews: views)
        addTextFieldConstraints(withViews: views)
        addDoneButtonConstraints(withViews: views)
    }
    
    func addContentViewConstraints(withViews views: [String: Any]) {
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView]-0-|", metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentView]-0-|", metrics: nil, views: views)
        
        addConstraints(horizontalConstraints)
        addConstraints(verticalConstraints)
    }
    
    func addTextFieldConstraints(withViews views: [String: Any]) {
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[textField(36@1000)]", metrics: nil, views: views)
        addConstraints(verticalConstraints)
    }
    
    func addDoneButtonConstraints(withViews views: [String: Any]) {
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[doneButton(48@1000)]", metrics: nil, views: views)
        addConstraints(verticalConstraints)
    }
    
    func setVisuals() {
        // Does stuff like round the view, add a shadow, set background color, etc.
        
        // Round corners
        layer.masksToBounds = true
        
        let roundedTopMaskLayer = CAShapeLayer()
        //let shadowBounds = CGRect(x: bounds.x, y: bounds.y, width: bounds.width, height: bounds.height + 50)
        roundedTopMaskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 24, height: 24)).cgPath
        layer.mask = roundedTopMaskLayer
        
        contentView.backgroundColor = .gray
        
        // Add shadow
        backgroundColor = .black
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 20
    }
}
