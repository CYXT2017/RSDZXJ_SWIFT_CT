//
//  RSDSceneModel.swift
//  ZhiXiangJiaSwift
//
//  Created by Jack on 2018/8/20.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

class RSDSceneModel: Codable {
    var sceneId = ""
    var name = ""
    var scenetasksArray:[task] = []
    var weekvalid = 0
    var createtime = ""
    var imageUrl = ""
    var creater = 0
    var owner = 0
    var timebegin = ""
    var sceneConditionArray:[condition] = []
    var doflag = 0
    var datebeg = ""
    var updatetime = ""
    var conditiontype = 0
    var updater = 0
    var timepointexec = ""
    var dateend = ""
    var actioncounts = 0
    var timeend = ""
    
    /**-------以下为扩展字段----------**/
    var customPhone = "" //手机号
    
    /**
     有时候json数据中的key不一定和我的们模型中的字段名一样，这时候我们就要做关联
     注意1:CodingKeys是固定的枚举的名称，不能自定义。
     注意2:一旦定义了CodingKeys，JSONEncoder/JSONDecoder将根据CodingKeys去工作
     没有在CodingKeys中的字段将被过滤掉了
     */
    
    enum CodingKeys : String, CodingKey {
        case sceneId = "id"
        case name
        case weekvalid
        case createtime
        case imageUrl = "picurl"
        case creater
        case owner
        case timebegin
        case doflag
        case datebeg
        case updatetime
        case conditiontype
        case updater
        case timepointexec
        case dateend
        case actioncounts
        case timeend
        case scenetasksArray = "scenetasks"
        case sceneConditionArray = "scenecondits"
    }
}

class task: Codable {
    var taskId = ""
    
}

class condition: Codable {
    
}

extension RSDSceneModel{
    func addTask(taskTemp:task) -> Int {
        var flag = false
        for task in scenetasksArray {
            if task.taskId == taskTemp.taskId {
                flag = true
                break
            }
        }
        if !flag {
            scenetasksArray.append(taskTemp)
        }
        return scenetasksArray.endIndex
    }
}

//字符串扩展
extension String {
    func toDict() -> [String:Any]? {
        guard let jsonData:Data = self.data(using: .utf8) else {
            print("json转dict失败")
            return nil
        }
        if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            return dict as? [String : Any] ?? ["":""]
        }
        print("json转dict失败")
        return nil
    }
}
