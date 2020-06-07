//
//  ProgrammaticAddClassView.swift
//  Bubble
//
//  Created by Tyler Gee on 3/26/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit
import Foundation

protocol ProgrammaticAddClassViewDelegate {
    func addClass(withText text: String)
}

class ProgrammaticAddClassView: ProgrammaticView {
    
    var className: String?
    var delegate: ProgrammaticAddClassViewDelegate?
    var dynamicViewDelegate: DynamicViewDelegate?
    fileprivate var isExpanded: Bool = false
    
    static let disabledColor: UIColor = UIColor(white: 0.825, alpha: 1.0)
    
    fileprivate let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        
        // Round corners
        backgroundView.layer.cornerRadius = 24
        backgroundView.layer.masksToBounds = true
        
        // Add shadow
        backgroundView.addDropShadow(color: .black, opacity: 0.15, radius: 8)
        
        return backgroundView
    }()
    
    fileprivate let addClassLabel: UILabel = {
        let addClassLabel = UILabel()
        addClassLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addClassLabel.text = "Add Class"
        addClassLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        addClassLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        addClassLabel.textAlignment = .center
        
        return addClassLabel
    }()
    
    
    // Detects if you press this view while it's a button
    let expandButton: UIButton = {
        let expandButton = UIButton()
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        
        expandButton.addTarget(self, action: #selector(expandButtonPressed), for: .touchUpInside)
        
        return expandButton
    }()
    
    private let cancelButton: BouncyButton = {
        let cancelButton = BouncyButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let enabledCancelText = NSAttributedString(string: "Cancel", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .medium), .foregroundColor: UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)])
        let disabledCancelText = NSAttributedString(string: "Cancel", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .medium), .foregroundColor: disabledColor])
        cancelButton.setAttributedTitle(enabledCancelText, for: .normal)
        cancelButton.setAttributedTitle(disabledCancelText, for: .disabled)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        return cancelButton
    }()
    
    private let doneButton: BouncyButton = {
        let doneButton = BouncyButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        let enabledDoneText = NSAttributedString(string: "Done", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: UIColor(red: 0.562, green: 0.711, blue: 1, alpha: 1)])
        let disabledDoneText = NSAttributedString(string: "Done", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: disabledColor])
        doneButton.setAttributedTitle(enabledDoneText, for: .normal)
        doneButton.setAttributedTitle(enabledDoneText, for: .disabled)
        
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        return doneButton
    }()
    
    private lazy var titleTextView: RoundedExpandingTextView = {
        let titleTextView = RoundedExpandingTextView()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.placeholder = "Enter class name..."
        //titleTextView.layer.cornerRadius = 20.0
        //titleTextView.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        titleTextView.delegate = self
        
        return titleTextView
    }()
    
    override func setupView() {
        addSubviews()
        
        
        //titleTextViewHeightConstraint!.isActive = false
        
        cancelButton.delegate = self
        doneButton.delegate = self
        
        /*
        // Since it starts in the shrunken state:
        cancelButton.isHidden = true
        doneButton.isHidden = true
        roundedExpandingTextView.isHidden = true
 */
        let zeroSizeTransform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        self.cancelButton.transform = zeroSizeTransform
        self.doneButton.transform = zeroSizeTransform
        //self.roundedExpandingTextView.transform = zeroSizeTransform
        
        //titleTextViewHeightConstraint?.isActive = false
        //titleTextViewHeightConstraint?.isActive = true
    }
    
    override func didMoveToSuperview() {
        addConstraints()
        titleTextViewHeightConstraint?.isActive = true
    }
    
    // MARK: - Expand and shrink
    
    // Expand to show everything
    func expand() {
        print("isExpanded: \(isExpanded)")
        guard !isExpanded else { return }
        self.isExpanded = true
        
        //self.layoutIfNeeded()
        
        let partialSizeTransform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        self.cancelButton.transform = partialSizeTransform
        self.doneButton.transform = partialSizeTransform
        //self.roundedExpandingTextView.transform = zeroSizeTransform
        //roundedExpandingTextView.layer.opacity = 0.0
        self.cancelButton.layer.opacity = 0.0
        self.doneButton.layer.opacity = 0.0
        
        
        self.cancelButton.isHidden = false
        self.doneButton.isHidden = false
        //self.roundedExpandingTextView.isHidden = false
        
        // Fade in roundedExpandingTextView while making it horizontally bigger
        // Set initial constraints
        //setRoundedExpandingTextViewConstraints(to: .expanding)
        
        //self.dynamicViewDelegate?.sizeChanged()
        
        self.expandButton.isEnabled = false
        
        
        
        
        //self.titleTextViewHeightConstraint?.isActive = false
        //self.addClassLabelCenterYConstraint?.isActive = false
        /*
        self.titleTextViewHeightConstraint?.isActive = false
        self.titleTextViewHeightConstraint?.constant = 30.0
        self.titleTextViewHeightConstraint?.isActive = true
 */
        //setNeedsLayout()
        
        self.titleTextViewHeightConstraint?.constant = 40.0 // Not animating for some reason
        self.addClassLabelCenterYConstraint?.priority = UILayoutPriority(1)
        
        // Increase height
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.cancelButton.transform = .identity
            self.cancelButton.layer.opacity = 1.0
            self.doneButton.transform = .identity
            self.doneButton.layer.opacity = 1.0
            
            
            self.dynamicViewDelegate?.sizeChanged()
            self.layoutIfNeeded()
            
            
            
            
        }, completion: { (bool) in
            //self.dynamicViewDelegate?.sizeChanged()
        })
    }
    
    // Only show the "Add Class" label
    func shrink() {
        print("isExpanded: \(isExpanded)")
        guard isExpanded else { return }
        
        
        let zeroSizeTransform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        
        //setRoundedExpandingTextViewConstraints(to: .expanded)
        
        /*
        titleTextView.resignFirstResponder()
        self.resignFirstResponder()
        self.superview?.resignFirstResponder()
 */
        
        
        
        self.expandButton.isEnabled = true
        
        
        self.titleTextViewHeightConstraint?.isActive = true
        self.titleTextViewHeightConstraint?.constant = 0.0
        self.titleTextViewHeightConstraint?.priority = UILayoutPriority(1000)
        self.addClassLabelCenterYConstraint?.isActive = true
        
        
        
        // Decrease height
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.cancelButton.layer.opacity = 0.0
            self.doneButton.layer.opacity = 0.0
            //self.roundedExpandingTextView.transform = zeroSizeTransform
            //self.setRoundedExpandingTextViewConstraints(to: .expanding)
            
            /*
            self.titleTextViewHeightConstraint?.constant = 0.0
            self.titleTextViewTopConstraint?.constant = 16.0
            self.titleTextViewBottomConstraint?.constant = -16.0
 */
            
            
            self.dynamicViewDelegate?.sizeChanged()
            
            //self.heightConstraint?.constant = 64.0
            self.layoutIfNeeded()
            
        }, completion: { (bool) in
            //self.cancelButton.isHidden = true
            //self.doneButton.isHidden = true
            
            self.isExpanded = false
            //self.roundedExpandingTextView.isHidden = true
            
            //self.dynamicViewDelegate?.sizeChanged()
        })
    }
    
    // MARK: - Constraints
    //var roundedExpandingTextViewTopConstraint, roundedExpandingTextViewBottomConstraint, roundedExpandingTextViewLeadingConstraint, roundedExpandingTextViewTrailingConstraint, roundedExpandingTextViewWidthConstraint, roundedExpandingTextViewHeightConstraint: NSLayoutConstraint?
    var titleTextViewTopConstraint, titleTextViewBottomConstraint, titleTextViewHeightConstraint: NSLayoutConstraint?
    var addClassLabelCenterYConstraint: NSLayoutConstraint?
}

