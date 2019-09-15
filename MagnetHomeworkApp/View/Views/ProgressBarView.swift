//
//  ProgressBarView.swift
//  Bubble
//
//  Created by Tyler Gee on 9/6/19.
//  Copyright © 2019 Beaglepig. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
    
    @IBOutlet weak var progressBarBackgroundView: UIView! // The background. Semi-transparent and changes color to match the end of the progress view.
    @IBOutlet weak var progressView: UIView! // The actual progress (% done).
    
    
    private var progress: CGFloat = 0.0
    var color: UIColor = .darkGray {
        didSet { updateColor() }
    } // Arbitrary default, set color when using
    var cornerRadius: CGFloat = 5
    
    private var secondaryColor: UIColor {
        return color.with(hueChange: 20 * progress)
    }
    var barBackgroundColor: UIColor {
        return secondaryColor.withAlphaComponent(0.5)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setProgress(to progress: CGFloat, isAnimated: Bool) {
        
        print("progress: \(progress)")
        
        let widthConstraint = NSLayoutConstraint(item: progressView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: progress, constant: 0)
        
        if isAnimated {
            // animated progress bar change
            
            UIView.animate(withDuration: 0.5) { [unowned self] in
                DispatchQueue.main.async { self.addConstraint(widthConstraint) }
            }
        } else {
            // set progress and update view
            self.addConstraint(widthConstraint)
        }
    }
    
    func configure() {
        layoutSubviews()
        
        
        setConstraints()
        roundCorners()
        updateColor()
        setProgress(to: progress, isAnimated: false)
    }
    
    private func setConstraints() {
        let views: [String: Any] = ["contentView": self, "progressBarBackgroundView": progressBarBackgroundView, "progressView": progressView]
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[progressBarBackgroundView]-0-|", metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[progressBarBackgroundView]-0-|", metrics: nil, views: views)
        
        let horizontalProgressViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[progressView]", metrics: nil, views: views)
        let verticalProgressViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[progressView]-0-|", metrics: nil, views: views)
        
        let constraints = horizontalConstraints + verticalConstraints + horizontalProgressViewConstraints + verticalProgressViewConstraints
        
        self.addConstraints(constraints)
    }
    
    private func updateColor() {
        progressBarBackgroundView.backgroundColor = .red
        
        // Give gradient
        let gradient = CAGradientLayer()
        
        gradient.frame = progressView.bounds
        gradient.colors = [color, secondaryColor]
        
        //progressView.layer.insertSublayer(gradient, at: 0)
        progressView.backgroundColor = .white
    }
    
    private func roundCorners() {
        // Round corners
        progressBarBackgroundView.layer.cornerRadius = cornerRadius
        progressBarBackgroundView.layer.masksToBounds = true
        progressView.layer.cornerRadius = cornerRadius
        progressView.layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ProgressBarView", owner: self, options: nil)
        self.addSubview(progressBarBackgroundView)
        progressBarBackgroundView.addSubview(progressView)
        //contentView.frame = self.bounds
        //contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        configure()
    }
}
