
//
//  RSDConfligs.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/30.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//
import UIKit
import Foundation

public let RSDScreenWidth : CGFloat = UIScreen.main.bounds.width

public let RSDScreenHeight : CGFloat = UIScreen.main.bounds.height

public let RSDIsIphoneX : Bool = UIScreen.main.bounds.height == 812 ? true : false

public let  RSDNavBarHeight : CGFloat = RSDIsIphoneX == true ? 88.0 : 64.0

public let  RSDTabbarHeight : CGFloat = RSDIsIphoneX == true ? 80.0 : 49.0

public let  RSDBGViewColor : UIColor = UIColor.init(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)

public let PROPORTION_X = ((UIScreen.main.bounds.size.width * 1.0)/320)

public let  PROPORTION_Y = ((UIScreen.main.bounds.size.height * 1.0)/568)

