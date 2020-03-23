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
    
    var contentView = UIView()
    
    private var shadowLayer: CAShapeLayer!
    
    lazy var textField: RoundedExpandingTextView = {
        let textField = RoundedExpandingTextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add assignment here..."
        
        return textField
    }()
    
    lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.titleLabel?.text = "Done"
        doneButton.titleLabel?.textColor = .systemBlue
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
        addSubview(contentView)
        contentView.backgroundColor = .white
        // Add all other contents to contentView
        contentView.addSubview(textField)
        contentView.addSubview(doneButton)
    }
    
    func addConstraints() {
        let views: [String: Any] = ["textField": textField, "doneButton": doneButton]
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[textField]-16-[doneButton(60@1000)]-12-|", metrics: nil, views: views)
        addConstraints(horizontalConstraints)
        
        addContentViewConstraints()
        addTextFieldConstraints()
        addDoneButtonConstraints(withViews: views)
    }
    
    func addContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func addTextFieldConstraints() {
        [
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 24.0)
        ].forEach { $0.isActive = true }
    }
    
    func addDoneButtonConstraints(withViews views: [String: Any]) {
        [
            doneButton.topAnchor.constraint(equalTo: textField.topAnchor)
        ].forEach { $0.isActive = true }
    }
    
    func setVisuals() {
        // Does stuff like round the view, add a shadow, set background color, etc.
        
        // Round corners
        contentView.layer.masksToBounds = true
        
        let roundedTopMaskLayer = CAShapeLayer()
        
        roundedTopMaskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 24, height: 24)).cgPath
        contentView.layer.mask = roundedTopMaskLayer
        contentView.backgroundColor = .white
        
        backgroundColor = .clear
        
        // Add shadow
        if shadowLayer == nil { // Make sure not to add extra shadows/repeat this function
            shadowLayer = CAShapeLayer()
            
            let shadowHeight: CGFloat = 24
            
            // This stops the shadow from showing on the bottom and breaking the illusion.
            let shadowBounds = CGRect(x: bounds.minX, y: bounds.minY - shadowHeight + 30, width: bounds.width, height: shadowHeight)
            let shadowPath = UIBezierPath(rect: shadowBounds)
            
            //shadowLayer.path = shadowPath.cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowPath.cgPath
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.3
            shadowLayer.shadowRadius = 16
            
            // Add a mask so that the shadow only shows on the top
            let cutOutBottomMask = CAShapeLayer()
            let cutOutBottomBounds = CGRect(x: bounds.minX, y: 1000, width: bounds.width, height: 400)
            let cutOutBottomPath = UIBezierPath(rect: cutOutBottomBounds).cgPath
            cutOutBottomMask.path = cutOutBottomPath
            //shadowLayer.mask = cutOutBottomMask
            
            layer.insertSublayer(shadowLayer, at: 0)
            
        }
    }
}
