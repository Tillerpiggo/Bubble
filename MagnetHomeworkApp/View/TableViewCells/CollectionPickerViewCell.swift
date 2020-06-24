//
//  CollectionPickerViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 6/22/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class CollectionPickerViewCell: ProgrammaticCollectionViewCell {
    
    var delegate: CollectionPickerViewDelegate?
    
    var collectionPickerView: CollectionPickerView?
    
    func initializeCollectionPickerView(with items: [Any?]) {
        let collectionPickerView = CollectionPickerView(items: items)
        collectionPickerView.translatesAutoresizingMaskIntoConstraints = false
        collectionPickerView.delegate = self
    
        self.collectionPickerView = collectionPickerView
    }
    
    override func setupView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pinEdgesToView(self)
    }
    
    func configure(with items: [Any?]) {
        initializeCollectionPickerView(with: items)
        contentView.addSubview(collectionPickerView!)
        collectionPickerView!.pinEdgesToView(contentView)
        layoutIfNeeded()
    }
    
    func toggleExpansion() {
        collectionPickerView?.toggleExpansion()
    }
}

extension CollectionPickerViewCell: CollectionPickerViewDelegate {
    func didSelect(_ item: Any?, collectionPickerView: CollectionPickerView) {
        delegate?.didSelect(item, collectionPickerView: collectionPickerView)
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
