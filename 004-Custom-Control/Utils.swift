//
//  Utils.swift
//  003-Dribble-Client
//
//  Created by Audrey Li on 3/16/15.
//  Copyright (c) 2015 Shomigo. All rights reserved.
//

import Foundation
import UIKit
class Utils {
    class func getStringFromJSON(data: NSDictionary, key: String) -> String{
        
        let info : AnyObject? = data[key]
        
        if let info = data[key] as? String {
            return info
        }
        return ""
    }

    class func stripHTML(str: NSString) -> String {
        
        var stringToStrip = str
        var r = stringToStrip.rangeOfString("<[^>]+>", options:.RegularExpressionSearch)
        while r.location != NSNotFound {
            
            stringToStrip = stringToStrip.stringByReplacingCharactersInRange(r, withString: "")
            r = stringToStrip.rangeOfString("<[^>]+>", options:.RegularExpressionSearch)
        }
        
        return stringToStrip
    }

    class func formatDate(dateString: String) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.dateFromString(dateString)
        
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.stringFromDate(date!)
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (countElements(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}