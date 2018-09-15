
//
//  UIColor+Extension.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/21.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

extension UIColor {
    
    //      自定义颜色  灰色字体102 102 102
    class func titleLabelColor(red: CGFloat, green: CGFloat, blue: CGFloat,alpha:CGFloat) -> UIColor {
        return  UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }

    //use example:
//    let color = UIColor.red
//    let hex = color.toHexString
    // hex == "FF0000"
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    
    //use example:
//    let color = UIColor(hex: "ff0000")
    //color == UIColor.red
    convenience init(colorWithHex: String) {
        let scanner = Scanner(string: colorWithHex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    //自定义颜色 好多方法已过期 没找到4.0的方法 先用上面的便利初始化器吧
    public class func colorWithHexString(hex:String) ->UIColor {
        
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    // 主题背景色
    class var themeViewBackGroundColor: UIColor {
        return UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
    }

    // 导航栏
    class var navBackGroundColor: UIColor {
        return UIColor(red: 15/255.0, green: 183/255.0, blue: 245/255.0, alpha: 1.0)
    }
    
}
