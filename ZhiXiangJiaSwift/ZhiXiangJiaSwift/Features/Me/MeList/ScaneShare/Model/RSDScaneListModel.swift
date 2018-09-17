//
//  RSDScaneListModel.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/17.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

class RSDScaneListModel: NSObject {
    override init() {
        super.init()
    }

    var id: String?//场景id
    var name: String?//场景名称
    var owner: Int?//拥有者id
    var creater: CLong?//创建人id
    var updater: String?//修改者id
    var actioncounts: String?//场景中的任务数量
    var updatetime: String?//修改时间
    var picurl: String?//场景图标（新增参数）
    var createtime: String?//拥有者id
    var timebegin: String?//拥有者id
    var timeend: String?//拥有者id
    var timeexpression: String?
    var timepointexec: String?
    var dateBeg: String?
    var dateEnd: String?
    var weekValid: Int?
    var doflag: Int?
    
    
    func getUserScaneListModel(mainDic: [String: Any])  {
        self.picurl = KEY_STING.getServiceEmptyString(OldString: mainDic["picurl"] ?? "")
        self.name = mainDic["name"] as? String
        self.owner = mainDic["owner"] as? Int
        self.id = mainDic["id"] as? String
    }
    
    

}
