//
//  RSDIphoneContactModle.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/18.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

open class RSDIphoneContactModle: NSObject {
    
    /// 联系人姓名
    public var name: String = ""
    
    /// 联系人电话数组,一个联系人可能存储多个号码
    public var mobileArray: [String] = []
    
    /// 联系人头像
    public var headerImage: UIImage?

}
