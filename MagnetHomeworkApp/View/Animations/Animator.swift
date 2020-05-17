//
//  Animator.swift
//  Bubble
//
//  Created by Tyler Gee on 5/16/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import Foundation
import UIKit

// Animates a view with a spring animation
class Animator {
    var chargeStartUpTime: DispatchTime?
    
    func animateSpringChargeUp(on view: UIView) {
        chargeStartUpTime = DispatchTime.now()
        
        UIView.animate(withDuration: 0.23, delay: 0.0, options: .curveEaseOut, animations: {
            let shrinkTransform = CGAffineTransform(scaleX: 0.88, y: 0.88)
            view.transform = shrinkTransform
        })
    }
    
    func animateSpringRelease(on view: UIView) {
        var releaseTimeInNanoseconds: UInt64
        if let chargeStartUpTime = chargeStartUpTime {
            releaseTimeInNanoseconds = chargeStartUpTime.uptimeNanoseconds
        } else {
            releaseTimeInNanoseconds = 0
        }
        
        // In seconds
        let releaseTime = Double(releaseTimeInNanoseconds) / Double(NSEC_PER_SEC)
        
        let percentCharged = (-1 * exp(0.8 + -1.5 * releaseTime)) / 1.8
        
        UIView.animate(withDuration: 0.2 * percentCharged, delay: 0.0, options: .curveEaseOut, animations: {
            let expandTransform = CGAffineTransform(scaleX: CGFloat(1.01 * percentCharged), y: CGFloat(1.01 * percentCharged))
            view.transform = expandTransform
        }, completion: { (bool) in
            UIView.animate(withDuration: 0.05 * percentCharged, delay: 0.0, options: .curveEaseIn, animations: {
                view.transform = .identity
            })
        })
    }
    
    func animateSpringGentleRelease(on view: UIView) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            view.transform = .identity
        })
    }
}
