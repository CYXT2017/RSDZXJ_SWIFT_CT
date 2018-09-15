//
//  RegisterVC.swift
//  LoginAndRegister
//
//  Created by ios on 2018/8/7.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON

protocol getRegisterUserNameDelegate : NSObjectProtocol {
    func getRegisterUserName(userName:String)
}

typealias getUserNameBlock = (String)->Void

class RSDRegisterVC: UIViewController ,UITextFieldDelegate {
    var userNameBlock:getUserNameBlock?
    var delegate:getRegisterUserNameDelegate?
        //获取比例与5对比。
    let navigationBarColor = UIColor(red:(15/255.0), green: 183/255.0, blue: 245/255.0, alpha: 1.0);
    
    let registerBgView = UIView()
    let useNameTextField = UITextField()
    let userPassWordTextField = UITextField()
    let repeatPassWordTextField = UITextField()
    let userphoneNumberTextField = UITextField()
    let checkNumberTextField = UITextField()
    
    var userNameStr:String?
    var userPassWordStr:String?
    var userRepeatPswStr:String?
    var userPhoneNumberStr:String?
    var userCheckNumberStr:String?
    
    var registerBgViewY:CGFloat?
    
    let checkBtn = UIButton()
    var timeOut:NSInteger?
    var isClickBool:Bool?
    var counts:Int = 0
    var timer = Timer()
    
