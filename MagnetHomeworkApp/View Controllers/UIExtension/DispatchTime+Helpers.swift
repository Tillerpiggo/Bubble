//
//  DispatchTime+Helpers.swift
//  Bubble
//
//  Created by Tyler Gee on 5/16/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import Foundation

extension DispatchTime {
    func differenceInSeconds(fromPreviousTime previousTime: DispatchTime) -> Double {
        
        // Could overflow if time is long enough
        let startTime = previousTime.uptimeNanoseconds
        let endTime = self.uptimeNanoseconds
        
        guard endTime
        
        let difference = endTime - startTime
    }
}
