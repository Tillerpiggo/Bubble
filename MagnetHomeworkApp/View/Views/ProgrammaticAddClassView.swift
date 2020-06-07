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
    func didShrink()
    func didExpand()
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
        cancelButton.isHidden = true
        cancelButton.layer.opacity = 0.0
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        return cancelButton
    }()
    
    private let doneButton: BouncyButton = {
        let doneButton = BouncyButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        let enabledDoneText = NSAttributedString(string: "Done", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: UIColor(red: 0.562, green: 0.711, blue: 1, alpha: 1)])
        let disabledDoneText = NSAttributedString(string: "Done", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: disabledColor])
        doneButton.setAttributedTitle(enabledDoneText, for: .normal)
        doneButton.isHidden = true
        doneButton.layer.opacity = 0.0
        
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        return doneButton
    }()
    
    private lazy var titleTextView: RoundedExpandingTextView = {
        let titleTextView = RoundedExpandingTextView()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.placeholder = "Enter class name..."
        titleTextView.delegate = self
        titleTextView.layer.opacity = 0.0
        titleTextView.isHidden = true
        
        return titleTextView
    }()
    
    private let fillerView: UIView = {
        let fillerView = UIView()
        fillerView.backgroundColor = .clear
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        
        return fillerView
    }()
    
    override func setupView() {
        addSubviews()
        addConstraints()
        
        // Set delegates
        cancelButton.delegate = self
        doneButton.delegate = self
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
        self.cancelButton.layer.opacity = 0.0
        self.doneButton.layer.opacity = 0.0
        
        
        self.cancelButton.isHidden = false
        self.doneButton.isHidden = false
        self.expandButton.isEnabled = false
        self.titleTextView.isHidden = false
        
        // Increase height in sizeForItemAt
        delegate?.didExpand()
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.cancelButton.transform = .identity
            self.cancelButton.layer.opacity = 1.0
            self.doneButton.transform = .identity
            self.doneButton.layer.opacity = 1.0
            
            self.titleTextView.layer.opacity = 1.0
            
            
            //self.dynamicViewDelegate?.sizeChanged()
            //self.layoutIfNeeded()
            
            
            
            
        }, completion: { (bool) in
            //self.dynamicViewDelegate?.sizeChanged()
        })
    }
    
    // Only show the "Add Class" label
    func shrink() {
        print("isExpanded: \(isExpanded)")
        guard isExpanded else { return }
        
        // Decrease height in sizeForItemAt
        delegate?.didShrink()
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.cancelButton.layer.opacity = 0.0
            self.doneButton.layer.opacity = 0.0
            self.titleTextView.layer.opacity = 0.0
            //self.layoutIfNeeded()
            
        }, completion: { (bool) in
            self.isExpanded = false
            self.titleTextView.isHidden = true
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
        addTitleTextViewConstraints()
        //addFillerView()
    }
    
    func addBackgroundViewConstraints() {
        backgroundView.pinEdgesToView(self, withMargin: 16)
    }
    
    func addAddClassLabelConstraints() {
        [
            addClassLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20.0),
            addClassLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ].forEach { $0.isActive = true }
    }
    
    func addExpandButtonConstraints() {
        expandButton.pinEdgesToView(self)
    }
    
    func addCancelButtonConstraints() {
        cancelButton.addConstraints(top: backgroundView.topAnchor, bottom: nil, leading: backgroundView.leadingAnchor, trailing: addClassLabel.leadingAnchor, topConstant: 14, bottomConstant: 0, leadingConstant: 24, trailingConstant: 0, widthConstant: nil, heightConstant: nil, priority: UILayoutPriority(rawValue: 750))
    }
    
    func addDoneButtonConstraints() {
        doneButton.addConstraints(top: backgroundView.topAnchor, bottom: nil, leading: addClassLabel.trailingAnchor, trailing: backgroundView.trailingAnchor, topConstant: 14, bottomConstant: 0, leadingConstant: 0, trailingConstant: 24, widthConstant: nil, heightConstant: nil, priority: UILayoutPriority(rawValue: 750))
    }
    
    func addTitleTextViewConstraints() {
        titleTextView.addConstraints(top: addClassLabel.bottomAnchor, bottom: nil, leading: backgroundView.leadingAnchor, trailing: backgroundView.trailingAnchor, topConstant: 16.0, bottomConstant: 0.0, leadingConstant: 1000.0, trailingConstant: 20.0, widthConstant: nil, heightConstant: nil, priority: UILayoutPriority(rawValue: 750))
    }
    
    func addFillerView() {
        fillerView.addConstraints(top: titleTextView.bottomAnchor, bottom: backgroundView.bottomAnchor, leading: backgroundView.leadingAnchor, trailing: backgroundView.trailingAnchor, topConstant: 0, bottomConstant: 0, leadingConstant: 0, trailingConstant: 0, widthConstant: nil, heightConstant: nil, priority: UILayoutPriority(rawValue: 750))
    }
}
