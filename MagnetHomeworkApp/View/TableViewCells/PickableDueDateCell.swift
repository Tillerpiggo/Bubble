//
//  DueDatePickerViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 6/23/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

/*
class PickableDueDateCell: ProgrammaticCollectionViewCell, PickableItemCell {
    
    var string: String?
    var color: UIColor?
    
    private lazy var weekdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(white: 0.558, alpha: 1.0)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(white: 0.317, alpha: 1.0)
        label.textAlignment = .center
        
        return label
    }()
    
    /*
    override func setupView() {
        contentView.addSubviews([weekdayLabel, dateLabel])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pinEdgesToView(self)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(white: 0.942, alpha: 1.0)
        
        weekdayLabel.addConstraints(
            top: contentView.topAnchor, topConstant: 8,
            bottom: dateLabel.topAnchor, bottomConstant: 0)
        weekdayLabel.addConstraints(
            leading: contentView.leadingAnchor, leadingConstant: 12,
            trailing: contentView.trailingAnchor, trailingConstant: 12,
            priority: 500)
        dateLabel.addConstraints(
            top: weekdayLabel.bottomAnchor, topConstant: 2,
            bottom: contentView.bottomAnchor, bottomConstant: 8)
        
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8).isActive = true
    }
 */
    
    override func setupView() {
        contentView.addSubviews([weekdayLabel, dateLabel])
        contentView.pinEdgesToView(self)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(white: 0.942, alpha: 1.0)
        
        weekdayLabel.addConstraints(
            top: contentView.topAnchor, topConstant: 8,
            bottom: dateLabel.topAnchor, bottomConstant: -2,
            centerX: contentView.centerXAnchor)
        
        dateLabel.addConstraints(
            bottom: contentView.bottomAnchor, bottomConstant: 6,
            leading: contentView.leadingAnchor, leadingConstant: 14,
            trailing: contentView.trailingAnchor, trailingConstant: 14)
    }
    
    func configure(with item: Any?) {
        guard let date = item as? DateModel? else { return }
        
        if let date = date {
            weekdayLabel.text = date.weekdayString
            dateLabel.text = "\(date.dayOfTheMonth)"
            
            string = date.string
            
            color = UIColor(white: 0.367, alpha: 1.0)
            
            // Add constraints
            //weekdayLabel.widthAnchor.constraint(equalToConstant: weekdayLabel.sizeThatFits(weekdayLabel.bounds.size).width).isActive = true
            
            let leading = weekdayLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 12)
            leading.priority = UILayoutPriority(rawValue: 500)
            leading.isActive = true
            
            let trailing = weekdayLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -12)
            trailing.priority = UILayoutPriority(rawValue: 500)
            trailing.isActive = true
        }
    }
}
 
 */
