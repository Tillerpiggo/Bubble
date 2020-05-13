//
//  ClassCollectionViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 3/26/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

// MARK: - ClassCollectionViewCell
class ClassCollectionViewCell: UICollectionViewCell {
    
    // The background view
    private var bubbleView: UIView = {
        let bubbleView = UIView()
        bubbleView.backgroundColor = .white
        
        // Round corners
        
        return bubbleView
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

// MARK: - Helper Methods
fileprivate extension ClassCollectionViewCell {
    func setupView() {
        // Add subviews
        
        
        // Add constraints
        
    }
}
