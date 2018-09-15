
//  Created by ios on 2018/8/22.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//

import UIKit


func RSDColor(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// Screen system to return gesture.（是否屏蔽系统返回手势）
let RSDIsCanleSystemPan:Bool = true

// The distance from the left can be automatically returned.(距离左边多少距离，可以自动返回)
let RSDDistanceToLeft:CGFloat! = 70.0

// BottomView Scaling.(底层缩放比例)
let RSDWindowToScale:CGFloat! = 1

// BottomView alpha.(底层透明度)
let RSDMaskingAlpha:CGFloat! = 0.9

// Automatic return speed.(自动返回速度)
let RSDGestureSpeed:TimeInterval! = 0.3

// Range of drag and drop.(拖拽的范围,大于此值才有效果)
let RSDDistanceToPan:CGFloat! = 10

// The default is 0, 0 for full screen return, and also for distance.（默认为0，0为全屏返回，也可指定距离）
let RSDDistanceToStart:CGFloat! = 100



