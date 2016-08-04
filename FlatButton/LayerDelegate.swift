//
//  LayerDelegate.swift
//  Disk Sensei
//
//  Created by Oskar Groth on 03/08/16.
//  Copyright © 2016 Cindori. All rights reserved.
//

import Cocoa

class LayerDelegate: NSObject, CALayerDelegate {

    static let shared = LayerDelegate()

    override func layer(_ layer: CALayer, shouldInheritContentsScale newScale: CGFloat, from window: NSWindow) -> Bool {
        return true
    }
    
    func scale(sender: AnyObject) -> CGFloat {
        return (sender as! FlatButton).window!.backingScaleFactor
    }
    
}
