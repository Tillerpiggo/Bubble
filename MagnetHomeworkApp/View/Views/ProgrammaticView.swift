//
//  View.swift
//  Bubble
//
//  Created by Tyler Gee on 3/21/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

// Subclass of UIView that allows for easy programmatic implementation
// Note: this will conflict with SwiftUI's View, so uhh... don't use SwiftUI with this, or rename this if you do use SwiftUI

import UIKit


class ProgrammaticView: UIView {
    // Use to initialize from code (or just init())
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        setupView()
    }
    
    // use to initialize from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        // implement this when subclassing...
        
        // This is where EVERYTHING is setup. Add subviews and configure them here.
    }
}
