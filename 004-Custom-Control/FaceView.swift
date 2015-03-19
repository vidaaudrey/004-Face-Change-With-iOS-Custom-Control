//
//  FaceView.swift
//  Happiness
//
//  Created by Audrey Li on 2/5/15.
//  Copyright (c) 2015 Shomigo. All rights reserved.
//

import UIKit

protocol FaceViewDataSourceDelegate: class {
    func getSmiliness(sender: FaceView) -> Double
    func getLineWidth(sender: FaceView) -> CGFloat
    func getColor(sender: FaceView) -> UIColor
}

@IBDesignable
class FaceView: UIView {
   @IBInspectable
    var lineWidth: CGFloat = 16 { didSet { setNeedsDisplay()}}
    @IBInspectable
    var color: UIColor = UIColor.blueColor(){ didSet {setNeedsDisplay()}}
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
 
    // declare the datasource delegate 
    var dataSource: FaceViewDataSourceDelegate?
    
    
    var faceCenter: CGPoint{
        return convertPoint(center, fromView: superview)
    }
    var faceRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height) / 2  * scale
    
    }

    private struct Scaleing {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRation: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye (whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Scaleing.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaleing.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaleing.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        let path = UIBezierPath (arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat (2*M_PI), clockwise: true)
        path.lineWidth = dataSource?.getLineWidth(self) ?? lineWidth
        return path
    }
    
    private func bezierPathForSmile (fractionOfMaxSmile: Double) -> UIBezierPath {
        let mouthWidth = faceRadius / Scaleing.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaleing.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaleing.FaceRadiusToMouthOffsetRation
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint (x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint (x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint (x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = dataSource?.getLineWidth(self) ?? lineWidth
        path.stroke()
        return path
        
    }
    // draw the image
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = dataSource?.getLineWidth(self) ?? lineWidth
        color = dataSource?.getColor(self) ?? color
        color.set()
        facePath.stroke()
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        var smiliness = dataSource?.getSmiliness(self) ?? 0.0 // if it's nil, then returns 0.0 
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
        println(smiliness)
        
    }


}
