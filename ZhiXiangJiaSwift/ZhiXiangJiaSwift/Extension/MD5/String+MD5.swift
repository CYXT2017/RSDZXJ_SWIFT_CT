//
//  String+MD5.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/21.
//  Copyright © 2018年 rsdznjj. All rights reserved.
// swift的MD5加密 

import Foundation

extension String  {
    
    //md5加密算法 属性
    var MD5String: String {
        let cStrl = cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
        var md5String = "";
        
        for idx in 0...15 {
            let obcStrl = String.init(format: "%02x", buffer[idx]);
            md5String.append(obcStrl);
        }
        free(buffer);
        return md5String;
    }
    
    //md5加密算法  方法
    func getMd5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
}
