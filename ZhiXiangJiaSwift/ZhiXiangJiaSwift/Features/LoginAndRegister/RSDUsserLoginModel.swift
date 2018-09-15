
//
//  RSDUsserLoginModel.swift
//  LoginAndRegister
//
//  Created by ios on 2018/8/1.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RSDUsserLoginModel: NSObject {
    var loginModel: RSDUserModel?
    static let instance:RSDUsserLoginModel = RSDUsserLoginModel()
    class func shareInstance() -> RSDUsserLoginModel {
        return instance
    }
    
    func getUserDataForLoginDoing(parm:[String:Any],url:String) -> Void {
        Alamofire.request(url, method: .post, parameters: parm).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                if json ["code"].intValue == 0000 {
                    self.loginModel = RSDUserModel(fromJson: json)
//                    print(self.loginModel?.token ?? "dema")
//                    print(self.loginModel?.user?[0].email ?? "ss")
//                    print(self.loginModel?.user?[0].bindings?[0].cid ?? "ssw")
//                    let userModel = RSDUser(fromJson: json["user"])
//                    print(userModel.email)
//                    let userBinds = RSDBinds(fromJson: json["user"]["bindings"])
//                    print(userBinds.cid)
                    let  userDefaults = UserDefaults.standard
                    userDefaults.set(self.loginModel?.user?[0].mobilephone, forKey: "userPhoneNumber")
                    userDefaults.synchronize()
//                    semaphore.signal()、
                } else {
                    self.loginModel = RSDUserModel(fromJson: json)
                }
                CFRunLoopStop(CFRunLoopGetCurrent())
            case .failure(let error):
                print(error)
//                semaphore.signal()
                CFRunLoopStop(CFRunLoopGetCurrent())
            }
        }
    //开启等待
    CFRunLoopRun()
//        semaphore.wait()
//        print("99999")
    }
}


/*
 // json 转字典
 func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
 
 let jsonData:Data = jsonString.data(using: .utf8)!
 
 let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
 if dict != nil {
 return dict as! NSDictionary
 }
 return NSDictionary()
 }// 字典 转 json
 func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
 if (!JSONSerialization.isValidJSONObject(dictionary)) {
 print("无法解析出JSONString")
 return ""
 }
 return ""
 }

 */
