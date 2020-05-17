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

class AddAssignmentView: ProgrammaticView {
    
    // MARK: - Subviews
    
    var contentView = UIView()
    var delegate: AddAssignmentViewDelegate?
    
    private var shadowLayer: CAShapeLayer!
    private let doneButtonEnabledAttributedText = NSAttributedString(string: "Done", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: UIColor(red: 0.48, green: 0.64, blue: 1, alpha: 1)])
    private let doneButtonDisabledAttributedText = NSAttributedString(string: "Done", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: UIColor(white: 0.87, alpha: 1)])
    
    lazy var roundedExpandingTextView: RoundedExpandingTextView = {
        let roundedExpandingTextView = RoundedExpandingTextView()
        roundedExpandingTextView.translatesAutoresizingMaskIntoConstraints = false
        roundedExpandingTextView.placeholder = "Add assignment here..."
        roundedExpandingTextView.delegate = self
        
        return roundedExpandingTextView
    }()
    
    lazy var doneButton: BouncyButton = {
        let doneButton = BouncyButton()
        doneButton.setAttributedTitle(doneButtonEnabledAttributedText, for: .normal)
        doneButton.setAttributedTitle(doneButtonDisabledAttributedText, for: .disabled)
        
        doneButton.delegate = self
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.isEnabled = false
        
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

extension AddAssignmentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.doneButton.isEnabled = true
        }
    }
}

extension AddAssignmentView: BouncyButtonDelegate {
    func buttonPressed(_ button: BouncyButton) {
        delegate?.doneButtonPressed(withText: roundedExpandingTextView.textView.text)
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
        contentView.pinEdgesToView(self)
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
}
