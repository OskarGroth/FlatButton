//
//  NSColor+Utils.swift
//  FlatButton
//
//  Created by Oskar Groth on 04/08/16.
//  Copyright © 2016 Cindori. All rights reserved.
//

import Cocoa

extension NSColor {
    
    func lighter(amount : CGFloat = 0.25) -> NSColor {
        return hueColorWithBrightnessAmount(amount: 1 + amount)
    }
    
    func darker(amount : CGFloat = 0.25) -> NSColor {
        return hueColorWithBrightnessAmount(amount: 1 - amount)
    }
    
    private func hueColorWithBrightnessAmount(amount: CGFloat) -> NSColor {
        var hue         : CGFloat = 0
        var saturation  : CGFloat = 0
        var brightness  : CGFloat = 0
        var alpha       : CGFloat = 0
        let color = usingColorSpaceName(NSCalibratedRGBColorSpace)
        color?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return NSColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
    }
    
}
