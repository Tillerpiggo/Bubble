//
//  ProgrammaticProgressBarView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/15/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class ProgrammaticProgressBarView: ProgrammaticView {
    
    var widthConstraint: NSLayoutConstraint?
    
    var progress: CGFloat = 0.0
    var color: UIColor = .darkGray {
        didSet {
            updateColor()
        }
    }
    
    private var secondaryColor: UIColor {
        return color.with(hueChange: 20 * progress)
    }
    var barBackgroundColor: UIColor {
        return secondaryColor.withAlphaComponent(0.5)
    }
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = barBackgroundColor
        backgroundView.layer.cornerRadius = 5
        backgroundView.layer.masksToBounds = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        return backgroundView
    }()
    
    private lazy var progressView: UIView = {
        let progressView = UIView()
        progressView.backgroundColor = color
        progressView.layer.cornerRadius = 5
        progressView.layer.masksToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    // Progress must be from 0 to 1
    func setProgress(to progress: CGFloat, animated: Bool) {
        var boundedProgress = progress
        if boundedProgress < 0.0 { boundedProgress = 0 }
        if boundedProgress > 1.0 { boundedProgress = 1.0 }
        
        /*
        if animated {
            UIView.animate(withDuration: 0.5) { [unowned self] in
                DispatchQueue.main.async { self.widthConstraint!.constant = self.bounds.width * progress }
            }
        } else {
            widthConstraint!.constant = self.bounds.width * progress
        }
 */
        let widthConstraint = NSLayoutConstraint(item: progressView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: boundedProgress, constant: 0)
        
        if animated {
            // animated progress bar change
            
            UIView.animate(withDuration: 0.5) { [unowned self] in
                DispatchQueue.main.async { self.addConstraint(widthConstraint) }
            }
        } else {
            // set progress and update view
            self.addConstraint(widthConstraint)
        }
    }
    
    override func setupView() {
        addSubview(backgroundView)
        backgroundView.addSubview(progressView)
        
        addConstraints()
    }
    
    func addConstraints() {
        pinEdgesToView(backgroundView)
        progressView.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        progressView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor).isActive = true
    }
    
    private func updateColor() {
        backgroundView.backgroundColor = barBackgroundColor
        progressView.backgroundColor = color
    }
}
