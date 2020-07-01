//
//  ActionSheetPickerView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/30/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

protocol PickableItem {
    var string: String { get }
    var color: Color { get }
}

class ActionSheetPickerView: BouncyView {
    
    var delegate: PickerViewDelegate?
    var items: [PickableItem]
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .left
        
        return titleLabel
    }()
    
    private lazy var selectedItemLabel: UILabel = {
        let selectedItemLabel = UILabel()
        selectedItemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        selectedItemLabel.textAlignment = .right
        
        return selectedItemLabel
    }()
    
    init(items: [PickableItem]) {
        self.items = items
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        addSubviews([titleLabel, selectedItemLabel])
        addConstraints()
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        self.addDropShadow(color: .black, opacity: 0.1, radius: 15)
    }
    
    private func addConstraints() {
        titleLabel.addConstraints(
            top: self.topAnchor, topConstant: 8,
            bottom: self.bottomAnchor, bottomConstant: 8,
            leading: self.leadingAnchor, leadingConstant: 8,
            trailing: selectedItemLabel.leadingAnchor)
        selectedItemLabel.addConstraints(
            top: self.topAnchor, topConstant: 8,
            bottom: self.bottomAnchor, bottomConstant: 8,
            trailing: self.trailingAnchor, trailingConstant: 8)
    }
    
    override func tapped() {
        // Display action sheet
        let actionSheet = UIAlertController(title: "Select class", message: nil, preferredStyle: .actionSheet)
        
        for item in items {
            actionSheet.addAction(UIAlertAction(title: item.string, style: .default, handler: { (action) in
                delegate?.didSelect(item, pickerView: self)
            }))
        }
    }
}
