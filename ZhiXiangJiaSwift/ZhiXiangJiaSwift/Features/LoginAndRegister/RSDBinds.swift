//
//  RSDBinds.swift
//  LoginAndRegister
//
//  Created by ios on 2018/8/3.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//

import UIKit

//class RSDBinds: NSObject {
//
//}
import  SwiftyJSON
class RSDBinds:Codable {
    var cid : String!
    init(){}
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        cid = json["cid"].stringValue
    }
}
