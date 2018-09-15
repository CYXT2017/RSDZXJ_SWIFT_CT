//
//  RSDHTTPConnection.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/21.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

typealias RequestCallBack = (Data?,Error?) ->Void

@objc protocol HTTPConnectionDelegate:NSObjectProtocol {
    @objc  func finishConnection(data:Data);
    @objc  func failedConnection(error:Error);
}

class RSDHTTPConnection: NSObject {
    var block:RequestCallBack?;
    var delegate:HTTPConnectionDelegate?
    
    ///类方法
    
    ///  get,delegate
    class func getRequestWithDelegate(urlStr:String,param:Dictionary<String,AnyObject>?,delegate:HTTPConnectionDelegate){
        
        RSDHTTPConnection().getRequestConnectionWithDelegate(urlStr: urlStr, param: param, delegate: delegate);
    }
    
    ///  post,delegate
    class func postRequestWithDelegate(urlStr:String,param:Dictionary<String,AnyObject>?,delegate:HTTPConnectionDelegate){
        RSDHTTPConnection().postRequestConnectionWithDelegate(urlStr: urlStr, param: param, delegate: delegate);
        
    }
    
    /// get,block
    class func getRequestWithBlock(urlStr:String,param:Dictionary<String,AnyObject>?,block:@escaping RequestCallBack){
        
        RSDHTTPConnection().getRequestConnectionWithBlock(urlStr: urlStr, param: param, block: block);
        
    }
    
    /// post,delegate
    class func postRequestWithBlock(urlStr:String,param:Dictionary<String,AnyObject>?,block:@escaping RequestCallBack){
        RSDHTTPConnection().postRequestConnectionWithBlock(urlStr: urlStr, param: param, block: block);
        
    }
    
    
    ///对象方法
    
    ///  get,delegate
    
    func getRequestConnectionWithDelegate(urlStr:String,param:Dictionary<String,AnyObject>?,delegate:HTTPConnectionDelegate) -> Void {
        self.delegate = delegate;
        var myUrlStr:String?;
        if param != nil {
            let list = NSMutableArray();
            for (key ,value) in param! {
                let tmp:String = "\(key)=\(value)";
                list.add(tmp);
            }
            let paramStr = list.componentsJoined(by:"&");
            myUrlStr = urlStr.appendingFormat("?%@", paramStr);
        }else {
            myUrlStr = urlStr;
        }
        
        print("url:\(myUrlStr!)")
        let url = URL(string: myUrlStr!);
        let request = URLRequest(url: url!);
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config);
        
        let task    = session.dataTask(with: request) { (data, response, error)in
            if error == nil {
                let canDo = self.delegate?.responds(to:#selector(HTTPConnectionDelegate.finishConnection(data:)));
                if canDo! {
                    self.delegate!.finishConnection(data: data!);
                }
            } else {
                let canDo = self.delegate?.responds(to:#selector(HTTPConnectionDelegate.failedConnection(error:)));
                if canDo! {
                    self.delegate!.failedConnection(error: error!);
                }
            }
        }
        task.resume();
    }
    
    
    
    ///  post,delegate
    func postRequestConnectionWithDelegate(urlStr:String,param:Dictionary<String,AnyObject>?,delegate:HTTPConnectionDelegate) -> Void{
        self.delegate = delegate;
        print("url:\(urlStr)")
        let url = URL(string: urlStr);
        var request = URLRequest(url: url!);
        request.httpMethod = "POST";
        if param != nil {
            let list = NSMutableArray();
            for (key ,value) in param! {
                let tmp:String = "\(key)=\(value)";
                list.add(tmp);
            }
            
            let paramStr = list.componentsJoined(by:"&");
            let paramData = paramStr.data(using: .utf8);
            request.httpBody = paramData;
        }
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config);
        let task = session.dataTask(with: request) { (data, response, error)in
            if error == nil {
                let canDo = self.delegate?.responds(to:#selector(HTTPConnectionDelegate.finishConnection(data:)));
                if canDo! {
                    self.delegate!.finishConnection(data: data!);
                }
            } else {
                let canDo = self.delegate?.responds(to:#selector(HTTPConnectionDelegate.failedConnection(error:)));
                if canDo! {
                    self.delegate!.failedConnection(error: error!);
                }
            }
        }
        task.resume();
    }
    
    
    func getRequestConnectionWithBlock(urlStr:String,param:Dictionary<String,AnyObject>?,block:@escaping RequestCallBack) -> Void {
        self.block = block;
        var myUrlStr:String!
        if param != nil {
            let list = NSMutableArray();
            for (key ,value) in param! {
                let tmp:String = "\(key)=\(value)";
                list.add(tmp);
            }
            let paramStr = list.componentsJoined(by:"&");
            myUrlStr = urlStr.appendingFormat("?%@", paramStr);
        } else {
            myUrlStr = urlStr;
        }
        print("url:\(myUrlStr!)")
        let url = URL(string: myUrlStr!);
        let request = URLRequest(url: url!);
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config);
        let task = session.dataTask(with: request) { (data, response, error)in
            self.block?(data,error);
        }
        task.resume();
    }
    
    /// post,block
    func postRequestConnectionWithBlock(urlStr:String,param:Dictionary<String,AnyObject>?,block:@escaping RequestCallBack) -> Void {
        self.block = block;
        print("url:\(urlStr)")
        let url = URL(string: urlStr);
        var request = URLRequest(url: url!);
        request.httpMethod = "POST";
        if param != nil {
            let list = NSMutableArray();
            for (key ,value) in param! {
                let tmp:String = "\(key)=\(value)";
                list.add(tmp);
            }
            let paramStr = list.componentsJoined(by:"&");
            let paramData = paramStr.data(using: .utf8);
            request.httpBody = paramData;
        }
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config);
        let task    = session.dataTask(with: request) { (data, response, error)in
            self.block?(data,error);
        }
        task.resume();
    }
    

}