    //MARK: - SystemCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "注册"
        creatUIForRegisterView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        useNameTextField.delegate = nil
        userPassWordTextField.delegate = nil
        repeatPassWordTextField.delegate = nil
        userphoneNumberTextField.delegate = nil
        checkNumberTextField.delegate = nil
        // 退出的时候清空定时器
        self.timer.invalidate()
    }
    // 手势点击方法
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5) {
            var originalFrame = self.registerBgView.frame;
            originalFrame.origin.y = self.registerBgViewY!
            self.registerBgView.frame = originalFrame;
            self.registerBgView.snp.remakeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(self.registerBgViewY!, 0, 0, 0))
            }
        }
        userNameStr = useNameTextField.text
        userPassWordStr = userPassWordTextField.text
        userRepeatPswStr = repeatPassWordTextField.text;
        userPhoneNumberStr = userphoneNumberTextField.text;
        userCheckNumberStr = checkNumberTextField.text;
    }
    

    //MARK: - private
    //MARK:  验证码按钮点击事件
    @objc func postCheckNumberDoing(_ button:UIButton) {
        //        userPhoneNumberStr = "15391975293"
        self.view.endEditing(true);
        if userPhoneNumberStr?.count == 0 || userPhoneNumberStr == nil {
            self.showMBProgressWithContents(content:"手机号不能为空！")
            return
        }
        let zhenzeStr = "^1(3[0-9]|4[579]|5[0-35-9]|7[0135-8]|8[0-9]|9[89]|6[6])\\d{8}$"
        if (!(NSPredicate(format: "SELF MATCHES %@", zhenzeStr).evaluate(with: userPhoneNumberStr))) {
            self.showMBProgressWithContents(content:"手机号码格式不正确！")
            return;
        }
        let isHaveRegistedInt = isExistRegister(userPhoneStr: userPhoneNumberStr!)
        if isHaveRegistedInt == 1 {
            self.showMBProgressWithContents(content:"该手机号已注册！")
            return;
        }
        sendMsgForRegister(userPhoneStr:userPhoneNumberStr!)
    }

    //MARK:   检查该手机号是否注册过
    func isExistRegister(userPhoneStr:String) -> Int {
        var registerInt = 0;//默认0 未注册  1已注册
        var  parm = [String:String]()
        parm ["mobilephone"] = userPhoneStr
        Alamofire.request("", method: .post, parameters: parm).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                if json ["code"].intValue == 0000 {
                    if json["exists"] == "true" {
                        registerInt = 1
                    }
                }
                CFRunLoopStop(CFRunLoopGetCurrent())
            case .failure(let error):
                print(error)
                CFRunLoopStop(CFRunLoopGetCurrent())
            }
        }
        //开启等待
        CFRunLoopRun()
        return registerInt
    }

    
    deinit {
        self.timer.invalidate()
//        self.timer = nil
        print("销毁定时器")
    }
    //MARK:  发送验证码接口
    func sendMsgForRegister(userPhoneStr:String) {
        var check = userPhoneStr
        let a :String = "1"
        check.append(a)
        check = check.getMd5()
        var  parm = [String:String]()
        parm ["mobilephone"] = userPhoneStr
        parm ["type"] = a
        parm ["check"] = check
        
        Alamofire.request("", method: .post, parameters: parm).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                if json ["code"].intValue == 0000 {
                    self.checkBtn.isUserInteractionEnabled = false
                    self.counts = 60
                    self.checkBtn.setTitle("验证码已发送\(String(describing: self.counts))s", for: .normal)
                    if #available(iOS 10.0, *) {
                        self.timer  = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](timer)  in
                            if let strongSelf = self {
                                strongSelf.changevalue()
                            }
                        })
                        self.timer.fire() //启动定时器
                    } else {
                        self.timer = Timer.scheduledTimer(timeInterval:1, target: self, selector:#selector(RSDRegisterVC.changevalue),userInfo:nil,repeats: true)
                    }

                    self.showMBProgressWithContents(content:"短信验证码发送成功")
                }
                CFRunLoopStop(CFRunLoopGetCurrent())
            case .failure(let error):
                print(error)
                CFRunLoopStop(CFRunLoopGetCurrent())
                self.showMBProgressWithContents(content: "发送失败,请稍后再试")
            }
        }
        //开启等待
        CFRunLoopRun()
    }
    
    @objc func  changevalue() {
        self.counts = self.counts - 1
        self.checkBtn.setTitle("验证码已发送\(String(describing: self.counts))s", for: .normal)
        if self.counts == 0 {
            self.checkBtn.setTitle("获取验证码", for: .normal)
            self.checkBtn.isUserInteractionEnabled = true
            timer.invalidate()
        }
    }

    //MARK:注册按钮点击事件
    @objc func registerDoingSomething (_ button:UIButton) {
        self.view.endEditing(true)
        if userNameStr?.count == 0 || userNameStr == nil {
            self.showMBProgressWithContents(content:"用户名不能为空！")
            return
        }
        if userPassWordStr?.count == 0 || userPassWordStr == nil {
            self.showMBProgressWithContents(content:"用户密码不能为空！")
            return
        }
        if userRepeatPswStr?.count == 0 || userRepeatPswStr == nil {
            self.showMBProgressWithContents(content:"再次输入密码不能为空！")
            return
        }
        if userPhoneNumberStr?.count == 0 || userPhoneNumberStr == nil {
            self.showMBProgressWithContents(content:"手机号不能为空！")
            return
        }
        
        if userCheckNumberStr?.count == 0 || userCheckNumberStr == nil {
            self.showMBProgressWithContents(content:"验证码不能为空！")
            return
        }
        
        if userPassWordStr != userRepeatPswStr {
            self.showMBProgressWithContents(content:"两次密码不一致！")
            return
        }
        
        let zhenzeStr = "^1(3[0-9]|4[579]|5[0-35-9]|7[0135-8]|8[0-9]|9[89]|6[6])\\d{8}$"
        if (!(NSPredicate(format: "SELF MATCHES %@", zhenzeStr).evaluate(with: userPhoneNumberStr))) {
            self.showMBProgressWithContents(content:"手机号码格式不正确！")
            return;
        }
        self.showMBProgressForPostApi(sender: "nil" as AnyObject)
        let encryptedPWD:String = DES3Util.aes128Encrypt(userPassWordStr, withKey: "royalstar-201510", withGiv: "smarthome-151015")
        var check:String = userNameStr!;
        check = check.appending(encryptedPWD)
        check = check.appending(userPhoneNumberStr!)
        check = check.appending(userCheckNumberStr!)
        check = check.getMd5()
        var  parm = [String:String]()
        parm ["realname"] = userNameStr
        parm ["mobilephone"] = userPhoneNumberStr
        parm ["password"] = encryptedPWD
        parm ["vcode"] = userCheckNumberStr
        parm ["check"] = check
        self.beginRegistForUser(parm: parm)
//        print("开始注册！！！！各个参数是-----用户名==\(String(describing: userNameStr))++++++密码=\(String(describing: userPassWordStr))+++++再次密码=\(String(describing: userRepeatPswStr))+++++手机号=\(String(describing: userPhoneNumberStr))+++++验证码=\(String(describing: userCheckNumberStr))")
    }

    //MARK: 注册接口
    func beginRegistForUser(parm:[String:Any]) {
//        self.hideHudForPostApi()
//        self.showMBProgressWithContents(content:"注册成功")
//        CFRunLoopStop(CFRunLoopGetCurrent())
//        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
//            self.navigationController?.popViewController(animated: true)
//        })
//        if self.delegate != nil {
//            self.delegate?.getRegisterUserName(userName: self.userPhoneNumberStr!)
//        }
//        if self.userNameBlock != nil {
//            self.userNameBlock!(self.userPhoneNumberStr!)
//        }
        Alamofire.request("", method: .post, parameters: parm).responseJSON { (response) in
            self.hideHudForPostApi()
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                if json ["code"].intValue == 0000 {
                    self.showMBProgressWithContents(content:"注册成功")
                    if self.delegate != nil {
                        self.delegate?.getRegisterUserName(userName: self.userPhoneNumberStr!)
                    }
                    if self.userNameBlock != nil {
                        self.userNameBlock!(self.userPhoneNumberStr!)
                    }
                    
                } else {
                    let  dict = json as! NSDictionary
                    self.showMBProgressWithContents(content:dict.object(forKey: "msg") as! String)
                }
                CFRunLoopStop(CFRunLoopGetCurrent())
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            case .failure(let error):
                print(error)
                CFRunLoopStop(CFRunLoopGetCurrent())
                self.showMBProgressWithContents(content: "注册失败,请稍后再试")
            }
        }
        //开启等待
        CFRunLoopRun()
       }

    //MARK:  界面提示
    func showMBProgressWithContents(content:String) {
        //只显示文字
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = content
        //        hud.detailsLabel.text =
        hud.margin = 10
        hud.offset.y = 50
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1.2)//https://www.jianshu.com/p/cd81bcdef64f
    }

    func showMBProgressForPostApi(sender: AnyObject) {
        let HUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        HUD.delegate = self
        HUD.tag = 10086
        //小矩形的背景色
        HUD.bezelView.color = UIColor.clear
        //显示的文字
        HUD.label.text = "请稍后..."
        //细节文字
        //        HUD.detailsLabel.text = "请耐心等待..."
        //设置背景,加遮罩
        HUD.backgroundView.style = .solidColor //或SolidColor
        HUD.margin = 20.0;
        //        HUD.hide(animated: true, afterDelay: 1.2)
    }
    
    func hideHudForPostApi() {
        let Hud = self.view.viewWithTag(10086) as! MBProgressHUD
        Hud.hide(animated: true)
    }

    //MARK:   界面布局
    func creatUIForRegisterView() {
        self.view.addSubview(registerBgView);
        if RSDIsIphoneX {
            registerBgViewY = 10*PROPORTION_Y + 88
        } else {
            registerBgViewY = 10*PROPORTION_Y + 64
        }
        registerBgView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(registerBgViewY!, 0, 0, 0))
        }
        
        let userNameView = UIView();
        registerBgView.addSubview(userNameView)
        userNameView.snp.makeConstraints { (make) in
            //            make.top.equalTo(registerBgView.snp.top).offset(20*PROPORTION_Y)
            make.height.equalTo(40*PROPORTION_Y)
            make.top.left.right.equalToSuperview()
        }
        let userNameLineView = UIView()
        userNameView.addSubview(userNameLineView)
        userNameLineView.backgroundColor = UIColor.groupTableViewBackground
        userNameLineView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(40*PROPORTION_Y-1, 20*PROPORTION_Y, 0, 20*PROPORTION_Y))
        }
        let userNameImgView = UIImageView()
        userNameView.addSubview(userNameImgView)
        userNameImgView.image = UIImage(named:"userLogin_userNameImg")
        userNameImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25*PROPORTION_Y);
            make.bottom.equalTo(userNameLineView.snp.top).offset(-1)
            make.width.equalTo(26*PROPORTION_X)
            make.height.equalTo(26*PROPORTION_Y)
        }
        userNameView.addSubview(useNameTextField)
        useNameTextField.placeholder = "请输入用户名"
        useNameTextField.delegate = self;
        useNameTextField.font = UIFont.systemFont(ofSize: 15*PROPORTION_Y)
        useNameTextField.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(15*PROPORTION_Y, 60*PROPORTION_Y, 2, 20*PROPORTION_Y))
        }
        
        
        let userPassWordView = UIView();
        registerBgView.addSubview(userPassWordView)
        userPassWordView.snp.makeConstraints { (make) in
            make.top.equalTo(userNameView.snp.bottom).offset(10*PROPORTION_Y)
            make.height.equalTo(40*PROPORTION_Y)
            make.left.right.equalToSuperview()
        }
        let userPassWordLineView = UIView()
        userPassWordView.addSubview(userPassWordLineView)
        userPassWordLineView.backgroundColor = UIColor.groupTableViewBackground
        userPassWordLineView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(40*PROPORTION_Y-1, 20*PROPORTION_Y, 0, 20*PROPORTION_Y))
        }
        let userPassWordImgView = UIImageView()
        userPassWordView.addSubview(userPassWordImgView)
        userPassWordImgView.image = UIImage(named:"userLogin_pswImg")
        userPassWordImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25*PROPORTION_Y);
            make.bottom.equalTo(userPassWordLineView.snp.top).offset(-1)
            make.width.equalTo(26*PROPORTION_X)
            make.height.equalTo(26*PROPORTION_Y)
        }
        userPassWordView.addSubview(userPassWordTextField)
        userPassWordTextField.delegate = self
        userPassWordTextField.placeholder = "请输入密码"
        userPassWordTextField.font = UIFont.systemFont(ofSize: 15*PROPORTION_Y)
        userPassWordTextField.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(15*PROPORTION_Y, 60*PROPORTION_Y, 2, 20*PROPORTION_Y))
        }
        
        
        let repeatPassWordView = UIView();
        registerBgView.addSubview(repeatPassWordView)
        repeatPassWordView.snp.makeConstraints { (make) in
            make.top.equalTo(userPassWordView.snp.bottom).offset(10*PROPORTION_Y)
            make.height.equalTo(40*PROPORTION_Y)
            make.left.right.equalToSuperview()
        }
        let repeatPassWordLineView = UIView()
        repeatPassWordView.addSubview(repeatPassWordLineView)
        repeatPassWordLineView.backgroundColor = UIColor.groupTableViewBackground
        repeatPassWordLineView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(40*PROPORTION_Y-1, 20*PROPORTION_Y, 0, 20*PROPORTION_Y))
        }
        let repeatPassWordImgView = UIImageView()
        repeatPassWordView.addSubview(repeatPassWordImgView)
        repeatPassWordImgView.image = UIImage(named:"userLogin_userNameImg")
        repeatPassWordImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25*PROPORTION_Y);
            make.bottom.equalTo(repeatPassWordLineView.snp.top).offset(-1)
            make.width.equalTo(26*PROPORTION_X)
            make.height.equalTo(26*PROPORTION_Y)
        }
        repeatPassWordView.addSubview(repeatPassWordTextField)
        repeatPassWordTextField.placeholder = "请再次输入密码"
        repeatPassWordTextField.delegate = self;
        repeatPassWordTextField.font = UIFont.systemFont(ofSize: 15*PROPORTION_Y)
        repeatPassWordTextField.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(15*PROPORTION_Y, 60*PROPORTION_Y, 2, 20*PROPORTION_Y))
        }
        
        
        let userphoneNumberView = UIView();
        registerBgView.addSubview(userphoneNumberView)
        userphoneNumberView.snp.makeConstraints { (make) in
            make.top.equalTo(repeatPassWordView.snp.bottom).offset(10*PROPORTION_Y)
            make.height.equalTo(40*PROPORTION_Y)
            make.left.right.equalToSuperview()
        }
        let userphoneNumberLineView = UIView()
        userphoneNumberView.addSubview(userphoneNumberLineView)
        userphoneNumberLineView.backgroundColor = UIColor.groupTableViewBackground
        userphoneNumberLineView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(40*PROPORTION_Y-1, 20*PROPORTION_Y, 0, 20*PROPORTION_Y))
        }
        let userphoneNumberImgView = UIImageView()
        userphoneNumberView.addSubview(userphoneNumberImgView)
        userphoneNumberImgView.image = UIImage(named:"userLogin_userNameImg")
        userphoneNumberImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25*PROPORTION_Y);
            make.bottom.equalTo(userphoneNumberLineView.snp.top).offset(-1)
            make.width.equalTo(26*PROPORTION_X)
            make.height.equalTo(26*PROPORTION_Y)
        }
        userphoneNumberView.addSubview(userphoneNumberTextField)
        userphoneNumberTextField.placeholder = "请输入您的手机号"
        userphoneNumberTextField.delegate = self;
        userphoneNumberTextField.font = UIFont.systemFont(ofSize: 15*PROPORTION_Y)
        userphoneNumberTextField.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(15*PROPORTION_Y, 60*PROPORTION_Y, 2, 20*PROPORTION_Y))
        }
        userphoneNumberView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-25*PROPORTION_X)
            make.bottom.equalTo(userphoneNumberLineView.snp.top).offset(-10)
            make.height.equalTo(25*PROPORTION_Y)
            //            make.width.equalTo(100*PROPORTION_X)
        }
        checkBtn.setTitle("获取验证码", for: .normal)
        checkBtn.setTitleColor(navigationBarColor, for: .normal)
        //        checkBtn.backgroundColor = UIColor.red
        checkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13*PROPORTION_Y)
        checkBtn.addTarget(self, action: #selector(RSDRegisterVC.postCheckNumberDoing(_: )), for: UIControlEvents.touchUpInside)
        
        
        
        
        let checkNumberView = UIView();
        registerBgView.addSubview(checkNumberView)
        checkNumberView.snp.makeConstraints { (make) in
            make.top.equalTo(userphoneNumberView.snp.bottom).offset(10*PROPORTION_Y)
            make.height.equalTo(40*PROPORTION_Y)
            make.left.right.equalToSuperview()
        }
        let checkNumberLineView = UIView()
        checkNumberView.addSubview(checkNumberLineView)
        checkNumberLineView.backgroundColor = UIColor.groupTableViewBackground
        checkNumberLineView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(40*PROPORTION_Y-1, 20*PROPORTION_Y, 0, 20*PROPORTION_Y))
        }
        let checkNumberImgView = UIImageView()
        checkNumberView.addSubview(checkNumberImgView)
        checkNumberImgView.image = UIImage(named:"userLogin_pswImg")
        checkNumberImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25*PROPORTION_Y);
            make.bottom.equalTo(checkNumberLineView.snp.top).offset(-1)
            make.width.equalTo(26*PROPORTION_X)
            make.height.equalTo(26*PROPORTION_Y)
        }
        checkNumberView.addSubview(checkNumberTextField)
        checkNumberTextField.delegate = self
        checkNumberTextField.placeholder = "请输入验证码"
        checkNumberTextField.font = UIFont.systemFont(ofSize: 15*PROPORTION_Y)
        checkNumberTextField.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(15*PROPORTION_Y, 60*PROPORTION_Y, 2, 20*PROPORTION_Y))
        }
        
        
        let registerBtn = UIButton()
        registerBgView.addSubview(registerBtn)
        registerBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20*PROPORTION_X)
            make.right.equalToSuperview().offset(-20*PROPORTION_X)
            make.top.equalTo(checkNumberView.snp.bottom).offset(30*PROPORTION_Y)
            make.height.equalTo(40*PROPORTION_Y)
        }
        registerBtn.setTitle("注  册", for: .normal)
        registerBtn.setTitleColor(UIColor.white, for: .normal)
        registerBtn.backgroundColor = navigationBarColor
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20*PROPORTION_Y)
        registerBtn.clipsToBounds = true;
        registerBtn.layer.cornerRadius = 5*PROPORTION_Y;
        registerBtn.addTarget(self, action: #selector(RSDRegisterVC.registerDoingSomething(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    //MARK: - textFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == checkNumberTextField {
            UIView.animate(withDuration: 0.5) {
                var originalFrame = self.registerBgView.frame;
                originalFrame.origin.y = -150
                self.registerBgView.frame = originalFrame;
                self.registerBgView.snp.remakeConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsetsMake(-150, 0, 0, 0))
                }
            }
        } else if textField == userphoneNumberTextField  {
            UIView.animate(withDuration: 0.5) {
                var originalFrame = self.registerBgView.frame;
                originalFrame.origin.y = -100
                self.registerBgView.frame = originalFrame;
                self.registerBgView.snp.remakeConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsetsMake(-100, 0, 0, 0))
                }
            }
        } else if textField == repeatPassWordTextField  {
            UIView.animate(withDuration: 0.5) {
                var originalFrame = self.registerBgView.frame;
                originalFrame.origin.y = -50
                self.registerBgView.frame = originalFrame;
                self.registerBgView.snp.remakeConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsetsMake(-50, 0, 0, 0))
                }
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                var originalFrame = self.registerBgView.frame;
                originalFrame.origin.y = self.registerBgViewY!
                self.registerBgView.frame = originalFrame;
                self.registerBgView.snp.remakeConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsetsMake(self.registerBgViewY!, 0, 0, 0))
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            var originalFrame = self.registerBgView.frame;
            originalFrame.origin.y = self.registerBgViewY!
            self.registerBgView.frame = originalFrame;
            self.registerBgView.snp.remakeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(self.registerBgViewY!, 0, 0, 0))
            }
        }
        userNameStr = useNameTextField.text
        userPassWordStr = userPassWordTextField.text
        userRepeatPswStr = repeatPassWordTextField.text;
        userPhoneNumberStr = userphoneNumberTextField.text;
        userCheckNumberStr = checkNumberTextField.text;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     1.//MARK: - :注意大写，标注
     
     2.//TODO: - :注意大写，注释还有什么功能要做
     
     3.//FIXME: - :注意大写，项目中有个警告，不影响程序运行，当时由于时间等一些原因，做好标记，以便之后做处理。
    */

}
