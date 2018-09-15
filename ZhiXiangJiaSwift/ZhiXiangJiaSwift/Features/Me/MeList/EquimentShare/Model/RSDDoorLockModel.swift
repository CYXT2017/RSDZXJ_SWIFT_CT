//
//  RSDDoorLockModel.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/14.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import LocalAuthentication
import SVProgressHUD

class RSDDoorLockModel: RSDDevicesModel {
    
    override init() {
        super.init()
    }

    
    func verifySecurityCodeMethod(mainVC: UIViewController,completion: @escaping (_ resultBool: Bool) -> ()) {
        self.fingerprintVerification(mainvc: mainVC) { (success, needToVerifySecurityCode) in
            if success { // 指纹验证通过
                completion (true)
            } else {// 安全密码验证
                if needToVerifySecurityCode {
                    self.securityCodeVerification(completion: { (succeed, needToSetSecurityCode) in
                        if success {// 安全密码验证通过
                            completion(true)
                        } else {
                            if (needToSetSecurityCode) {
//                                RSDCreateSecurityPasswordViewController *vc = [[RSDCreateSecurityPasswordViewController alloc] init];
//                                vc.title = @"创建安全密码";
//                                if (self.handleVC) {
//                                    [self.handleVC.rt_navigationController pushViewController:vc animated:YES];
//                                 }
                                 //FIXME: - 待写 创建安全密码
                            }
                            completion(false)
                        }
                    })
                } else {
                    completion(false)
                }
            }
        }
    }
    
    //MARK: - network request
    func  verifyIfSecurityCodeWasSetOrNot(completion: @escaping(_ resultBool: Bool, _ messageString: String) -> ()) {
        var parme: [String: Any] = Dictionary.init()
        parme["token"] = RSDUserLoginModel.users.token
        parme["passtype"] = "1"
        RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.checkAgainPSWIsExitMethod(parme), success: { (reslut) in
            print(reslut)
            print(dataToDictionary(data: reslut) ?? "")
            let dic = dataToDictionary(data: reslut) ?? [:]
            let codeStr = dic["code"] as! String
            //FIXME: - 这里可能有问题 我看接口文档上写的是 成功0000 但是智享家OC里面写的是7206
            if (codeStr == "7206") {
                completion(true, "成功")
            } else {
                completion(false, dic["msg"] as! String);
                
            }
        }) { (error) in
            completion(false, "");
        }

        
    }
    
    func securityCodeVerification(completion: @escaping(_ success: Bool, _ needToSetSecurityCode: Bool) -> ()) {
        self.verifyIfSecurityCodeWasSetOrNot { (success, errorMsg) in
            if success {//弹出密码输入窗口
                 //FIXME: - 待 写
                
            } else {
                if errorMsg.count != 0 {
                    DispatchQueue.main.async {
                        SVProgressHUD.showError(withStatus: "还没有设置安全密码，请设置")
                    }
                    completion(false, true)
                } else {
                    DispatchQueue.main.async {
                        SVProgressHUD.showError(withStatus: "网络异常")
                    }
                    completion(false, false)
                }
            }
        }
    }
    
    func fingerprintVerification(mainvc: UIViewController, completion: @escaping (_ success: Bool, _ needToVerifySecurityCode: Bool) -> ())  {
        let  state = AppDelegate.shareInstance.securitySetUpValue["state"] as! String
        if state == "1" {
            let context: LAContext = LAContext.init()
            context.localizedFallbackTitle = "输入安全密码"
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "验证指纹") { (success, error) in
                    if success {
                        print("Touch ID验证 - 成功")
                        completion(true, false)
                    } else {
                        print("Touch ID验证 - 失败，error =\(String(describing: error?.localizedDescription))")
                        let newError: NSError = error! as NSError
                        if newError.code == kLAErrorUserCancel {
                            DispatchQueue.main.async {
                                let alertVC = UIAlertController.init(title: "", message: "确定要退出吗？", preferredStyle: .alert)
                                alertVC.addAction(UIAlertAction.init(title: "输入安全密码", style: .cancel, handler: { (action) in
                                    completion(false, true)
                                }))
                                
                                alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                                    completion(false, false)
                                }))
                                mainvc.present(alertVC, animated: true, completion: nil)
                            }
                        } else if newError.code == kLAErrorUserFallback {
                            completion(true, false);
                        } else {
                            completion(true, false);
                        }
                    }
                }
            }
        }
        completion(false, true)
    }
    
    
    
    
    
}













