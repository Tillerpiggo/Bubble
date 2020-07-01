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
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchedUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouchDraggedOutside), for: .touchDragOutside)
        button.addTarget(self, action: #selector(buttonTouchDraggedInside), for: .touchDragInside)
        
        return button
    }()
    
    /// When subclassing, call super.setupView after custom setupView implementation
    override func setupView() {
        // Add tap gesture recognizer
        self.addSubview(button)
        self.bringSubviewToFront(button)
        button.pinEdgesToView(self)
    }
    
    @objc func buttonTouchedUpInside() {
        // "release" bounce animation w/ payoff
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
            let expandTransform = CGAffineTransform(scaleX: 1.01, y: 1.01)
            self.transform = expandTransform
        }, completion: { (bool) in
            UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveEaseIn, animations: { [unowned self] in
                self.transform = .identity
            })
        })
        
        tapped()
    }
    
    @objc func buttonTouchDraggedOutside() {
        // "release" bounce animation slowly and gently (longer time)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
            self.transform = .identity
        })
    }
    
    @objc func buttonTouchDraggedInside() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
            let shrinkTransform = CGAffineTransform(scaleX: 0.88, y: 0.88)
            self.transform = shrinkTransform
        })
    }
    
    @objc func buttonTouchedDown() {
           // Do start of bounce animation "charge up"
           UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
               let shrinkTransform = CGAffineTransform(scaleX: 0.88, y: 0.88)
               self.transform = shrinkTransform
           })
       }
    
    func tapped() {
        // override this method in subclasses
    }
}

/*
class TapGestureRecognizer: UITapGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        print("Touches began")
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        print("Touches moved")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        print("Touches cancelled")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        print("Touches ended")
    }
}
 */
