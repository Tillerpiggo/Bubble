//
//  AddClassViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 3/26/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import Foundation
import UIKit

class AddClassCollectionViewCell: UICollectionViewCell {
    let addClassView: ProgrammaticAddClassView = {
        let addClassView = ProgrammaticAddClassView()
        addClassView.translatesAutoresizingMaskIntoConstraints = false
        
        // Maybe set delegate
        
        return addClassView
    }()
    
    // TODO: Abstract this into helper functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        contentView.addSubview(addClassView)
        contentView.backgroundColor = .white
        
        addContentViewConstraints()
        addAddClassViewConstraints()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //override var intrinsicContentSize: CGSize { return CGSize(width: 1, height: 1) }
}

// Helper methods:
fileprivate extension AddClassCollectionViewCell {
    func addContentViewConstraints() {
        [
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ].forEach { $0.isActive = true }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addAddClassViewConstraints() {
        // In relation to the contentView:
        
        [
            addClassView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            addClassView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0),
            addClassView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            addClassView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0)
        ].forEach { $0.isActive = true }
    }
}
