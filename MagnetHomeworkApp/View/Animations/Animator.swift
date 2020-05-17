//
//  Animator.swift
//  Bubble
//
//  Created by Tyler Gee on 5/16/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

// Animator is a cool idea, but it makes everything laggier... I guess I'll have to copy/paste/fine tune values myself from now on.

/*
import Foundation
import UIKit

// Animates a view with a spring animation
class Animator {
    var chargeStartUpTime: DispatchTime?
    
    func animateSpringChargeUp(on view: UIView) {
        chargeStartUpTime = DispatchTime.now()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            let shrinkTransform = CGAffineTransform(scaleX: 0.88, y: 0.88)
            view.transform = shrinkTransform
        })
    }
    
    func animateSpringRelease(on view: UIView) {
        guard let chargeStartUpTime = chargeStartUpTime else { return }
        let releaseTime = DispatchTime.now()
        
        let chargeDurationInNanoseconds: UInt64 = releaseTime.uptimeNanoseconds - chargeStartUpTime.uptimeNanoseconds
        
        // In seconds
        let chargeDuration = Double(chargeDurationInNanoseconds) / Double(NSEC_PER_SEC)
        print("releaseTime: \(chargeDuration)")
        
        let percentCharged = ((-1 * exp(0.8 + -1 * chargeDuration)) + 2.227) / 0.6
        print("PercentCharged: \(percentCharged)")
        
        self.chargeStartUpTime = nil
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            let expandTransform = CGAffineTransform(scaleX: CGFloat(1 + 0.01 * percentCharged), y: CGFloat(1 + 0.01 * percentCharged))
            view.transform = expandTransform
        }, completion: { (bool) in
            UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveEaseIn, animations: {
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
