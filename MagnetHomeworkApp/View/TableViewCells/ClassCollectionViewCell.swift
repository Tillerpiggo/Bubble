//
//  ClassCollectionViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 3/26/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

// MARK: - ClassCollectionViewCell
class ClassCollectionViewCell: ProgrammaticCollectionViewCell {
    
    var cellClass: Class?
    
    // The background view
    private var bubbleView: UIView = {
        let bubbleView = UIView()
        bubbleView.backgroundColor = .white
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        // Round corners
        bubbleView.layer.cornerRadius = 24
        bubbleView.layer.masksToBounds = true
        
        bubbleView.addDropShadow(color: .black, opacity: 0.12, radius: 20)
        
        return bubbleView
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    /*
    private var numberOfAssignmentsView: UIView = {
        let numberOfAssignmentsView = UIView()
        numberOfAssignmentsView.layer.cornerRadius = 12
        numberOfAssignmentsView.layer.masksToBounds = true
        numberOfAssignmentsView.translatesAutoresizingMaskIntoConstraints = false
        
        return numberOfAssignmentsView
    }()
    
    private var numberOfAssignmentsLabel: UILabel = {
        let numberOfAssignmentsLabel = UILabel()
        numberOfAssignmentsLabel.textAlignment = .center
        numberOfAssignmentsLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        numberOfAssignmentsLabel.text = "0"
        numberOfAssignmentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return numberOfAssignmentsLabel
    }()
 */
    private var numberOfAssignmentsView: NumberView = {
        let numberOfAssignmentsView = NumberView()
        numberOfAssignmentsView.translatesAutoresizingMaskIntoConstraints = false
        
        return numberOfAssignmentsView
    }()
    
    private var progressBar: ProgrammaticProgressBarView = {
        let progressBar = ProgrammaticProgressBarView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        return progressBar
    }()
    
    func configure(withClass cellClass: Class) {
        titleLabel.text = cellClass.name
        titleLabel.textColor = cellClass.color.uiColor
        //numberOfAssignmentsView.backgroundColor = cellClass.color.uiColor.withAlphaComponent(0.4)
        //numberOfAssignmentsLabel.textColor = cellClass.color.uiColor.withAlphaComponent(0.8)
        numberOfAssignmentsView.setColor(to: cellClass.color)
        progressBar.color = cellClass.color.uiColor
        self.cellClass = cellClass
    }
    
    override func setupView() {
        self.pinEdgesToView(contentView, priority: 999)
        
        // Add subviews
        addSubview(bubbleView)
        bubbleView.addSubviews([titleLabel, numberOfAssignmentsView, progressBar])
        
        // Add constraints
        addBubbleViewConstraints()
        addTitleLabelConstraints()
        addNumberOfAssignmentsViewConstraints()
        addProgressBarConstraints()
    }
}

// MARK: - Helper Methods
fileprivate extension ClassCollectionViewCell {
    
    func addBubbleViewConstraints() {
        bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.0).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.0).isActive = true
        bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0).isActive = true
        bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0).isActive = true
    }
    
    func addTitleLabelConstraints() {
        titleLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 24.0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 28.0).isActive = true
    }
    
    
    func addNumberOfAssignmentsViewConstraints() {
        numberOfAssignmentsView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 28.0).isActive = true
        numberOfAssignmentsView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -28.0).isActive = true
        numberOfAssignmentsView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        numberOfAssignmentsView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    
    /*
    func addNumberOfAssignmentsLabelConstraints() {
        numberOfAssignmentsLabel.centerXAnchor.constraint(equalTo: numberOfAssignmentsView.centerXAnchor).isActive = true
        numberOfAssignmentsLabel.centerYAnchor.constraint(equalTo: numberOfAssignmentsView.centerYAnchor).isActive = true
    }
 */
    
    func addProgressBarConstraints() {
        progressBar.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -28.0).isActive = true
        progressBar.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 28.0).isActive = true
        progressBar.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -40.0).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
    }
}
