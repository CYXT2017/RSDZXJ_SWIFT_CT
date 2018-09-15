//
//  RSDUserLoginModel.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/5.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import Foundation
import UIKit

class RSDUserLoginModel: NSObject, Codable {
    var code : String = ""
    var logintime : String = ""
    var msg :String = ""
    var timeout :String = ""
    var token :String = ""
    
    var email : String = ""
    var address : String = ""
    var icon : String = ""
    var id : Int = 0
    var istestuser : String = ""
    var loginname : String = ""
    var mobilephone : String = ""
    var realname : String = ""
    
    var cid : String = ""
    
    var nickName: String = ""
    

    static var users: RSDUserLoginModel {
        let ud = UserDefaults.standard
        guard let data = ud.data(forKey: "saveUserLoginData") else {
            // 如果获取失败则重新创建一个返回
            return RSDUserLoginModel()
        }
        guard let us = try? JSONDecoder().decode(RSDUserLoginModel.self, from: data) else {
            return RSDUserLoginModel()
        }
        return us
    }
    
     override init() {
        
    }
    
    func saved() {
        if let data = try? JSONEncoder().encode(self) {
            let us = UserDefaults.standard
            us.set(data, forKey: "saveUserLoginData")
            us.synchronize()
        }
    }
}

