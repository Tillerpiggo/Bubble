//
//  TextField.swift
//  Bubble
//
//  Created by Tyler Gee on 3/21/20.
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

class RoundedExpandingTextView: ProgrammaticView {
    // MARK: - Subviews
    /*
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Allow this view to handle inputs
        textField.delegate = self
        
        // Set textField visuals:
        
        // Set text properties
        textField.defaultTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]
        textField.textColor = UIColor(white: 0.837, alpha: 1.0)
        
        return textField
    }()
 */
    var delegate: UITextViewDelegate?
    var dynamicViewDelegate: DynamicViewDelegate?
    private var lastEstimatedSize: CGSize?
    
    lazy var textView: PlaceholderTextView = {
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
    
    override func layoutSubviews() {
        setVisuals()
    }
}

// MARK: - UITextFieldDelegate
extension RoundedExpandingTextView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("editing...")
    }
}

// MARK: - Helper functions
fileprivate extension RoundedExpandingTextView {
    
    func addSubviews() {
        addSubview(textView)
    }
    
    func addConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        // Array of constraints
        [
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6.0),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6.0),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        ].forEach { $0.isActive = true }
        
        textViewDidChange(textView)
    }
    
    func setVisuals() {
        // This is doing most of the work that sets this view apart from UITextField
        
        // Round corners
        layer.cornerRadius = 12
        clipsToBounds = true
        
        // Set background color
        backgroundColor = UIColor(white: 0.971, alpha: 1.0)
    }
    
}

// Shoutout to https://www.youtube.com/watch?v=0Jb29c22xu8 - Let's Build That App
extension RoundedExpandingTextView: UITextViewDelegate {
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