// MARK: - UITextViewDelegate
extension ProgrammaticAddClassView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        className = textView.text
    }
}

// MARK: - DynamicViewDelegate
extension ProgrammaticAddClassView: DynamicViewDelegate {
    func sizeChanged() {
        dynamicViewDelegate?.sizeChanged()
    }
}

// MARK: - Actions
fileprivate extension ProgrammaticAddClassView {
    @objc func expandButtonPressed() {
        expand()
        expandButton.isEnabled = false
    }
    
    @objc func cancelButtonPressed() {
        shrink()
        expandButton.isEnabled = true
        
        // clear the text view
        titleTextView.clear()
    }
    
    @objc func doneButtonPressed() {
        shrink() // TODO: Replace this with an animation later
        expandButton.isEnabled = true
        
        // add a class
        delegate?.addClass(withText: titleTextView.text)
    }
}

// MARK: - BouncyButtonDelegate
extension ProgrammaticAddClassView: BouncyButtonDelegate {
    func buttonPressed(_ button: BouncyButton) {
        if button == doneButton {
            print("Done!")
        } else if button == cancelButton {
            print("Canceled lol")
        }
        
        DispatchQueue.main.async { self.shrink() }
    }
}

// MARK: - Helper methods
fileprivate extension ProgrammaticAddClassView {
    
    // MARK: - Add Subviews
    func addSubviews() {
        self.addSubviews([backgroundView, expandButton])
        backgroundView.addSubviews([addClassLabel, titleTextView, cancelButton, doneButton])
        dynamicViewDelegate?.sizeChanged()
    }
    
    // MARK: - Add Constraints
    func addConstraints() {
        addBackgroundViewConstraints()
        addAddClassLabelConstraints()
        addExpandButtonConstraints()
        addCancelButtonConstraints()
        addDoneButtonConstraints()
        //addRoundedExpandingTextViewConstraints()
        addTitleTextViewConstraints()
    }
    
    func addBackgroundViewConstraints() {
        backgroundView.pinEdgesToView(self)
        backgroundView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32.0).isActive = true
        
        //self.heightConstraint = NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 64)
        //backgroundView.addConstraint(self.heightConstraint!)
        //backgroundView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }
    
    
    func addAddClassLabelConstraints() {
        [
            addClassLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20.0),
            //addClassLabel.bottomAnchor.constraint(equalTo: titleTextView.topAnchor, constant: -20.0),
            //addClassLabel.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: -20.0),
            addClassLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ].forEach { $0.isActive = true }
        
        //addClassLabelCenterYConstraint = addClassLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        addClassLabelCenterYConstraint?.isActive = true
    }
    
    func addExpandButtonConstraints() {
        expandButton.pinEdgesToView(self)
    }
    
    func addCancelButtonConstraints() {
        [
            cancelButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 14.0),
            cancelButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20.0),
            //cancelButton.bottomAnchor.constraint(equalTo: titleTextView.topAnchor, constant: -20.0)
        ].forEach { $0.isActive = true }
    }
    
    func addDoneButtonConstraints() {
        [
            doneButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 14.0),
            doneButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20.0),
            //doneButton.bottomAnchor.constraint(equalTo: titleTextView.topAnchor, constant: -20.0)
        ].forEach { $0.isActive = true }
    }
    
    /*
    func addRoundedExpandingTextViewConstraints() {
        // Filler constraints
        let fillerConstraint = NSLayoutConstraint(item: roundedExpandingTextView, attribute: .centerX, relatedBy: .equal, toItem: roundedExpandingTextView, attribute: .centerX, multiplier: 1.0, constant: 20.0)
        
        //roundedExpandingTextViewTopConstraint = fillerConstraint
        //roundedExpandingTextViewBottomConstraint = fillerConstraint
        //roundedExpandingTextViewLeadingConstraint = fillerConstraint
        //roundedExpandingTextViewTrailingConstraint = fillerConstraint
        //roundedExpandingTextViewWidthConstraint = fillerConstraint
        //roundedExpandingTextViewHeightConstraint = fillerConstraint
        
        
        guard
            let top = roundedExpandingTextViewTopConstraint,
            let bottom = roundedExpandingTextViewBottomConstraint,
            let leading = roundedExpandingTextViewLeadingConstraint,
            let trailing = roundedExpandingTextViewTrailingConstraint,
            let width = roundedExpandingTextViewWidthConstraint,
            let height = roundedExpandingTextViewHeightConstraint
        else { return }
        
        roundedExpandingTextView.addConstraints([top, bottom, leading, trailing, width, height])
    }
 */
    
    func addTitleTextViewConstraints() {
        titleTextViewTopConstraint = NSLayoutConstraint(item: titleTextView, attribute: .top, relatedBy: .equal, toItem: addClassLabel, attribute: .bottom, multiplier: 1.0, constant: 16.0)
        titleTextViewBottomConstraint = NSLayoutConstraint(item: titleTextView, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1.0, constant: -16.0)
        
        titleTextViewHeightConstraint = titleTextView.heightAnchor.constraint(equalToConstant: 0.0)
        //titleTextViewHeightConstraint?.isActive = true
        
        //NSLayoutConstraint.activate([titleTextViewTopConstraint!, titleTextViewBottomConstraint!])//, titleTextViewHeightConstraint!])//titleTextViewHeightConstraint!])
        [
            titleTextViewTopConstraint!,
            titleTextViewBottomConstraint!
        ].forEach {
            $0.isActive = true
            //$0.priority = UILayoutPriority(500)
        }
        
        //self.addConstraints([titleTextViewTopConstraint!, titleTextViewBottomConstraint!, titleTextViewHeightConstraint!])
        
        [
            titleTextView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20.0),
            titleTextView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20.0)
        ].forEach { $0.isActive = true }
        
        //NSLayoutConstraint.deactivate([titleTextViewHeightConstraint!])
        
        
        //roundedExpandingTextView.removeConstraints(roundedExpandingTextView.constraints) // Remove all constraints
        
        //let animationStateTemp = AnimationState.expanded
        
        //roundedExpandingTextViewTopConstraint = NSLayoutConstraint(item: titleTextView, attribute: .top, relatedBy: .equal, toItem: addClassLabel, attribute: .bottom, multiplier: 1.0, constant: 20.0)
        //roundedExpandingTextViewBottomConstraint = NSLayoutConstraint(item: titleTextView, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1.0, constant: -20.0)
        /*
        switch animationStateTemp {
        case .expanded:
            
            [
                titleTextView.topAnchor.constraint(equalTo: addClassLabel.bottomAnchor, constant: 20.0),
                titleTextView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16.0),
                titleTextView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20.0),
                titleTextView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20.0),
                //titleTextView.widthAnchor.constraint(equalToConstant: 100.0),
                titleTextView.heightAnchor.constraint(equalToConstant: 0.0)
            ].forEach { $0.isActive = true }
            //roundedExpandingTextView.heightAnchor.constraint(equalToConstant: 0.0).isActive = false
            //roundedExpandingTextView.widthAnchor.constraint(equalToConstant: 0.0).isActive = false
 
            
            
            /*
            //roundedExpandingTextViewBottomConstraint = NSLayoutConstraint(item: roundedExpandingTextView, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1.0, constant: -20.0)
            roundedExpandingTextViewLeadingConstraint = NSLayoutConstraint(item: roundedExpandingTextView, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1.0, constant: 20.0)
            roundedExpandingTextViewTrailingConstraint = NSLayoutConstraint(item: roundedExpandingTextView, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1.0, constant: -20.0)
            
            if let width = roundedExpandingTextViewWidthConstraint { roundedExpandingTextView.removeConstraint(width) }
            if let height = roundedExpandingTextViewHeightConstraint { roundedExpandingTextView.removeConstraint(height) }
            
            roundedExpandingTextView.layer.opacity = 1.0
 */
        case .expanding:
            /*
            [
                roundedExpandingTextView.topAnchor.constraint(equalTo: addClassLabel.bottomAnchor, constant: 20.0),
                roundedExpandingTextView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20.0),
                roundedExpandingTextView.widthAnchor.constraint(equalToConstant: 120.0),
                roundedExpandingTextView.heightAnchor.constraint(equalToConstant: 0.0)
            ]
 */
            //roundedExpandingTextViewTopConstraint = NSLayoutConstraint(item: titleTextView, attribute: .top, relatedBy: .equal, toItem: addClassLabel, attribute: .bottom, multiplier: 1.0, constant: 20.0)
            //roundedExpandingTextViewBottomConstraint = NSLayoutConstraint(item: roundedExpandingTextView, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1.0, constant: -20.0)
            //roundedExpandingTextViewWidthConstraint = NSLayoutConstraint(item: titleTextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 120.0)
            
            //if let leading = roundedExpandingTextViewLeadingConstraint { titleTextView.removeConstraint(leading) }
            //if let trailing = roundedExpandingTextViewTrailingConstraint { titleTextView.removeConstraint(trailing) }
            
            //titleTextView.layer.opacity = 0.0
        case .hidden:
            
            /*
            [
                roundedExpandingTextView.topAnchor.constraint(equalTo: addClassLabel.bottomAnchor, constant: 20.0),
                roundedExpandingTextView.widthAnchor.constraint(equalToConstant: 0.0),
                roundedExpandingTextView.heightAnchor.constraint(equalToConstant: 0.0)
            ]
 */
            //roundedExpandingTextViewTopConstraint = NSLayoutConstraint(item: roundedExpandingTextView, attribute: .top, relatedBy: .equal, toItem: addClassLabel, attribute: .bottom, multiplier: 1.0, constant: 20.0)
            //roundedExpandingTextViewWidthConstraint = NSLayoutConstraint(item: titleTextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0.0)
            //roundedExpandingTextViewHeightConstraint = NSLayoutConstraint(item: titleTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.0)
            
            //if let leading = roundedExpandingTextViewLeadingConstraint { titleTextView.removeConstraint(leading) }
            //if let trailing = roundedExpandingTextViewTrailingConstraint { titleTextView.removeConstraint(trailing) }
 
            //titleTextView.layer.opacity = 0.0
        }
        
        //constraints.forEach { $0.isActive = true }
 */
    }
    
    /*
    enum AnimationState {
        case hidden, expanding, expanded
        
        // hidden is when the view isn't shown (typically with width & height = 0)
        // expanding is at the start of the expansion animation
        // expanded is at the end of the expansion animation; when the view is completely shown
    }
 */
}
