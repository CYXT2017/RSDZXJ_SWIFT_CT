//
//  RSDProductIntroduceVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/27.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class RSDProductIntroduceVC: UIViewController {

    var webView: RSDWebView?
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false
//       self.title = "产品介绍"
        webView = RSDWebView()
//        webView?.backgroundColor = RSDBGViewColor
        self.view.addSubview(webView!)
        // 配置webView样式
        var config = RSDWkwebViewConfig()
        config.isShowScrollIndicator = false
        config.isProgressHidden = false
        webView?.delegate = self 
        
        // 加载普通URL
        webView?.webConfig = config
        let nowTime = Date().timeIntervalSince1970
        let urlString = "http://www.baidu.com"
        webView?.webloadType(self, .URLString(url:urlString))
        webView?.snp.makeConstraints({ (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(1)
        })
//        webView?.frame = CGRect(x: 0, y: 0, width: RSDScreenWidth, height: 300)
        // 加载本地URL
//        config.scriptMessageHandlerArray = ["valueName"]
//        webView.webConfig = config
//        webView.delegate = self
//        webView.webloadType(self, .HTMLName(name: "test"))

        // POST加载
        //        let mobile = ""
        //        let pop = ""
        //        let auth = ""
        //        let param = ["mobile":"\(mobile)","pop":"\(pop)","auth":"\(auth)"];
        //        webView.webConfig = config
        //        webView.webloadType(self, .POST(url: "http://xxxxx", parameters: param))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RSDProductIntroduceVC: WKWebViewDelegate{
    //这个是js交互 服务器回调数据
    func webViewUserContentController(_ scriptMessageHandlerArray: [String], didReceive message: WKScriptMessage) {
        if message.name == "valueName" {
            print("haha")
        }
        print(message.body)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
        print("开始加载")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成")
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败")
        SVProgressHUD.dismiss()
    }
}

