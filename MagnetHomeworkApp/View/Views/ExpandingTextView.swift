//
//  ExpandingTextView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/21/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

// This is my custom textField with a rounded background and customization how I like it. It's just a textField with a background UIView...
// It's just made for easy reusability and consistency throughout the app

// A protocol for views that change in size.
// TODO: - move this to a better location
protocol DynamicViewDelegate {
    func sizeChanged()
}

class ExpandingTextView: ProgrammaticView {
    
    // MARK: - Subviews
    var delegate: UITextViewDelegate?
    var dynamicViewDelegate: DynamicViewDelegate?
    var padding: CGFloat = 0
    private var lastEstimatedSize: CGSize?
    
    private lazy var textView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.isScrollEnabled = false
        textView.textColor = UIColor(white: 0.3, alpha: 1.0)
        textView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        textView.delegate = self
        textView.returnKeyType = .done
        
        return textView
    }()
    
    // Text field wrapper functions:
    var placeholder: String? {
        get {
            return textView.placeholder
        }
        set {
            textView.placeholder = newValue
        }
    }
    
    override func setupView() {
        addSubviews()
        addConstraints()
    }
    
    /*
    override func layoutSubviews() {
        setVisuals()
    }
 */
    
    /// Clears all text and updates the layout of the textView
    func clear() {
        textView.text = ""
        textView.setNeedsLayout()
    }
    
    /// Becomes first responder; shows keyboard
    func select() {
        textView.becomeFirstResponder()
    }
    
    /// Resigns first responder; dismisses keyboard
    func dismiss() {
        textView.resignFirstResponder()
    }

    var text: String {
        get {
            return textView.text
        }
        
        set {
            textView.text = newValue
        }
    }
    
    var font: UIFont? {
        get {
            return textView.font
        }
        
        set {
            textView.font = newValue
        }
    }
    
    var textColor: UIColor? {
        get {
            return textView.textColor
        }
        
        set {
            textView.textColor = newValue
        }
    }
}

// MARK: - UITextFieldDelegate
extension ExpandingTextView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("editing...")
    }
}

// MARK: - Helper functions
fileprivate extension ExpandingTextView {
    
    func addSubviews() {
        addSubview(textView)
    }
    
    func addConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        /*
        // Array of constraints
        [
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6.0),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6.0),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: padding),
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: -1.0 * padding),
        ].forEach { $0.isActive = true }
 */
        
        textView.addConstraints(
            top: self.topAnchor, topConstant: padding,
            bottom: self.bottomAnchor, bottomConstant: padding,
            leading: self.leadingAnchor, leadingConstant: padding,
            trailing: self.trailingAnchor, trailingConstant: 6.0)
            
        textViewDidChange(textView)
    }
    
    /*
    func setVisuals() {
        // This is doing most of the work that sets this view apart from UITextField
        
        // Round corners
        layer.cornerRadius = 12
        clipsToBounds = true
        
        // Set background color
        backgroundColor = UIColor(white: 0.971, alpha: 1.0)
    }
 */
    
}

// Shoutout to https://www.youtube.com/watch?v=0Jb29c22xu8 - Let's Build That App
extension ExpandingTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        
        // Get the height of the text view
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                //let constantDidChange = (constraint.constant != estimatedSize.height)
                
                constraint.constant = estimatedSize.height
                
                
                
                
                // Animate the change
                UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: { [unowned self] in
                    self.superview?.layoutIfNeeded()
                })
                
                if let lastEstimatedSize = lastEstimatedSize {
                    if estimatedSize != lastEstimatedSize {
                        dynamicViewDelegate?.sizeChanged()
                    }
                } else { // If there is no lastEstimatedSize (this is the first time), might as well update just to be thorough
                    dynamicViewDelegate?.sizeChanged()
                }
                
                print("estimatedSize.height: \(estimatedSize.height)")
            }
        }
        
        lastEstimatedSize = estimatedSize
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing?(textView)
    }
}

class RoundedExpandingTextView: ExpandingTextView {
    override func layoutSubviews() {
        // Round corners
        layer.cornerRadius = 12
        clipsToBounds = true
        
        // Set background color
        backgroundColor = UIColor(white: 0.971, alpha: 1.0)
    }
}
