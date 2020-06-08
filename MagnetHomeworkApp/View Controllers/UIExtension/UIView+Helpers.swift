//
//  UIView+Helpers.swift
//  MagnetHomeworkApp
//
//  Created by Tyler Gee on 11/6/18.
//  Copyright © 2018 Beaglepig. All rights reserved.
//

import UIKit

extension UIView {
    func addDropShadow(color: UIColor, opacity: Float, radius: CGFloat, yOffset: CGFloat = 0.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = radius
        //layer.contentsScale = 1.0
        
        //layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.shouldRasterize = true
        
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func removeDropShadow() {
        layer.masksToBounds = true
    }
    
    func pinEdgesToView(_ otherView: UIView, withMargin margin: CGFloat = 0.0, priority: Float? = nil) {
        [
            self.topAnchor.constraint(equalTo: otherView.topAnchor, constant: margin),
            self.bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -1 * margin),
            self.leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: margin),
            self.trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: -1 * margin)
        ].forEach {
            if let priority = priority {
                $0.priority = UILayoutPriority(rawValue: priority)
            }
            $0.isActive = true
        }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addSubview(subview)
        }
    }
    
    // Make it faster to add constraints
    func addConstraints(top: NSLayoutAnchor<NSLayoutYAxisAnchor>?, bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>?, leading: NSLayoutAnchor<NSLayoutXAxisAnchor>?, trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>?, topConstant: CGFloat, bottomConstant: CGFloat, leadingConstant: CGFloat, trailingConstant: CGFloat, widthConstant: CGFloat?, heightConstant: CGFloat?, priority: Float? = nil) {
        
        if let top = top {
            let constraint = topAnchor.constraint(equalTo: top, constant: topConstant)
            if let priority = priority { constraint.priority = UILayoutPriority(rawValue: priority) }
            constraint.isActive = true
        }
        
        if let bottom = bottom {
            let constraint = bottomAnchor.constraint(equalTo: bottom, constant: -1 * bottomConstant)
            if let priority = priority { constraint.priority = UILayoutPriority(rawValue: priority) }
            constraint.isActive = true
        }
        
        if let leading = leading {
            let constraint = leadingAnchor.constraint(equalTo: leading, constant: leadingConstant)
            if let priority = priority { constraint.priority = UILayoutPriority(rawValue: priority) }
            constraint.isActive = true
        }
        
        if let trailing = trailing {
            let constraint = trailingAnchor.constraint(equalTo: trailing, constant: -1 * trailingConstant)
            if let priority = priority { constraint.priority = UILayoutPriority(rawValue: priority) }
            constraint.isActive = true
        }
        
        if let width = widthConstant {
            let constraint = widthAnchor.constraint(equalToConstant: width)
            if let priority = priority { constraint.priority = UILayoutPriority(rawValue: priority) }
            constraint.isActive = true
        }
        
        if let height = heightConstant {
            let constraint = heightAnchor.constraint(equalToConstant: height)
            if let priority = priority { constraint.priority = UILayoutPriority(rawValue: priority) }
            constraint.isActive = true
        }
    }
}
