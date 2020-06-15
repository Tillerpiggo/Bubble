//
//  Color.swift
//  Bubble
//
//  Created by Tyler Gee on 6/8/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

/*
// TODO: Integrate this into the class Color { }
struct BubbleColor {
    var color1: UIColor
    var color2: UIColor
    var name: String?
    
    var color: Color?
    
    init(color: UIColor, name: String? = nil, color: Color? = nil) {
        color1 = BubbleColor.colorWithHueOffset(10, initialColor: color)!
        color2 = BubbleColor.colorWithHueOffset(-10, initialColor: color)!
        self.name = name
    }
    
    init(color1: UIColor, color2: UIColor, name: String? = nil, color: Color? = nil) {
        self.color1 = color1
        self.color2 = color2
        self.name = name
    }
    
    // TODO: - move this as part of a UIColor extension
    // This function is modified code from here: https://stackoverflow.com/questions/15428422/how-can-i-modify-a-uicolors-hue-brightness-and-saturation
    static func colorWithHueOffset(_ offset: CGFloat, initialColor color: UIColor) -> UIColor? {
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrightness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0
        
        if color.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrightness, alpha: &currentAlpha) {
            var newHue = currentHue + offset
            
            if newHue < 0 {
                newHue += 1.0
            }
            
            return UIColor(hue: currentHue + offset, saturation: currentSaturation, brightness: currentBrightness, alpha: currentAlpha)
        }
        
        return nil
    }
    
    static var red = BubbleColor(color1: UIColor(red: 1, green: 0.525, blue: 0.525, alpha: 1), color2: UIColor(red: 1, green: 0.682, blue: 0.546, alpha: 1), name: "Red", color: Color(rawValue: 1))
    static var orange = BubbleColor(color1: UIColor(red: 1, green: 0.733, blue: 0.541, alpha: 1), color2: UIColor(red: 1, green: 0.844, blue: 0.541, alpha: 1), name: "Orange")
}
 */
