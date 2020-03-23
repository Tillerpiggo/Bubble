//
//  PlaceholderTextView.swift
//  Bubble
//
//  Created by Tyler Gee on 3/22/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import Foundation
import UIKit

// Simply a textView with built in placeholder text
// Taken (and slightly modified) from this: https://gist.github.com/hlung/c5dda3a0c2087e5ae6c1fce8822c4713

class PlaceholderTextView: UITextView {
    
    // This puts the "placeholder" in placeholderTextView
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.textColor = UIColor(white: 0.837, alpha: 1.0)
        placeholderLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        placeholderLabel.backgroundColor = .clear
        
        // Unless you add it, placeholderLabel.text = ""
        
        return placeholderLabel
    }()
    
    var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
        }
    }
    
    var placeholderTextColor: UIColor {
        get {
            return placeholderLabel.textColor
        }
        set {
            placeholderLabel.textColor = newValue
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if text.isEmpty {
            showPlaceholderLabel()
        } else {
            hidePlaceholderLabel()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

fileprivate extension PlaceholderTextView {
    func setupViews() {
        setupNotificationObserver()
        addSubview(placeholderLabel)
        
        self.font = .systemFont(ofSize: 15, weight: .semibold)
        self.backgroundColor = .clear
        self.textColor = UIColor(white: 0.36, alpha: 1.0)
    }
    
    func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChangeHandler(notification:)),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }
    
    func showPlaceholderLabel() {
        let frame = bounds.inset(by: self.textContainerInset)
        placeholderLabel.frame = frame.offsetBy(dx: 6, dy: 0)
        placeholderLabel.lineBreakMode = self.textContainer.lineBreakMode
        placeholderLabel.textAlignment = self.textAlignment
        placeholderLabel.numberOfLines = self.textContainer.maximumNumberOfLines
        placeholderLabel.isHidden = false
    }
    
    func hidePlaceholderLabel() {
        placeholderLabel.isHidden = true
    }
    
    @objc func textDidChangeHandler(notification: Notification) {
        setNeedsLayout()
    }
}
