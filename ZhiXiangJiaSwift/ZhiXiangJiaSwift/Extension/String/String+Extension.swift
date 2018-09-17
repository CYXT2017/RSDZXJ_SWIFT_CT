
//
//  String+Extension.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/12.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import Foundation


extension String {
    
    func getServiceEmptyString(OldString: Any) -> String {
        var newString = ""
        if  OldString is NSNull {
            return newString
        }
        newString = (OldString as? String)!
        return newString
    }
    
    func getSuccessIconImageUrl(oldString: String) -> URL {
        var newUrlString: String = KEY_STING.getServiceEmptyString(OldString: oldString)
        if !newUrlString.contains("http") {
            newUrlString = RSDBaseUrl_Real + newUrlString
        }
        let url = URL(string: newUrlString)
        return url!
    }
    
    
    
}
