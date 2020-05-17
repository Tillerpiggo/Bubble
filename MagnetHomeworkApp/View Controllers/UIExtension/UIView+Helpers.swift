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
    
    func pinEdgesToView(_ otherView: UIView, withMargin margin: CGFloat = 0.0) {
        [
            self.topAnchor.constraint(equalTo: otherView.topAnchor, constant: margin),
            self.bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -1 * margin),
            self.leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: margin),
            self.trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: -1 * margin)
        ].forEach { $0.isActive = true }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}
