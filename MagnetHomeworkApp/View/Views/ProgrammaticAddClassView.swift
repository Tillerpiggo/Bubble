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
    func didExpand()
    func didShrink()
}

class ProgrammaticAddClassView: ProgrammaticView {
    
    var className: String?
    var delegate: ProgrammaticAddClassViewDelegate?
    //var dynamicViewDelegate: DynamicViewDelegate?
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
        backgroundView.addDropShadow(color: .black, opacity: 0.10, radius: 8)
        
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
        expandButton.backgroundColor = .blue
        
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
        titleTextView.delegate = self
        titleTextView.isHidden = true
        titleTextView.layer.opacity = 0.0
        
        return titleTextView
    }()
    
    override func setupView() {
        addSubviews()
        
        cancelButton.delegate = self
        doneButton.delegate = self
        
        let zeroSizeTransform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        self.cancelButton.transform = zeroSizeTransform
        self.doneButton.transform = zeroSizeTransform
    }
    
    override func didMoveToSuperview() {
        addConstraints()
        //titleTextViewHeightConstraint?.isActive = true
    }
    
    // MARK: - Expand and shrink
    
    // Expand to show everything
    func expand() {
        print("isExpanded: \(isExpanded)")
        guard !isExpanded else { return }
        self.isExpanded = true
        
        print("expanded!!!")
        
        let partialSizeTransform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        self.cancelButton.transform = partialSizeTransform
        self.doneButton.transform = partialSizeTransform
        
        self.cancelButton.layer.opacity = 0.0
        self.doneButton.layer.opacity = 0.0
        
        
        self.cancelButton.isHidden = false
        self.doneButton.isHidden = false
        self.titleTextView.isHidden = false
        
        self.expandButton.isEnabled = false
        //layoutIfNeeded()
        //setNeedsLayout()
        
        self.delegate?.didExpand()
        
        // Increase height
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.cancelButton.transform = .identity
            self.cancelButton.layer.opacity = 1.0
            self.doneButton.transform = .identity
            self.doneButton.layer.opacity = 1.0
            self.titleTextView.layer.opacity = 1.0
            
        }, completion: { (bool) in
        })
    }
    
    // Only show the "Add Class" label
    func shrink() {
        print("isExpanded: \(isExpanded)")
        guard isExpanded else { return }
        
        self.expandButton.isEnabled = true
        
        
        
        //self.addClassLabelCenterYConstraint?.isActive = true
        
        
        
        // Decrease height
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.cancelButton.layer.opacity = 0.0
            self.doneButton.layer.opacity = 0.0
            self.titleTextView.layer.opacity = 0.0
            
            //self.dynamicViewDelegate?.sizeChanged()
            //self.layoutIfNeeded()
            self.delegate?.didShrink()
            
        }, completion: { (bool) in
            self.isExpanded = false
        })
    }
    
    // MARK: - Constraints
    var titleTextViewTopConstraint, titleTextViewBottomConstraint, titleTextViewHeightConstraint: NSLayoutConstraint?
    //var addClassLabelCenterYConstraint: NSLayoutConstraint?
}

// MARK: - UITextViewDelegate
extension ProgrammaticAddClassView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        className = textView.text
    }
}

