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
    
    static let disabledColor: UIColor = UIColor(white: 0.825, alpha: 1.0)
    
    fileprivate let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        
        // Round corners
        backgroundView.layer.cornerRadius = 16
        backgroundView.layer.masksToBounds = true
        
        // Add shadow
        backgroundView.addDropShadow(color: .black, opacity: 0.25, radius: 18)
        
        return backgroundView
    }()
    
    fileprivate let addClassLabel: UILabel = {
        let addClassLabel = UILabel()
        addClassLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addClassLabel.text = "Add Class"
        addClassLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        addClassLabel.textColor = UIColor(white: 0.23, alpha: 1.0)
        addClassLabel.textAlignment = .center
        
        return addClassLabel
    }()
    
    // Detects if you press this view while it's a button
    fileprivate let addClassButton: UIButton = {
        let addClassButton = UIButton()
        addClassButton.translatesAutoresizingMaskIntoConstraints = false
        
        addClassButton.addTarget(self, action: #selector(addClassButtonPressed), for: .touchUpInside)
        
        return addClassButton
    }()
    
    private let cancelButton: BouncyButton = {
        let cancelButton = BouncyButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let enabledCancelText = NSAttributedString(string: "Cancel", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .regular), .foregroundColor: UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)])
        let disabledCancelText = NSAttributedString(string: "Cancel", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .regular), .foregroundColor: disabledColor])
        cancelButton.setAttributedTitle(enabledCancelText, for: .normal)
        cancelButton.setAttributedTitle(disabledCancelText, for: .disabled)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        return cancelButton
    }()
    
    private let doneButton: BouncyButton = {
        let doneButton = BouncyButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        let enabledDoneText = NSAttributedString(string: "Done", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)])
        let disabledDoneText = NSAttributedString(string: "Done", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: disabledColor])
        doneButton.setAttributedTitle(enabledDoneText, for: .normal)
        doneButton.setAttributedTitle(enabledDoneText, for: .disabled)
        
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        return doneButton
    }()
    
    private lazy var roundedExpandingTextView: RoundedExpandingTextView = {
        let roundedExpandingTextView = RoundedExpandingTextView()
        roundedExpandingTextView.translatesAutoresizingMaskIntoConstraints = false
        
        roundedExpandingTextView.delegate = self
        
        return roundedExpandingTextView
    }()
    
    override func setupView() {
        addSubviews()
        addConstraints()
    }
}

// MARK: - UITextViewDelegate
extension ProgrammaticAddClassView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        className = textView.text
    }
}

// MARK: - Actions
fileprivate extension ProgrammaticAddClassView {
    @objc func addClassButtonPressed() {
        
    }
    
    @objc func cancelButtonPressed() {
        
    }
    
    @objc func doneButtonPressed() {
        
    }
}

// MARK: - Helper methods
fileprivate extension ProgrammaticAddClassView {
    
    // MARK: - Add Subviews
    func addSubviews() {
        addSubview(backgroundView)
        backgroundView.addSubview(addClassLabel)
    }
    
    // MARK: - Add Constraints
    func addConstraints() {
        addBackgroundViewConstraints()
        addAddClassLabelConstraints()
    }
    
    func addBackgroundViewConstraints() {
        [
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 48.0) // Margins of 24.0 on each side
        ].forEach { $0.isActive = true }
    }
    
    func addAddClassLabelConstraints() {
        
        /*
        [
            addClassLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            addClassLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ].forEach { $0.isActive = true }
 */
        
        [
            addClassLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20.0),
            addClassLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),
            addClassLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12.0),
            addClassLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12.0),
        ].forEach { $0.isActive = true }
    }
    
    // MARK: - Expand and shrink
    
    // Expand to show everything
    func expand() {
        // Increase height
        
    }
    
    // Only show the "Add Class" label
    func shrink() {
        // Decrease height
    }
}
