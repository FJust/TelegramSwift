//
//  LinearProgressControl.swift
//  TGUIKit
//
//  Created by keepcoder on 28/10/2016.
//  Copyright © 2016 Telegram. All rights reserved.
//

import Cocoa

public class LinearProgressControl: Control {
    
    private var progressView:View!
    private var containerView:Control!
    private var progress:CGFloat = 0
    public var progressHeight:CGFloat
    public var onUserChanged:((Float)->Void)?
    
    public override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        if let onUserChanged = onUserChanged {
            let location = convert(event.locationInWindow, from: nil)
            let progress = Float(location.x / frame.width)
            onUserChanged(progress)
        }
    }
    
    public var interactiveValue:Float {
        if let window = window {
            let location = convert(window.mouseLocationOutsideOfEventStream, from: nil)
            return Float(location.x / frame.width)
        }
        return 0
    }
    
    open override func updateTrackingAreas() {
        super.updateTrackingAreas();
        
        
        if let trackingArea = trackingArea {
            self.removeTrackingArea(trackingArea)
        }
        
        trackingArea = nil
        
        if let _ = window {
            let options:NSTrackingArea.Options = [NSTrackingArea.Options.cursorUpdate, NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.enabledDuringMouseDrag, NSTrackingArea.Options.activeInKeyWindow,NSTrackingArea.Options.inVisibleRect]
            self.trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
            
            self.addTrackingArea(self.trackingArea!)
        }
    }
    
    deinit {
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }
    }
    
    public override var style: ControlStyle {
        set {
            self.progressView.layer?.backgroundColor = newValue.foregroundColor.cgColor
            containerView.style = newValue
        }
        get {
            return super.style
        }
    }
    
    public func set(progress:CGFloat, animated:Bool = false) {
        let progress:CGFloat = progress.isNaN ? 1 : progress
        self.progress = progress
        let size = NSMakeSize(floorToScreenPixels(frame.width * progress), progressHeight)
        progressView.change(size: size, animated: animated)
        progressView.setFrameOrigin(NSMakePoint(0, frame.height - progressHeight))
    }
    

    

    public init(progressHeight:CGFloat = 4) {
        self.progressHeight = progressHeight
        super.init()
        
        initialize()
    }
    
    public override func layout() {
        super.layout()
        progressView.setFrameSize(progressView.frame.width, progressHeight)
        containerView.setFrameOrigin(0, frame.height - containerView.frame.height)
    }
    

    private func initialize() {
        
        containerView = Control(frame:NSMakeRect(0, 0, 0, progressHeight))
        containerView.wantsLayer = true
        containerView.layer?.backgroundColor = style.foregroundColor.cgColor
        addSubview(containerView)

        
        progressView = View(frame:NSMakeRect(0, 0, 0, progressHeight))
        progressView.backgroundColor = style.foregroundColor
        addSubview(progressView)
    }
    
    required public init(frame frameRect: NSRect) {
        self.progressHeight = frameRect.height
        super.init(frame:frameRect)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
