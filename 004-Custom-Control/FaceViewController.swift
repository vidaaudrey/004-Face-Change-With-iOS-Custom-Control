//
//  FaceViewController.swift
//  004-Custom-Control
//
//  Created by Audrey Li on 3/18/15.
//  Copyright (c) 2015 Shomigo. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController, FaceViewDataSourceDelegate {

    let rangeSlider = RangeSlider(frame: CGRectZero)
    
    var colors:[UIColor]?
    
    @IBOutlet weak var faceView: FaceView!{
        didSet {
            faceView.dataSource = self
            
        }
    }
    private struct constants {
        static let happinessGestureScale:CGFloat = 4
    }
    
    var lineWidth: CGFloat = 16 {
        didSet { updateUI() }
    }
    // 0 is sad, 100 is very happy
    var happiness: Int = 100 {
        didSet{
            happiness = min(max(happiness, 0), 100)  // make sure it's within the bounds
            updateUI()
        }
    }
    
    func updateUI(){
        faceView.setNeedsDisplay()
        
    }
    
    func getSmiliness(sender: FaceView) -> Double {
        return Double(happiness - 50) / 50
    }
    
    func getLineWidth(sender: FaceView) -> CGFloat {
        return lineWidth
    }
    
    func getColor(sender: FaceView) -> UIColor {
        let index = Int ((happiness - 1) / 10)
        println(index)
        return colors![index]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(rangeSlider)
        
        colors = [UIColor]()
        let colorArray = ["E3F2FD", "BBDEFB", "90CAF9","64B5F6", "42A5F5", "2196F3", "1E88E5", "1976D2", "1564C0", "0D47A1"]
        
        for colorData in colorArray {
            let color: UIColor = Utils.hexStringToUIColor(colorData)
            colors?.append(color)
        }
      
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length, width: width, height: 31.0)
        
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
          }
    
    func rangeSliderValueChanged(rangSlider: RangeSlider){
        println("Range value \(rangeSlider.lowerValue)   \(rangeSlider.upperValue)")
        happiness = Int (rangSlider.lowerValue * 150 )
        lineWidth = CGFloat(rangSlider.upperValue * 20)
    }
    
    
}