/*
// MARK: - DynamicViewDelegate
extension ProgrammaticAddClassView: DynamicViewDelegate {
    func sizeChanged() {
        dynamicViewDelegate?.sizeChanged()
    }
}
 */

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
        
        // idk why this happens but until the first time that it is activated with selectedItemAtIndexPath, it registers as either the done or cancel button being pressed. This is supposed to make it work
        if !isExpanded {
            expand()
            return
        }
        
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
        //self.addSubviews([backgroundView, expandButton])
        self.addSubview(backgroundView)
        
        backgroundView.addSubviews([addClassLabel, titleTextView, cancelButton, doneButton])
    }
    
    // MARK: - Add Constraints
    func addConstraints() {
        addBackgroundViewConstraints()
        //addExpandButtonConstraints()
        
        addAddClassLabelConstraints()
        addCancelButtonConstraints()
        addDoneButtonConstraints()
        addTitleTextViewConstraints()
    }
    
    func addBackgroundViewConstraints() {
        self.pinEdgesToView(backgroundView)
        backgroundView.accessibilityIdentifier = "backgroundView"
        //backgroundView.addConstraints(top: addClassLabel.topAnchor, bottom: nil, leading: cancelButton.leadingAnchor, trailing: doneButton.trailingAnchor, topConstant: -20, bottomConstant: 0, leadingConstant: 0, trailingConstant: 0, widthConstant: nil, heightConstant: nil)
        
        //backgroundView.addConstraints(top: nil, bottom: nil, leading: titleTextView.leadingAnchor, trailing: titleTextView.trailingAnchor, topConstant: 0, bottomConstant: 0, leadingConstant: -20, trailingConstant: -20, widthConstant: nil, heightConstant: nil, priority: 500)
    }
    
    func addAddClassLabelConstraints() {
        //addClassLabel.addConstraints(top: backgroundView.topAnchor, bottom: nil, leading: cancelButton.trailingAnchor, trailing: doneButton.leadingAnchor, topConstant: 20, bottomConstant: 0, leadingConstant: 12, trailingConstant: 12, widthConstant: nil, heightConstant: nil, priority: 999)
        addClassLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20).isActive = true
        addClassLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    }
    
    func addExpandButtonConstraints() {
        //expandButton.pinEdgesToView(self)
        //backgroundView.pinEdgesToView(expandButton, priority: 1000)
        //self.pinEdgesToView(expandButton)
        self.pinEdgesToView(expandButton)
    }
    
    // Random comment change
    
    func addCancelButtonConstraints() {
        //cancelButton.addConstraints(top: nil, bottom: nil, leading: backgroundView.leadingAnchor, trailing: nil, topConstant: 0, bottomConstant: 0, leadingConstant: 0, trailingConstant: 0, widthConstant: nil, heightConstant: nil, priority: 999)
        cancelButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: addClassLabel.centerYAnchor).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 4).isActive = true
    }
    
    func addDoneButtonConstraints() {
        //doneButton.addConstraints(top: nil, bottom: nil, leading: nil, trailing: backgroundView.trailingAnchor, topConstant: 14, bottomConstant: 0, leadingConstant: 0, trailingConstant: 0, widthConstant: nil, heightConstant: nil, priority: 999)
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: addClassLabel.centerYAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
    }
    
    func addTitleTextViewConstraints() {
        //titleTextView.addConstraints(top: nil, bottom: backgroundView.bottomAnchor, leading: backgroundView.leadingAnchor, trailing: backgroundView.trailingAnchor, topConstant: 16, bottomConstant: 16, leadingConstant: 20, trailingConstant: 20, widthConstant: nil, heightConstant: nil, priority: 999)
        //titleTextView.addConstraints(top: addClassLabel.bottomAnchor, bottom: backgroundView.bottomAnchor, leading: backgroundView.leadingAnchor, trailing: backgroundView.trailingAnchor, topConstant: 16, bottomConstant: 16, leadingConstant: 20, trailingConstant: 20, widthConstant: nil, heightConstant: nil, priority: 999)
        //titleTextViewHeightConstraint = titleTextView.heightAnchor.constraint(equalToConstant: 0.0)
        
        titleTextView.topAnchor.constraint(equalTo: addClassLabel.bottomAnchor, constant: 16).isActive = true
        titleTextView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        titleTextView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 56).isActive = true
        print("backgroundView.frame: \(backgroundView.frame)")
        //titleTextView.addConstraints(top: nil, bottom: nil, leading: backgroundView.leadingAnchor, trailing: backgroundView.trailingAnchor, topConstant: 0, bottomConstant: 0, leadingConstant: 0, trailingConstant: 0, widthConstant: nil, heightConstant: nil)
        //titleTextView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16).isActive = true
        //titleTextView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16).isActive = true
    }
}
