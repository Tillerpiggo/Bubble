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
    fileprivate var isExpanded: Bool = false
    
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
    
    /*
    // Detects if you press this view while it's a button
    fileprivate let addClassButton: UIButton = {
        let addClassButton = UIButton()
        addClassButton.translatesAutoresizingMaskIntoConstraints = false
        
        addClassButton.addTarget(self, action: #selector(addClassButtonPressed), for: .touchUpInside)
        addClassButton.backgroundColor = .blue
        
        return addClassButton
    }()
 */
    
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
    
    private lazy var roundedExpandingTextView: RoundedExpandingTextView = {
        let roundedExpandingTextView = RoundedExpandingTextView()
        roundedExpandingTextView.translatesAutoresizingMaskIntoConstraints = false
        
        roundedExpandingTextView.delegate = self
        
        return roundedExpandingTextView
    }()
    
    override func setupView() {
        addSubviews()
        addConstraints()
        
        cancelButton.delegate = self
        doneButton.delegate = self
        
        // Since it starts in the shrunken state:
        cancelButton.isHidden = true
        doneButton.isHidden = true
        roundedExpandingTextView.isHidden = true
    }
    
    // MARK: - Expand and shrink
    
    // Expand to show everything
    func expand() {
        guard !isExpanded else { return }
        
        // Increase height
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.cancelButton.isHidden = false
            self.doneButton.isHidden = false
            self.roundedExpandingTextView.isHidden = false
            self.isExpanded = true
        }
    }
    
    // Only show the "Add Class" label
    func shrink() {
        guard isExpanded else { return }
        
        // Decrease height
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.cancelButton.isHidden = true
            self.doneButton.isHidden = true
            self.roundedExpandingTextView.isHidden = true
            self.isExpanded = false
        }
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
        expand()
        //addClassButton.isEnabled = false
    }
    
    @objc func cancelButtonPressed() {
        shrink()
        //addClassButton.isEnabled = true
    }
    
    @objc func doneButtonPressed() {
        shrink() // TODO: Replace this with an animation later
        //addClassButton.isEnabled = true
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
    }
}

// MARK: - Helper methods
fileprivate extension ProgrammaticAddClassView {
    
    // MARK: - Add Subviews
    func addSubviews() {
        self.addSubviews([backgroundView])//, addClassButton])
        backgroundView.addSubviews([addClassLabel, cancelButton, doneButton, roundedExpandingTextView])
    }
    
    // MARK: - Add Constraints
    func addConstraints() {
        addBackgroundViewConstraints()
        addAddClassLabelConstraints()
        addAddClassButtonConstraints()
        addCancelButtonConstraints()
        addDoneButtonConstraints()
        addRoundedExpandingTextViewConstraints()
    }
    
    func addBackgroundViewConstraints() {
        backgroundView.pinEdgesToView(self)
        backgroundView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 48.0).isActive = true
    }
    
    func addAddClassLabelConstraints() {
        [
            addClassLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20.0),
            addClassLabel.bottomAnchor.constraint(equalTo: roundedExpandingTextView.topAnchor, constant: -20.0),
            //addClassLabel.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: -20.0),
            addClassLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ].forEach { $0.isActive = true }
    }
    
    func addAddClassButtonConstraints() {
        //addClassButton.pinEdgesToView(self)
    }
    
    func addCancelButtonConstraints() {
        [
            cancelButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20.0),
            cancelButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20.0),
            cancelButton.bottomAnchor.constraint(equalTo: roundedExpandingTextView.topAnchor, constant: -20.0)
        ].forEach { $0.isActive = true }
    }
    
    func addDoneButtonConstraints() {
        [
            doneButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20.0),
            doneButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20.0),
            doneButton.bottomAnchor.constraint(equalTo: roundedExpandingTextView.topAnchor, constant: -20.0)
        ].forEach { $0.isActive = true }
    }
    
    func addRoundedExpandingTextViewConstraints() {
        [
            roundedExpandingTextView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20.0),
            roundedExpandingTextView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20.0),
            roundedExpandingTextView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20.0)
        ].forEach { $0.isActive = true }
    }
}
