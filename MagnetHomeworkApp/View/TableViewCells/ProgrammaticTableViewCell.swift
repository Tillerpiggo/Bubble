//
//  ProgrammaticTableViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 6/20/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit


class ProgrammaticCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        // implement this when subclassing
        
        // This is where EVERYTHING is setup. Typically addSubviews and then addConstraints
    }
}
