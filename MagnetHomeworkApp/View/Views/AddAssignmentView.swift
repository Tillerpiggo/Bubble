//
//  AddAssignmentView.swift
//  Bubble
//
//  Created by Tyler Gee on 9/15/19.
//  Copyright © 2019 Beaglepig. All rights reserved.
//

import UIKit

protocol AddAssignmentViewDelegate {
    func doneButtonPressed(withText text: String)
}

class AddAssignmentView: View {
    
    // MARK: - Subviews
    
    var contentView = UIView()
    var delegate: AddAssignmentViewDelegate?
    
    private var shadowLayer: CAShapeLayer!
    
    lazy var roundedExpandingTextView: RoundedExpandingTextView = {
        let roundedExpandingTextView = RoundedExpandingTextView()
        roundedExpandingTextView.translatesAutoresizingMaskIntoConstraints = false
        roundedExpandingTextView.placeholder = "Add assignment here..."
        
        return roundedExpandingTextView
    }()
    
    lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        let blue = UIColor(red: 0.48, green: 0.64, blue: 1, alpha: 1)
        let attributedText = NSAttributedString(string: "Done", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: blue])
        doneButton.setAttributedTitle(attributedText, for: .normal)
        
        // Add actions
        doneButton.addTarget(self, action: #selector(doneButtonTouchedDown), for: .touchDown)
        doneButton.addTarget(self, action: #selector(doneButtonTouchedUpInside), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTouchDraggedOutside), for: .touchDragOutside)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        return doneButton
    }()
    
    override var intrinsicContentSize: CGSize {
        //preferred content size, calculate it if some internal state changes
        return CGSize.zero
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let window = self.window {
            self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
        }
    }
    
    // The common initialization. Setup subviews and properties and constraints, etc.
    override func setupView() {
        addSubviews()
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setVisuals()
    }
}

// MARK: - Helper functions
fileprivate extension AddAssignmentView {
    
    func addSubviews() {
        addSubview(contentView)
        contentView.backgroundColor = .white
        // Add all other contents to contentView
        contentView.addSubview(roundedExpandingTextView)
        contentView.addSubview(doneButton)
    }
    
    func addConstraints() {
        let views: [String: Any] = ["textField": roundedExpandingTextView, "doneButton": doneButton]
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[textField]-12-[doneButton(60@1000)]-12-|", metrics: nil, views: views)
        addConstraints(horizontalConstraints)
        
        addContentViewConstraints()
        addTextFieldConstraints()
        addDoneButtonConstraints(withViews: views)
    }
    
    func addContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    // TODO: Maybe make this more concise
    func addTextFieldConstraints() {
        let topConstraint = NSLayoutConstraint(item: roundedExpandingTextView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 12.0)
        let bottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: roundedExpandingTextView, attribute: .bottom, multiplier: 1.0, constant: 12.0)
        contentView.addConstraint(topConstraint)
        contentView.addConstraint(bottomConstraint)
    }
    
    func addDoneButtonConstraints(withViews views: [String: Any]) {
        //let topConstraint = NSLayoutConstraint(item: doneButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 12.0)
        let bottomConstraint = NSLayoutConstraint(item: doneButton, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -12.0)
        //contentView.addConstraint(topConstraint)
        contentView.addConstraint(bottomConstraint)
    }
    
    func setVisuals() {
        // Does stuff like round the view, add a shadow, set background color, etc.
        
        // Round corners
        contentView.layer.masksToBounds = true
        
        let roundedTopMaskLayer = CAShapeLayer()
        
        roundedTopMaskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 24, height: 24)).cgPath
        contentView.layer.mask = roundedTopMaskLayer
        contentView.backgroundColor = .white
        
        self.backgroundColor = .clear
        
        
        // Add shadow
        let shadowHeight: CGFloat = 24
        
        // This stops the shadow from showing on the bottom and breaking the illusion.
        let shadowBounds = CGRect(x: bounds.minX, y: bounds.minY - shadowHeight + 30, width: bounds.width, height: shadowHeight)
        let shadowPath = UIBezierPath(rect: shadowBounds)
        
        if shadowLayer == nil { // Make sure not to add extra shadows/repeat this function
            shadowLayer = CAShapeLayer()
            
            
            
            //shadowLayer.path = shadowPath.cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowPath.cgPath
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.3
            shadowLayer.shadowRadius = 16
            
            // Add a mask so that the shadow only shows on the top
            /*
            let cutOutBottomMask = CAShapeLayer()
            let cutOutBottomBounds = CGRect(x: bounds.minX, y: 1000, width: bounds.width, height: 400)
            let cutOutBottomPath = UIBezierPath(rect: cutOutBottomBounds).cgPath
            cutOutBottomMask.path = cutOutBottomPath
 */
            // Animate the shadow when it changes/moves
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = CATransitionType.push
            shadowLayer.add(transition, forKey: "transition")
            
            layer.insertSublayer(shadowLayer, at: 0)
        } else {
            /*
            // animate the shadow over 0.3 seconds to the desired new bounds
            let animation = CABasicAnimation(keyPath: "bounds")
            animation.fromValue = shadowLayer.bounds
            animation.toValue = shadowBounds
            animation.timingFunction = CAMediaTimingFunction(name: .default)
            animation.duration = 0.3
            
            shadowLayer.add(animation, forKey: nil)
            */
            // Note for tomorrow: this does something, but it's not shadows
            
            /*
            CATransaction.begin()
            if let animation = layer.animation(forKey: "position") {
                CATransaction.setAnimationDuration(animation.duration)
                CATransaction.setAnimationTimingFunction(animation.timingFunction)
                print("THIS IS NOT TRIGGERING... I NEED IT TO")
            } else {
                CATransaction.disableActions()
            }
            shadowLayer.frame = bounds
            
            //shadowLayer.shadowPath = shadowPath.cgPath
            
            CATransaction.commit()
 */
        }
        
        // Figure out how to animate shadow with everything
    }
    
    @objc func doneButtonTouchedUpInside() {
        print("DONE BUTTON PRESSED")
        
        // "release" bounce animation w/ payoff of a glow effect
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
            self.doneButton.transform = .identity
        })
        
        delegate?.doneButtonPressed(withText: roundedExpandingTextView.textView.text)
        
    }
    
    @objc func doneButtonTouchDraggedOutside() {
        // "release" bounce animation slowly and calmly
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
            self.doneButton.transform = .identity
        })
    }
    
    @objc func doneButtonTouchedDown() {
        // Do start of bounce animation "charge up"
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
            let shrinkTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.doneButton.transform = shrinkTransform
        })
    }
}
