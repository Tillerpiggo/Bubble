//
//  ClassPickerViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 6/23/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

/*
class PickableClassCell: ProgrammaticCollectionViewCell, PickableItemCell {
    
    var string: String?
    var color: UIColor?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        return label
    }()
    
    override func setupView() {
        contentView.addSubview(label)
        contentView.pinEdgesToView(self)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        label.addConstraints(
            top: contentView.topAnchor, topConstant: 8,
            bottom: contentView.bottomAnchor, bottomConstant: 8,
            leading: contentView.leadingAnchor, leadingConstant: 12,
            trailing: contentView.trailingAnchor, trailingConstant: 12)
    }
    
    func configure(with item: Any?) {
        guard let cellClass = item as? Class? else { return }
        
        if let cellClass = cellClass {
            contentView.backgroundColor = cellClass.color.uiColor
            label.text = cellClass.name
            label.textColor = .white
            
            string = cellClass.name
            color = cellClass.color.uiColor
        } else {
            contentView.backgroundColor = UIColor(white: 0.933, alpha: 1.0)
            label.text = "None"
            label.textColor = UIColor(white: 0.758, alpha: 1.0)
            
            string = "None"
            color = nil
        }
    }
}

 */
