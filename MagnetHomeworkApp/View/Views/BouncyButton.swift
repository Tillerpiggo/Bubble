//
//  BouncyButton.swift
//  Bubble
//
//  Created by Tyler Gee on 3/26/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

// A button with bouncy animations
import UIKit

protocol BouncyButtonDelegate {
    func buttonPressed(_ button: BouncyButton)
}

class BouncyButton: ProgrammaticView {
    
    var delegate: BouncyButtonDelegate?
    
    //let animator = Animator()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchedUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouchDraggedOutside), for: .touchDragOutside)
        button.addTarget(self, action: #selector(buttonTouchDraggedInside), for: .touchDragInside)
        
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override func setupView() {
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        
        addSubviews([button, imageView])
        addConstraints()
    }
    
    // MARK: - Public methods
    func setAttributedTitle(_ attributedTitle: NSAttributedString, for state: UIButton.State) {
        button.setAttributedTitle(attributedTitle, for: state)
    }
    
    func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event) {
        button.addTarget(target, action: action, for: event)
    }
    
    var isEnabled: Bool {
        get {
            return button.isEnabled
        }
        set {
            button.isEnabled = newValue
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    func setColor(to color: Color) {
        self.layer.backgroundColor = color.uiColor.cgColor
    }
    
    func setImage(to image: UIImage) {
        self.imageView.image = image
    }
    
    private func addConstraints() {
        button.pinEdgesToView(self)
        imageView.pinEdgesToView(self)
        
        self.bringSubviewToFront(button)
    }
    
    // MARK: - Animations
    @objc func buttonTouchedUpInside() {
        
        // "release" bounce animation w/ payoff
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
            let expandTransform = CGAffineTransform(scaleX: 1.01, y: 1.01)
            self.transform = expandTransform
            
        }, completion: { (bool) in
            UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveEaseIn, animations: { [unowned self] in
                self.transform = .identity
                //self.button.isEnabled = false
            })
        })
 
        //animator.animateSpringRelease(on: button)
        
        delegate?.buttonPressed(self)
    }
    
    @objc func buttonTouchDraggedOutside() {
        
        
        // "release" bounce animation slowly and gently (longer time)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
            self.transform = .identity
        })
        
        //DispatchQueue.main.async { self.animator.animateSpringGentleRelease(on: self.button) }
    }
    
    @objc func buttonTouchDraggedInside() {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
            let shrinkTransform = CGAffineTransform(scaleX: 0.88, y: 0.88)
            self.transform = shrinkTransform
        })
 
        //DispatchQueue.main.async { self.animator.animateSpringChargeUp(on: self.button) }
    }
    
    @objc func buttonTouchedDown() {
        
        // Do start of bounce animation "charge up"
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
            let shrinkTransform = CGAffineTransform(scaleX: 0.88, y: 0.88)
            self.transform = shrinkTransform
        })
 
        //DispatchQueue.main.async { self.animator.animateSpringChargeUp(on: self.button) }
    }
}
