//
//  NumberView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/19/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class NumberView: ProgrammaticView {
    private var numberOfAssignmentsView: UIView = {
        let numberOfAssignmentsView = UIView()
        numberOfAssignmentsView.layer.cornerRadius = 12
        numberOfAssignmentsView.layer.masksToBounds = true
        numberOfAssignmentsView.translatesAutoresizingMaskIntoConstraints = false
        
        return numberOfAssignmentsView
    }()
    
    private var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        numberLabel.text = "0"
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return numberLabel
    }()
    
    override func setupView() {
        // Configure main view
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(numberLabel)
        
        numberLabel.center(inView: self)
    }
    
    func setColor(to color: Color) {
        self.backgroundColor = color.uiColor.withAlphaComponent(0.4)
        numberLabel.textColor = color.uiColor.withAlphaComponent(0.8)
    }
    
    func setNumber(to number: Int) {
        numberLabel.text = "\(number)"
    }
}
