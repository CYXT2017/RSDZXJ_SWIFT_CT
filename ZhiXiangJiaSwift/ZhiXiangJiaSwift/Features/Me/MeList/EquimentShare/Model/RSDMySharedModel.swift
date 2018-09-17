//
//  RSDMySharedModel.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/6.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import Foundation

class RSDMySharedModel: RSDDevicesModel {
    var access_key: String?
    var access_permission: String?
    var area: String?
//    var brand: String?
    var creater: Int?
    var createtime: Date?
    var customer_id: Int?
//    var datebegin: String?
//    var dateend: String?
//    var device: String?
    var device_id: String?
    var device_name: String?
    var feed_id: Int?
//    var id:  String?
    var main_sub_type: Int?
//    var model: String?
    var msgreceive: String?
//    var phone: String?
//    var source: String?
//    var timebegin: String?
//    var timeend: String?
    var updater: String?
    var updatetime: Date?
//    var uuid: String?
//    var weekvalid: Int?
    
    var sharedSubArr: NSArray?
    
    var accessPermission: [String: Any]?//分享相关权限

    override init() {
        super.init()
    }
    
    
    //获取权限页面数据 
    func getFuncConfilgDataModelWithDic(mainDic: [String: Any]) -> String {
        self.model = KEY_STING.getServiceEmptyString(OldString: mainDic["model"] ?? "")
        self.device = KEY_STING.getServiceEmptyString(OldString: mainDic["device"] ?? "")
        self.datebegin = KEY_STING.getServiceEmptyString(OldString: mainDic["datebegin"] ?? "")
        self.dateend = KEY_STING.getServiceEmptyString(OldString: mainDic["dateend"] ?? "")
        self.timeend = KEY_STING.getServiceEmptyString(OldString: mainDic["timeend"] ?? "")
        self.timebegin = KEY_STING.getServiceEmptyString(OldString: mainDic["timebegin"] ?? "")
        self.weekvalid = mainDic["weekvalid"] as? Int
        let tempInt = self.weekvalid
        var tempStr = ""
        if tempInt == 127 {
            tempStr = "每日"
        } else if tempInt == 62 {
            tempStr = "工作日"
        } else if tempInt == 0 {
            tempStr = "不重复"
        } else {
            var weekString = ""
            for i in 0 ..< 7 {
                var offSet: NSInteger = i + 1
                if offSet == 7 {
                    offSet = 0
                }
                let hah = (0x01 << offSet) //这个是左右运算符 0x01表示1 可以看成2的倍数2 4 8 16 32 64
                let jiji = tempInt! & hah  //按位与运算 &是逻辑相与运算；^是逻辑异或运算；~是逻辑同或运算。转化成二进制之后
                let dayValue:CUnsignedChar = (CUnsignedChar(jiji))
                if dayValue > 0 {
                    var  dayStr = ""
                    switch (offSet) {
                    case 0:
                        dayStr = "周日"
                    case 1:
                        dayStr = "周一"
                    case 2:
                        dayStr = "周二"
                    case 3:
                        dayStr = "周三"
                    case 4:
                        dayStr = "周四"
                    case 5:
                        dayStr = "周五"
                    case 6:
                        dayStr = "周六"
                    default:
                        break;
                    }
                    weekString.append(dayStr)
                }
            }
            tempStr = weekString
        }
        return tempStr
    }
    
    //获取子设备数组 myshareSubArray
    func getSubArrayWithDic(dic: NSDictionary) -> NSArray {
        let  mainArray: NSArray = dic.object(forKey: "subDeviceList") as! NSArray
        return mainArray
    }
    
    //获取我分享的数组 myshareArray 主设备中数据
    func getModelDataWithDic(dic: NSDictionary) {
        let  mainDic: NSDictionary = dic.object(forKey: "mainDevice") as! NSDictionary
        
        self.id = mainDic.object(forKey: "id") as? String
        self.device_name = mainDic.object(forKey: "device_name") as? String
        self.phone = mainDic.object(forKey: "phone") as? String
        self.device_id = mainDic.object(forKey: "device_id") as? String
        
        self.device = mainDic.object(forKey: "device") as? String
        self.model = mainDic.object(forKey: "model") as? String

    }

}


