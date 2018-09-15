
//
//  String+Extension.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/12.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import Foundation


extension String {
    
    func getSuccessResultWithOldString(OldString: Any) -> String {
        var newString = ""
        if  OldString is NSNull {
            return newString
        }
        newString = (OldString as? String)!
        return newString
    }
    
    
}
