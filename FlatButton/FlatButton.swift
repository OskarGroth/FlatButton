//
//  FlatButton.swift
//  Disk Sensei
//
//  Created by Oskar Groth on 02/08/16.
//  Copyright © 2016 Cindori. All rights reserved.
//

import Cocoa
import CoreGraphics

class FlatButton: NSButton {
    
    private var titleLayer = CATextLayer()
    private var mouseDown = Bool()
    private var alternateColor = NSColor()
    
    @IBInspectable var fill: Bool = false
    @IBInspectable var momentary: Bool = false
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            layer?.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var color: NSColor = NSColor.blue {
        didSet {
            alternateColor = color.darker()
            if fill {
                layer?.backgroundColor = color.cgColor
                layer?.borderColor = NSColor.clear.cgColor
            } else {
                titleLayer.foregroundColor = color.cgColor
                layer?.borderColor = color.cgColor
            }
            animateColor(isOn: state == NSOnState)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
        layer?.cornerRadius = 4
        layer?.borderWidth = 1
        layer?.delegate = LayerDelegate.shared
        titleLayer.delegate = LayerDelegate.shared
        let attributes = [NSFontAttributeName: font!]
        let size = title.size(withAttributes: attributes)
        titleLayer.frame = NSMakeRect(round((layer!.frame.width-size.width)/2), round((layer!.frame.height-size.height)/2), size.width, size.height)
        titleLayer.string = title
        titleLayer.font = font
        titleLayer.fontSize = font!.pointSize
        layer?.addSublayer(titleLayer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer?.contentsScale = LayerDelegate.shared.scale(sender: self)
        titleLayer.contentsScale = LayerDelegate.shared.scale(sender: self)
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    func animateColor(isOn: Bool) {
        layer?.removeAllAnimations()
        titleLayer.removeAllAnimations()
        let duration = isOn ? 0.01 : 0.1

        var bgColor = (fill || isOn) ? color.cgColor : NSColor.clear.cgColor
        if fill && isOn {
            bgColor = alternateColor.cgColor
            
        }
        if layer?.backgroundColor != bgColor {
            let animation = CABasicAnimation(keyPath: "backgroundColor")
            animation.toValue = bgColor
            animation.fromValue = layer?.backgroundColor
            animation.duration = duration
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            layer?.add(animation, forKey: "ColorAnimation")
            layer?.backgroundColor = (animation.toValue as! CGColor?)
        }
        let titleColor = fill || isOn ? NSColor.white.cgColor : color.cgColor
        if titleLayer.foregroundColor != titleColor {
            let animation = CABasicAnimation(keyPath: "foregroundColor")
            animation.toValue = titleColor
            animation.fromValue = titleLayer.foregroundColor
            animation.duration = duration
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            titleLayer.add(animation, forKey: "titleAnimation")
            titleLayer.foregroundColor = (animation.toValue as! CGColor?)
        }
    }
    
    func setOn(isOn: Bool) {
        let nextState = isOn ? NSOnState : NSOffState
        if nextState != state {
            state = nextState
            animateColor(isOn: state == NSOnState)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if !isEnabled {
            return
        }
        mouseDown = true
        setOn(isOn: state == NSOnState ? false : true)
    }
    
    override func mouseEntered(with event: NSEvent) {
        if mouseDown {
            setOn(isOn: state == NSOnState ? false : true)
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        if mouseDown {
            setOn(isOn: state == NSOnState ? false : true)
            mouseDown = false
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if mouseDown {
            if momentary {
                setOn(isOn: state == NSOnState ? false : true)
            }
            _ = target?.perform(action, with: self)
            mouseDown = false
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        // Nothing here
    }
    
}
