//
//  CircularImageView.swift
//  004-Custom-Control
//
//  Created by Audrey Li on 3/18/15.
//  Copyright (c) 2015 Shomigo. All rights reserved.
//

import UIKit

protocol CircularImageViewDataSource: class {
    func getLineWidth(sender: CircularImageView) -> CGFloat
}

class CircularImageView: UIView {
    
    var bgLayer: CAShapeLayer!
    var bgLayerColor: UIColor = UIColor.grayColor()
    var lineWidth: CGFloat = 1.0 {
        didSet {
            setBackgroundLayer()
            setBackgroundImageLayer()
        }
    }
    var imageLayer: CALayer!
    var imageTest: UIImage?
    var image: UIImage?
    
    var dataSource: CircularImageViewDataSource?
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setBackgroundLayer()
//        setBackgroundImageLayer()
//        setImage()
//    }
//    
    override func drawRect(rect: CGRect) {
        lineWidth = dataSource?.getLineWidth(self) ?? 2.0
        
        
//        let rect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
//        println("dx= \(rect.width)")
//        let path = UIBezierPath(ovalInRect: rect)
//        UIColor.orangeColor().set()
//        path.stroke()
       
        setBackgroundLayer()
        setBackgroundImageLayer()
        setImage()
       
        
        println("DrawRect called \(lineWidth)")
    }
    func setBackgroundLayer() {
        if bgLayer == nil {
            bgLayer = CAShapeLayer()
            layer.addSublayer(bgLayer)
            let rect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
               println("dx= \(rect.width)")
            let path = UIBezierPath(ovalInRect: rect)
            bgLayer.path = path.CGPath
            bgLayer.lineWidth = lineWidth
            bgLayer.fillColor = bgLayerColor.CGColor
            
            // fill with a shadow 
            bgLayer.masksToBounds = false
            bgLayer.shadowColor = UIColor.grayColor().CGColor
            bgLayer.shadowOffset = CGSize(width: 0.0, height: -3.0)
            bgLayer.shadowOpacity = 0.9
            bgLayer.shadowPath = path.CGPath
            
        }
        bgLayer.frame = layer.bounds
    }
    
    func setBackgroundImageLayer() {
        if imageLayer == nil {
            let mask = CAShapeLayer()
            let dx = lineWidth + 4.0
            println("dx= \(dx)")
            let path = UIBezierPath(ovalInRect: CGRectInset(self.bounds, dx, dx))
            mask.fillColor = UIColor.blackColor().CGColor
            mask.path = path.CGPath
            mask.frame = self.bounds
            layer.addSublayer(mask)
            
            imageLayer = CAShapeLayer()
            imageLayer.frame = self.bounds
            imageLayer.mask = mask
            imageLayer.contentsGravity = kCAGravityResizeAspectFill
            if let pic = image {
                imageLayer.contents = pic.CGImage
            }
            layer.addSublayer(imageLayer)
            
        }
    }
    
    func setImage() {
        if imageLayer != nil {
            if let pic = image {
                imageLayer.contents = pic.CGImage
            } else if let pic = imageTest {
                imageLayer.contents = pic.CGImage
            }
        }
    }
}

