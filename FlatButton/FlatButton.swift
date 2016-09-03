//
//  FlatButton.swift
//  Disk Sensei
//
//  Created by Oskar Groth on 02/08/16.
//  Copyright © 2016 Cindori. All rights reserved.
//

import Cocoa
import QuartzCore

internal extension CALayer {
    internal func animate(color: CGColor, keyPath: String, duration: Double) {
        if value(forKey: keyPath) as! CGColor? != color {
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.toValue = color
            animation.fromValue = value(forKey: keyPath)
            animation.duration = duration
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            add(animation, forKey: keyPath)
            setValue(color, forKey: keyPath)
        }
    }
}

internal extension NSColor {
    internal func tintedColor() -> NSColor {
        var h = CGFloat(), s = CGFloat(), b = CGFloat(), a = CGFloat()
        let rgbColor = usingColorSpaceName(NSCalibratedRGBColorSpace)
        rgbColor?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return NSColor(hue: h, saturation: s, brightness: b == 0 ? 0.2 : b * 0.8, alpha: a)
    }
}

public class FlatButton: NSButton, CALayerDelegate {
    
    internal var iconLayer = CAShapeLayer()
    internal var titleLayer = CATextLayer()
    internal var mouseDown = Bool()
    @IBInspectable public var momentary: Bool = true {
        didSet {
            animateColor(state == NSOnState)
        }
    }
    @IBInspectable public var onAnimationDuration: Double = 0.01
    @IBInspectable public var offAnimationDuration: Double = 0.1
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
    @IBInspectable public var buttonColor: NSColor = NSColor.darkGray {
        didSet {
            animateColor(state == NSOnState)
        }
    }
    @IBInspectable public var activeButtonColor: NSColor = NSColor.white {
        didSet {
            animateColor(state == NSOnState)
        }
    }
    @IBInspectable public var iconColor: NSColor = NSColor.gray {
        didSet {
            animateColor(state == NSOnState)
        }
    }
    @IBInspectable public var activeIconColor: NSColor = NSColor.black {
        didSet {
            animateColor(state == NSOnState)
        }
    }
    @IBInspectable public var textColor: NSColor = NSColor.gray {
        didSet {
            animateColor(state == NSOnState)
        }
    }
    @IBInspectable public var activeTextColor: NSColor = NSColor.gray {
        didSet {
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
    override public var frame: NSRect {
        didSet {
            setupTitle()
        }
    }
    override public var image: NSImage? {
        didSet {
            setupImage()
        }
    }
    
    // MARK: Setup & Initialization
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal func setup() {
        wantsLayer = true
        layer?.masksToBounds = true
        layer?.cornerRadius = 4
        layer?.borderWidth = 1
        layer?.delegate = self
        titleLayer.delegate = self
        iconLayer.delegate = self
        layer?.addSublayer(titleLayer)
        layer?.addSublayer(iconLayer)
        setupTitle()
        setupImage()
    }
    
    internal func setupTitle() {
        if title.characters.count > 0 {
            let attributes = [NSFontAttributeName: font!]
            let size = title.size(withAttributes: attributes)
            titleLayer.frame = NSMakeRect(round((layer!.frame.width-size.width)/2), round((layer!.frame.height-size.height)/2), size.width, size.height)
            titleLayer.string = title
            titleLayer.font = font
            titleLayer.fontSize = font!.pointSize
        }
    }
    
    internal func setupImage() {
        if image != nil {
            let maskLayer = CALayer()
            let imageSize = image!.size
            maskLayer.frame = NSMakeRect(round((bounds.width-imageSize.width)/2), round((bounds.height-imageSize.height)/2), imageSize.width, imageSize.height)
            var imageRect:CGRect = NSMakeRect(0, 0, imageSize.width, imageSize.height)
            let imageRef = image!.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
            maskLayer.contents = imageRef
            iconLayer.frame = bounds
            iconLayer.mask = maskLayer
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    // MARK: Animations

    internal func removeAnimations() {
        layer?.removeAllAnimations()
        for subLayer in (layer?.sublayers)! {
            subLayer.removeAllAnimations()
        }
    }
    
    public func animateColor(_ isOn: Bool) {
        removeAnimations()
        let duration = isOn ? onAnimationDuration : offAnimationDuration
        let bgColor = isOn ? activeButtonColor : buttonColor
        let titleColor = isOn ? activeTextColor : textColor
        let imageColor = isOn ? activeIconColor : iconColor
        let borderColor = bgColor
        layer?.animate(color: bgColor.cgColor, keyPath: "backgroundColor", duration: duration)
        layer?.animate(color: borderColor.cgColor, keyPath: "borderColor", duration: duration)
        titleLayer.animate(color: titleColor.cgColor, keyPath: "foregroundColor", duration: duration)
        iconLayer.animate(color: imageColor.cgColor, keyPath: "backgroundColor", duration: duration)
    }
    
    // MARK: Interaction
    
    public func setOn(_ isOn: Bool) {
        let nextState = isOn ? NSOnState : NSOffState
        if nextState != state {
            state = nextState
            animateColor(state == NSOnState)
        }
    }
    
    override public func mouseDown(with event: NSEvent) {
        if isEnabled {
            mouseDown = true
            setOn(state == NSOnState ? false : true)
        }
    }
    
    override public func mouseEntered(with event: NSEvent) {
        if mouseDown {
            setOn(state == NSOnState ? false : true)
        }
    }
    
    override public func mouseExited(with event: NSEvent) {
        if mouseDown {
            setOn(state == NSOnState ? false : true)
            mouseDown = false
        }
    }
    
    override public func mouseUp(with event: NSEvent) {
        if mouseDown {
            mouseDown = false
            if momentary {
                setOn(state == NSOnState ? false : true)
            }
            _ = target?.perform(action, with: self)
        }
    }
    
    // MARK: Drawing
    
    override public func layer(_ layer: CALayer, shouldInheritContentsScale newScale: CGFloat, from window: NSWindow) -> Bool {
        return true
    }
    
    override public func draw(_ dirtyRect: NSRect) {
        
    }
    
}
