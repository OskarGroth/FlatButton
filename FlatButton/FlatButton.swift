//
//  FlatButton.swift
//  Disk Sensei
//
//  Created by Oskar Groth on 02/08/16.
//  Copyright © 2016 Cindori. All rights reserved.
//

import Cocoa
import QuartzCore

public class FlatButton: NSButton {
    
    internal var titleLayer = CATextLayer()
    internal var mouseDown = Bool()
    public var alternateColor = NSColor()
    @IBInspectable public var fill: Bool = false {
        didSet {
            animateColor(state == NSOnState)
        }
    }
    @IBInspectable public var momentary: Bool = true {
        didSet {
            animateColor(state == NSOnState)
        }
    }
    @IBInspectable public var cornerRadius: CGFloat = 4 {
        didSet {
            layer?.cornerRadius = cornerRadius
        }
    }
    @IBInspectable public var borderWidth: CGFloat = 1 {
        didSet {
            layer?.borderWidth = borderWidth
        }
    }
    @IBInspectable public var color: NSColor = NSColor.blueColor() {
        didSet {
            alternateColor = tintColor(color)
            animateColor(state == NSOnState)
        }
    }
    override public var title: String {
        didSet {
            setupTitle()
        }
    }
    override public var font: NSFont? {
        didSet {
            setupTitle()
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal func setupTitle() {
        let attributes = [NSFontAttributeName: font!]
        let size = (title as NSString).sizeWithAttributes(attributes)
        titleLayer.frame = NSMakeRect(round((layer!.frame.width-size.width)/2), round((layer!.frame.height-size.height)/2), size.width, size.height)
        titleLayer.string = title
        titleLayer.font = font
        titleLayer.fontSize = font!.pointSize
    }
    
    internal func setup() {
        wantsLayer = true
        layer?.masksToBounds = true
        layer?.cornerRadius = 4
        layer?.borderWidth = 1
        layer?.delegate = self
        titleLayer.delegate = self
        layer?.addSublayer(titleLayer)
        setupTitle()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        let trackingArea = NSTrackingArea(rect: bounds, options: [.ActiveAlways, .MouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    public func animateColor(isOn: Bool) {
        layer?.removeAllAnimations()
        titleLayer.removeAllAnimations()
        let duration = isOn ? 0.01 : 0.1
        var bgColor = fill || isOn ? color.CGColor : NSColor.clearColor().CGColor
        if fill && isOn {
            bgColor = alternateColor.CGColor
        }
        if !CGColorEqualToColor(layer?.backgroundColor, bgColor) {
            let animation = CABasicAnimation(keyPath: "backgroundColor")
            animation.toValue = bgColor
            animation.fromValue = layer?.backgroundColor
            animation.duration = duration
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            layer?.addAnimation(animation, forKey: "ColorAnimation")
            layer?.backgroundColor = (animation.toValue as! CGColor?)
        }
        let titleColor = fill || isOn ? NSColor.whiteColor().CGColor : color.CGColor
        if !CGColorEqualToColor(titleLayer.foregroundColor, titleColor) {
            let animation = CABasicAnimation(keyPath: "foregroundColor")
            animation.toValue = titleColor
            animation.fromValue = titleLayer.foregroundColor
            animation.duration = duration
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            titleLayer.addAnimation(animation, forKey: "titleAnimation")
            titleLayer.foregroundColor = (animation.toValue as! CGColor?)
        }
        let borderColor = fill || isOn ? bgColor : color.CGColor
        if !CGColorEqualToColor(layer?.borderColor, borderColor) {
            let animation = CABasicAnimation(keyPath: "borderColor")
            animation.toValue = borderColor
            animation.fromValue = layer?.borderColor
            animation.duration = duration
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            layer?.addAnimation(animation, forKey: "borderAnimation")
            layer?.borderColor = (animation.toValue as! CGColor?)
        }
    }
    
    public func setOn(isOn: Bool) {
        let nextState = isOn ? NSOnState : NSOffState
        if nextState != state {
            state = nextState
            animateColor(state == NSOnState)
        }
    }
    
    override public func mouseDown(event: NSEvent) {
        if !enabled {
            return
        }
        mouseDown = true
        setOn(state == NSOnState ? false : true)
    }
    
    override public func mouseEntered(event: NSEvent) {
        if mouseDown {
            setOn(state == NSOnState ? false : true)
        }
    }
    
    override public func mouseExited(event: NSEvent) {
        if mouseDown {
            setOn(state == NSOnState ? false : true)
            mouseDown = false
        }
    }
    
    override public func mouseUp(event: NSEvent) {
        if mouseDown {
            if momentary {
                setOn(state == NSOnState ? false : true)
            }
            target?.performSelector(action)
            mouseDown = false
        }
    }
    
    internal func tintColor(color: NSColor) -> NSColor {
        var h = CGFloat(), s = CGFloat(), b = CGFloat(), a = CGFloat()
        let rgbColor = color.colorUsingColorSpaceName(NSCalibratedRGBColorSpace)
        rgbColor?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return NSColor(hue: h, saturation: s, brightness: b == 0 ? 0.2 : b * 0.8, alpha: a)
    }
    
    override public func layer(layer: CALayer, shouldInheritContentsScale newScale: CGFloat, fromWindow window: NSWindow) -> Bool {
        return true
    }
    
    override public func drawRect(dirtyRect: NSRect) {
        
    }
    
}
