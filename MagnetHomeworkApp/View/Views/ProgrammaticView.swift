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
        self.init(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
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

class BouncyView: ProgrammaticView {
    override func setupView() {
        // Add tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
                self.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
            })
        case .failed, .cancelled:
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
                self.transform = .identity
            })
        case .recognized, .ended:
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
                self.transform = CGAffineTransform(scaleX: 1.015, y: 1.015)
            }, completion: { (bool) in
                UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveEaseIn, animations: { [unowned self]  in
                    self.transform = .identity
                })
            })
            
            tapped()
        default: break
        }
    }
    
    func tapped() {
        // override this method in subclasses
    }
}
