//
//  RSDUserModel.swift
//  LoginAndRegister
//
//  Created by ios on 2018/8/1.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//    var code : String
//    code = 0000;
//    logintime = "2018-08-01 14:43:40";
//    msg = "";
//    timeout = 108000;
//    token = "Y2swNDUzMjE1MzMxMDU4MjA2MzE=";
//    user =     {
//    address = "\U5b89\U5fbd \U5408\U80a5";
//    bindings =         {
//    cid = 202b9e8d9a61d32394ce7687bc190387;
//    };
//    email = "1223903860@qq.com";
//    icon = "/userupload/20171220/29521748771113387.jpg";
//    id = 60661;
//    istestuser = 0;
//    loginname = 15391975293;
//    mobilephone = 15391975293;
//    realname = "\U9648\U6d9b";
//    };
//  以上是登录数据返回格式
//  RSDUserModel：最外层数据
//  RSDUser：user内包含的数据
//  RSDBinds：bindings内包含的数据

import Foundation
import  SwiftyJSON

class RSDUserModel: Codable {
    var code : String = ""
    var logintime : String = ""
    var msg :String = ""
    var timeout :String = ""
    var token :String = ""
    var user: [RSDUser]?
    required init(){
        
    }
    init(fromJson json:JSON!) {
        if json == nil {
            return;
        }
        code = json["code"].stringValue
        logintime = json["logintime"].stringValue
        msg = json["msg"].stringValue
        timeout = json["timeout"].stringValue
        token = json["token"].stringValue
        user = [RSDUser]()
//         let  userArray = json["user"].arrayValue
//        for userJson in userArray {
//            let value = RSDUser(fromJson: userJson)
//            user?.append(value)
//        }
        
        let  userDict = json["user"].dictionaryValue
        let jsonSon = JSON(userDict)
        let value1 = RSDUser(fromJson:jsonSon)
        user?.append(value1)
    }
}

class RSDUser: Codable {
    var email : String = ""
    var address : String = ""
    var icon : String = ""
    var id : String = ""
    var istestuser : String = ""
    var loginname : String = ""
    var mobilephone : String = ""
    var realname : String = ""
    var bindings : [RSDBinds]?
    
    required init(){
        
    }
    
    init(fromJson json:JSON!) {
        if json == nil {
            return;
        }
        
        email = json["email"].stringValue
        address = json["address"].stringValue
        icon = json["icon"].stringValue
        id = json["id"].stringValue
        istestuser = json["istestuser"].stringValue
        loginname = json["loginname"].stringValue
        mobilephone = json["mobilephone"].stringValue
        realname = json["realname"].stringValue
        bindings = [RSDBinds]()
        
        let  userDict = json["bindings"].dictionaryValue
        let jsonSon = JSON(userDict)
        let value1 = RSDBinds(fromJson:jsonSon)
        bindings?.append(value1)
        //        let bindingsArray = json["bindings"].arrayValue
        //        for thumbnailUrlsJson in bindingsArray{
        //            let value = RSDBinds(fromJson: thumbnailUrlsJson)
        //            bindings?.append(value)
        //        }
        
    }
}


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


    
