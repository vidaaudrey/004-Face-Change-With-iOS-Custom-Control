//
//  RangeSlider.swift
//  004-Custom-Control
//
//  Created by Audrey Li on 3/17/15.
//  Copyright (c) 2015 Shomigo. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {

    var minValue: Double = 0.0 { didSet { updateLayerFrames() } }
    var maxValue: Double = 1.0 { didSet { updateLayerFrames() } }
    var lowerValue: Double = 0.2 { didSet { updateLayerFrames() } }
    var upperValue: Double = 0.8 { didSet { updateLayerFrames() } }
    
    let trackLayer = RangeSliderTrackLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    
    var previousLocation = CGPoint() // use to track touch location
    
    override var frame: CGRect {
        didSet { updateLayerFrames() }
    }
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) { didSet { trackLayer.setNeedsDisplay() } }
    var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) { didSet { trackLayer.setNeedsDisplay() } }
    var thumbTintColor: UIColor = UIColor.whiteColor() {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    var curvaceousness : CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lowerThumbLayer.rangeSlider = self
        upperThumbLayer.rangeSlider = self
        trackLayer.rangeSlider = self
     
     //   trackLayer.backgroundColor = UIColor.blueColor().CGColor
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        
     //   lowerThumbLayer.backgroundColor = UIColor.greenColor().CGColor
        lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(lowerThumbLayer)
        
     //   upperThumbLayer.backgroundColor = UIColor.greenColor().CGColor
        upperThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(upperThumbLayer)
        
        updateLayerFrames()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.rectByInsetting(dx: 0.0, dy: bounds.height/3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func positionForValue(value: Double) -> Double {
        //Double(bounds.width - thumbWidth)` is the actual length of the slider area, that us the track minus the thumb in UIKit points. Multiplying that with the percentage from before gives us the point value the thumb should be at. Finally, we want to center the thumb at that point, so we add half the thumb width.
        return Double(bounds.width - thumbWidth) * (value - minValue) / (maxValue - minValue) + Double (thumbWidth / 2.0)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        previousLocation = touch.locationInView(self)
        
        // hit test the thumblayers 
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let location = touch.locationInView(self)
        
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maxValue - minValue) * deltaLocation / Double (bounds.width - thumbWidth)
        
        previousLocation = location
        
        //update the values 
        if lowerThumbLayer.highlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minValue, upperValue: upperValue)
        } else if upperThumbLayer.highlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maxValue)
        }
        
        //update UI  This section sets the disabledActions flag inside a CATransaction. This ensures that the changes to the frame for each layer are applied immediately, and not animated. Finally, updateLayerFrames is called to move the thumbs to the correct location.
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
        
        updateLayerFrames()
//        CATransaction.commit()
//        
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }

}
