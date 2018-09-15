//
//  RSDDevicesModel.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/8.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

class RSDDevicesModel: NSObject {

    var id: String?
    var customerId: Int?
    var phone: String?
    var deviceId: String?
    var feedId: CLong?
    var uuid: String?
    var model: String?//型号
    var brand: String?
    var deviceName: String?
    var accessKey: String?
    var device: String? //设备类型
    var mainSubType: Int? //1 主账户 2 从账户
    var timebegin: String?
    var timeend: String?
    var datebegin: String?
    var dateend: String?
    var weekvalid: Int?
    var accesspermission: String?
    var servertime: String?
    var source: String?
    var ext1: String?
    var ext2: String?
    var ext3: String?
    var directuser: String?
    var directpwd: String?
    var onLine: String?
    var pDeviceId: String?
    var pFeedId: CLong?
    // 分享
//    var authorityInfo: RSDAuthorityInfo
    
    var doorLockModel:RSDDoorLockModel?

    func getDeviceModelWithDic(dic: [String: Any]) {
        self.mainSubType = dic["mainSubType"] as? Int
        self.deviceName = dic["deviceName"] as? String
        self.deviceId = dic["deviceId"] as? String
        self.device = dic["device"] as? String
        self.model = dic["model"] as? String
    }
    
    
    func getDoorLockModel() -> RSDDoorLockModel {
        return doorLockModel!
    }

    override init() {
//        self.authorityInfo = RSDAuthorityInfo.init()
        super.init()
//        doorLockModel = RSDDoorLockModel()
        
    }

}

//class RSDAuthorityInfo: NSObject {
//    var accessPermission: [String: Any]?
//
//}
