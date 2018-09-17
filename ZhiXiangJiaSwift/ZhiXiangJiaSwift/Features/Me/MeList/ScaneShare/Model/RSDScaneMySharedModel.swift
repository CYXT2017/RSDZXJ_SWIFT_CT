//
//  RSDScaneMySharedModel.swift
//  ZhiXiangJiaSwift
//
//  Created by 陈涛 on 2018/9/16.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

class RSDScaneMySharedModel: RSDDevicesModel {
    override init() {
        super.init()
    }

    var sceneId: String?
    var access_permission: String?
    var sceneName: String?
    var loginname: String?
    var picurl: String?

    //获取场景中 分享数组 myshareSubArray
    func getScraneSubArrayWithDic(dic: [String: Any]) -> NSArray {
        let  mainArray: NSArray = dic["members"] as! NSArray
        return mainArray
    }
    
    //获取场景 我分享的数组 myshareArray 主设备中数据
    func getScraneModelDataWithDic(mainDic: [String: Any]) {

        self.sceneName = mainDic["sceneName"] as? String
        self.picurl = mainDic["picurl"] as? String
        self.sceneId = mainDic["sceneId"] as? String
        self.customerId = mainDic["customerId"] as? Int
        self.loginname = mainDic["loginname"] as? String
        self.id = mainDic["id"] as? String

//        self.device = mainDic.object(forKey: "device") as? String
//        self.model = mainDic.object(forKey: "model") as? String
        
    }

}
