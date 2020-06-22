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
    func addClass(withText text: String, color: Color)
    func didExpand()
    func didShrink()
}

class ProgrammaticAddClassView: ProgrammaticView {
    
    var className: String?
    var delegate: ProgrammaticAddClassViewDelegate?
    var dynamicViewDelegate: DynamicViewDelegate?
    fileprivate var isExpanded: Bool = false
    
    let disabledColor: UIColor = UIColor(white: 0.825, alpha: 1.0)
    
    fileprivate let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        
        // Round corners
        backgroundView.layer.cornerRadius = 18
        backgroundView.layer.masksToBounds = true
        
        // Add shadow
        backgroundView.addDropShadow(color: .black, opacity: 0.08, radius: 5)
        
        return backgroundView
    }()
    
    fileprivate let addClassLabel: UILabel = {
        let addClassLabel = UILabel()
        addClassLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addClassLabel.text = "Add Class"
        addClassLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        addClassLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
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
        cancelButton.setAttributedTitle(enabledCancelText, for: .normal)
        cancelButton.isHidden = true
        cancelButton.layer.opacity = 0.0
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        return cancelButton
    }()
    
    private lazy var doneButton: BouncyButton = {
        let doneButton = BouncyButton()
        let enabledDoneText: NSAttributedString = NSAttributedString(string: "Done", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: UIColor(red: 0.562, green: 0.711, blue: 1, alpha: 1)])
        let disabledDoneText: NSAttributedString = NSAttributedString(string: "Done", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: disabledColor])
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setAttributedTitle(enabledDoneText, for: .normal)
        doneButton.setAttributedTitle(disabledDoneText, for: .disabled)
        doneButton.isHidden = true
        doneButton.layer.opacity = 0.0
        doneButton.isEnabled = false
        
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        return doneButton
    }()
    
    private lazy var titleTextView: RoundedExpandingTextView = {
        let titleTextView = RoundedExpandingTextView()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.placeholder = "Enter class name..."
        titleTextView.delegate = self
        titleTextView.dynamicViewDelegate = self
        titleTextView.isHidden = true
        titleTextView.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleTextView.textColor = UIColor(white: 0.5, alpha: 1.0)
        
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
    
    private lazy var colorPickerView: ColorPickerView = {
        let colorPickerView = ColorPickerView()
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        colorPickerView.backgroundColor = .clear
        colorPickerView.layer.opacity = 0.0
        colorPickerView.isHidden = true
        colorPickerView.delegate = self
        
        return colorPickerView
    }()
    
    // This is the one on the left
    private let colorTitleLabel: UILabel = {
        let colorTitleLabel = UILabel()
        colorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        colorTitleLabel.textColor = UIColor(white: 0.342, alpha: 1.0)
        colorTitleLabel.text = "Color"
        colorTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        colorTitleLabel.textAlignment = .left
        colorTitleLabel.isHidden = true
        colorTitleLabel.layer.opacity = 0.0
        
        return colorTitleLabel
    }()
    
    // This is the one that changes color to match the selectedColor
    private let colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
        colorLabel.text = "None"
        colorLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        colorLabel.textAlignment = .right
        colorLabel.isHidden = true
        colorLabel.layer.opacity = 0.0
        
        return colorLabel
    }()
    
    override func setupView() {
        addSubviews()
        addConstraints()
        
        backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        
        // Set delegates
        cancelButton.delegate = self
        doneButton.delegate = self
        
        let zeroSizeTransform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        self.cancelButton.transform = zeroSizeTransform
        self.doneButton.transform = zeroSizeTransform
    }
    
    override func didMoveToSuperview() {
        addConstraints()
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
        
        // TODO: Refactor this code into a hide([UIView]) function
        self.cancelButton.isHidden = false
        self.doneButton.isHidden = false
        self.titleTextView.isHidden = false
        self.colorPickerView.isHidden = false
        self.colorLabel.isHidden = false
        self.colorTitleLabel.isHidden = false
        
        self.expandButton.isEnabled = false
        
        self.titleTextView.select()
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
            self.colorPickerView.layer.opacity = 1.0
            self.colorLabel.layer.opacity = 1.0
            self.colorTitleLabel.layer.opacity = 1.0
            
            
            
            
        }, completion: { [unowned self] (bool) in
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
            self.colorPickerView.layer.opacity = 0.0
            self.colorLabel.layer.opacity = 0.0
            self.colorTitleLabel.layer.opacity = 0.0
            
            self.delegate?.didShrink()
            
        }, completion: { [unowned self] (bool) in
            self.isExpanded = false
            self.titleTextView.isHidden = true
            self.colorPickerView.isHidden = true
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


// MARK: - DynamicViewDelegate
extension ProgrammaticAddClassView: DynamicViewDelegate {
    func sizeChanged() {
        dynamicViewDelegate?.sizeChanged()
        
        // Since this is called every time the text view is changed:
        updateDoneButton()
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
        titleTextView.dismiss()
        reset()
    }
    
    @objc func doneButtonPressed() {
        shrink() // TODO: Replace this with an animation later
        expandButton.isEnabled = true
        
        // add a class
        delegate?.addClass(withText: titleTextView.text, color: colorPickerView.selectedColor!)
        titleTextView.dismiss()
        reset()
    }
}

// MARK: - ColorPickerViewDelegate
extension ProgrammaticAddClassView: ColorPickerViewDelegate {
    func didSelect(color: Color) {
        changeColorLabel(toColor: color)
        updateDoneButton()
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
        
        backgroundView.addSubviews([addClassLabel, titleTextView, cancelButton, doneButton, colorTitleLabel, colorLabel, colorPickerView])
    }
    
    // MARK: - Add Constraints
    // Note - order matters, some of the constraints are dependent on the values of others
    func addConstraints() {
        addBackgroundViewConstraints()
        //addExpandButtonConstraints()
        
        addAddClassLabelConstraints()
        addCancelButtonConstraints()
        addDoneButtonConstraints()
        addTitleTextViewConstraints()
        addColorPickerCollectionViewConstraints()
        addColorTitleLabelConstraints()
        addColorLabelConstraints()
        addColorTitleLabelConstraints()
    }
    
    func addBackgroundViewConstraints() {
        self.pinEdgesToView(backgroundView)
        backgroundView.accessibilityIdentifier = "backgroundView"
    }
    
    func addAddClassLabelConstraints() {
        addClassLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24).isActive = true
        addClassLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    }
    
    func addExpandButtonConstraints() {
        self.pinEdgesToView(expandButton)
    }
    
    // Random comment change
    
    func addCancelButtonConstraints() {
        cancelButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: addClassLabel.centerYAnchor).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 6).isActive = true
    }
    
    func addDoneButtonConstraints() {
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: addClassLabel.centerYAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -2).isActive = true
    }
    
    func addTitleTextViewConstraints() {
        titleTextView.topAnchor.constraint(equalTo: addClassLabel.bottomAnchor, constant: 24).isActive = true
        titleTextView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        titleTextView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 72).isActive = true
    }
    
    func addColorPickerCollectionViewConstraints() {
        colorPickerView.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 12).isActive = true
        colorPickerView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        colorPickerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 102).isActive = true
        colorPickerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func addColorTitleLabelConstraints() {
        colorTitleLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20).isActive = true
        colorTitleLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 24).isActive = true
        colorTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func addColorLabelConstraints() {
        colorLabel.topAnchor.constraint(equalTo: colorTitleLabel.topAnchor).isActive = true
        colorLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -24).isActive = true
        colorLabel.heightAnchor.constraint(equalTo: colorTitleLabel.heightAnchor).isActive = true
    }
    
    // Other helper methods:
    func changeColorLabel(toColor color: Color) {
        colorLabel.textColor = color.uiColor
        colorLabel.text = color.name
        
        // TODO: - add a fading animation
    }
    
    func updateDoneButton() {
        if titleTextView.text != "", let _ = colorPickerView.selectedColor {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    func reset() {
        doneButton.isEnabled = false
        colorPickerView.deselectAll()
        titleTextView.clear()
        colorLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
        colorLabel.text = "None"
    }
}
