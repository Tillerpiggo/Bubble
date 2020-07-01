//
//  CollectionPickerViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 6/22/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class PickerViewCell: ProgrammaticCollectionViewCell {
    
}

class CollectionPickerViewCell: ProgrammaticCollectionViewCell {
    
    var delegate: PickerViewDelegate?
    
    var collectionPickerView: CollectionPickerView?
    
    func initializeCollectionPickerView(with items: [Any?]) {
        let collectionPickerView = CollectionPickerView(items: items)
        collectionPickerView.translatesAutoresizingMaskIntoConstraints = false
        collectionPickerView.delegate = self
    
        self.collectionPickerView = collectionPickerView
    }
    
    override func setupView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pinEdgesToView(self, priority: 999)
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32).isActive = true
    }
    
    func configure(with items: [Any?]) {
print("CELL CONFIGURING!")
        initializeCollectionPickerView(with: items)
        contentView.addSubview(collectionPickerView!)
        collectionPickerView!.pinEdgesToView(contentView)
    }
    
    func reset() {
        collectionPickerView?.reset()
    }
    
    func toggleExpansion(animated: Bool) {
        collectionPickerView?.toggleExpansion(animated: animated)
    }
    
    override func prepareForReuse() {
print("BEING REUSED!")
    }
}

extension CollectionPickerViewCell: PickerViewDelegate {
    func didSelect(_ item: Any?, pickerView: CollectionPickerView) {
        delegate?.didSelect(item, pickerView: collectionPickerView!)
    }
}

class ClassCollectionPickerViewCell: CollectionPickerViewCell {
    override func initializeCollectionPickerView(with items: [Any?]) {
        let classPickerView = ClassPickerView(items: items)
        classPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.collectionPickerView = classPickerView
    }
}

class DueDateCollectionPickerViewCell: CollectionPickerViewCell {
    override func initializeCollectionPickerView(with items: [Any?]) {
        let datePickerView = DatePickerView(items: items)
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.collectionPickerView = datePickerView
    }
}
