//
//  LoginVC.swift
//  LoginAndRegister
//
//  Created by ios on 2018/8/7.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
// diyici tijiao
///hahaha
//heheh00000
import Alamofire
import UIKit
import SnapKit
import MBProgressHUD

class RSDLoginVC: UIViewController ,UITextFieldDelegate,getRegisterUserNameDelegate,HTTPConnectionDelegate {
    
    func finishConnection(data: Data) {
        print("finishConnection");
        let str:String! = String(data: data, encoding: .utf8);
        print("data:\(str!)");
    }
    
    func failedConnection(error: Error) {
        print("failedConnection:\(error)")
        
    }
    //获取比例与5对比。
    let PROPORTION_X = ((UIScreen.main.bounds.size.width * 1.0)/320)
    let  PROPORTION_Y = ((UIScreen.main.bounds.size.height * 1.0)/568)
    let navigationBarColor = UIColor(red:(15/255.0), green: 183/255.0, blue: 245/255.0, alpha: 1.0);
    let loginBgView = UIView()
    let useNameTextField = UITextField()
    let userPassWordTextField = UITextField()
    
    var userNameStr:String?
    var userPassWordStr:String?

    let loginModels = RSDUsserLoginModel.shareInstance()
    
    //MARK: - SystemCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        creatUIForLoginView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5) {
            var originalFrame = self.loginBgView.frame;
            originalFrame.origin.y = 0
            self.loginBgView.frame = originalFrame;
            self.loginBgView.snp.remakeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
            }
        }
        userNameStr = useNameTextField.text
        userPassWordStr = userPassWordTextField.text
    }


    //MARK: - Private
    @objc func registerDoingSomeThing() {
//        print("点击zhuc注册按钮")
        let registVC = RSDRegisterVC()
        registVC.delegate = self
        //第二种传值的方法
//        weak var weakSelf = self
        registVC.userNameBlock = {[weak self](userPhoneNumber:String)->Void in
            if let strongSelf = self {
                strongSelf.useNameTextField.text = userPhoneNumber
            }
        }
        //跳转
        self.navigationController?.pushViewController(registVC, animated: true)
    }
    /*
     //方案1
     weak var weakSelf = self
     testClosure = {(myNum)->Void in
     weakSelf?.classNum = myNum;
     }
     //方案2
     //[weak self] 表示 self为可选型 可以为nil 所以在使用的时候必须解包
     testClosure = {[weak self](myNum)->Void in
     self?.classNum = myNum;
     }
     //方案3
     //[unowned self]由于在使用前要保证一定有这个对象 所以不必解包
     testClosure = {[unowned self](myNum)->Void in
     self.classNum = myNum;
     }
     
     作者：SpecterGK
     链接：https://www.jianshu.com/p/91757cb99e3e
     來源：简书
     简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
     */
    
    @objc func forgetPassWordDoingSomething() {
//        print("点击忘记密码按钮")
//        let vc = BlockDemoVC()
//        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func loginDoingSomething(_ button:UIButton) {
//        print("点击登录按钮")
        self.view.endEditing(true)
        userNameStr = useNameTextField.text
        userPassWordStr = userPassWordTextField.text
        if userNameStr == nil ||  userNameStr?.count == 0  {
            self.showMBProgressWithContents(content: "用户名不能为空！")
            return
        }
        if userPassWordStr == nil || userPassWordStr?.count == 0 {
            self.showMBProgressWithContents(content: "密码不能为空！")
            return
        }
//        userNameStr = "13805604250"
//        userPassWordStr = "111111"

        userNameStr = "15391975293"
        userPassWordStr = "qqqqqq"

//        userNameStr = "15395028093"
//        userPassWordStr = "111111"
        let encryptedPWD:String = DES3Util.aes128Encrypt(userPassWordStr, withKey: "royalstar-201510", withGiv: "smarthome-151015")
        var check:String = userNameStr!;
        check = check.appending(encryptedPWD)
        check = check.getMd5()
        var  parm = [String:String]()
        parm ["loginname"] = userNameStr
        parm ["password"] = encryptedPWD
        parm ["check"] = check
        parm ["machineid"] = "2C1C75B4A38340A095167F43795576C1"
        parm ["machinetype"] = "iPad Air2 (A1566)"
        
        RSDNetWorkManager.shared.request(RSDSceneAPI.login(parm), success: { (reslut) in
            print(reslut)
            print(dataToDictionary(data: reslut) ?? "")
            let resultDic: [String: Any] = dataToDictionary(data: reslut) ?? [:]
            let userDataModel = RSDUserLoginModel.users
            let userDic: [String: Any] = resultDic["user"] as! Dictionary
            
            userDataModel.loginname = userDic["loginname"] as! String
            
            userDataModel.realname = userDic["realname"] as! String
            userDataModel.mobilephone = userDic["mobilephone"] as! String
            userDataModel.address = userDic["address"] as! String
            userDataModel.email = userDic["email"] as! String
            userDataModel.icon = userDic["icon"] as! String
            userDataModel.id = userDic["id"] as! Int
            userDataModel.token = resultDic["token"] as! String
            userDataModel.saved()
        }) { (error) in
            print(error)
        }
        
        //        HTTPConnection.postRequestWithBlock(urlStr:"https://l.rsdznjj.com.cn:9083/m/login", param:parm as Dictionary<String, AnyObject>) { (data, error) in
        //            if error != nil {
        //                print("error:\(error!)")
        //            } else {
        //                let str = String(data: data!, encoding: .utf8);
        //                print("data:\(str!)");
        //            }
        //        };
        
        //        HTTPConnection.postRequestWithDelegate(urlStr: "https://l.rsdznjj.com.cn:9083/m/login", param: parm as Dictionary<String, AnyObject>, delegate: self);
        
        
//        loginModels.getUserDataForLoginDoing(parm: parm, url: "https://l.rsdznjj.com.cn:9083/m/login")
//        let codeStr = loginModels.loginModel?.code
//        if codeStr == "0000" {
//            let  userDefaults = UserDefaults.standard
//            userDefaults.set(userPassWordStr, forKey: "userPsw")
//            userDefaults.synchronize()
//            self.showMBProgressWithContents(content: "登录成功")
//        } else {
//            let msgStr = loginModels.loginModel?.msg
//            if msgStr != nil {
//                self.showMBProgressWithContents(content: msgStr!)
//            }
//        }
//        let email = loginModels.loginModel?.user?[0].email;
    }

    //MARK:界面提示
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

    //MARK: 界面布局
    func creatUIForLoginView() {
        self.view.addSubview(loginBgView);
        loginBgView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        
        let headImgView = UIImageView()
        loginBgView.addSubview(headImgView)
        headImgView.image = UIImage(named:"userLogin_logoR")
        headImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
            make.width.equalTo(180*PROPORTION_X)
            make.height.equalTo(160*PROPORTION_Y)
        }
        
        
        let userNameView = UIView();
        loginBgView.addSubview(userNameView)
        userNameView.snp.makeConstraints { (make) in
            make.top.equalTo(headImgView.snp.bottom).offset(20*PROPORTION_Y)
            make.height.equalTo(40*PROPORTION_Y)
            make.left.right.equalToSuperview()
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
        useNameTextField.delegate = self;
        useNameTextField.placeholder = "请输入用户名"
        useNameTextField.font = UIFont.systemFont(ofSize: 15*PROPORTION_Y)
        useNameTextField.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(15*PROPORTION_Y, 60*PROPORTION_Y, 2, 20*PROPORTION_Y))
        }
        let userName = UserDefaults.standard.string(forKey: "userPhoneNumber")
        if userName != nil {
            useNameTextField.text = userName
        }
        
        let userPassWordView = UIView();
        loginBgView.addSubview(userPassWordView)
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
        let userPsw = UserDefaults.standard.string(forKey: "userPsw")
        if userPsw != nil {
            userPassWordTextField.text = userPsw
        }

        
        let loginBtn = UIButton()
        loginBgView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20*PROPORTION_X)
            make.right.equalToSuperview().offset(-20*PROPORTION_X)
            make.top.equalTo(userPassWordView.snp.bottom).offset(30*PROPORTION_Y)
            
            make.height.equalTo(40*PROPORTION_Y)
        }
        loginBtn.setTitle("登  录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.backgroundColor = navigationBarColor
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20*PROPORTION_Y)
        loginBtn.clipsToBounds = true;
        loginBtn.layer.cornerRadius = 5*PROPORTION_Y;
        loginBtn.addTarget(self, action: #selector(RSDLoginVC.loginDoingSomething(_:)), for: UIControlEvents.touchUpInside)
        
        let registerBtn = UIButton()
        loginBgView.addSubview(registerBtn)
        registerBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20*PROPORTION_X)
            make.top.equalTo(loginBtn.snp.bottom).offset(15*PROPORTION_Y)
            
            make.height.equalTo(20*PROPORTION_Y)
        }
        registerBtn.setTitle("立即注册", for: .normal)
        registerBtn.setTitleColor(navigationBarColor, for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15*PROPORTION_Y)
        registerBtn.addTarget(self, action: #selector(RSDLoginVC.registerDoingSomeThing), for: UIControlEvents.touchUpInside)
        
        let forgetPassWordBtn = UIButton()
        loginBgView.addSubview(forgetPassWordBtn)
        forgetPassWordBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20*PROPORTION_X)
            make.top.equalTo(loginBtn.snp.bottom).offset(15*PROPORTION_Y)
            
            make.height.equalTo(20*PROPORTION_Y)
        }
        forgetPassWordBtn.setTitle("忘记密码", for: .normal)
        forgetPassWordBtn.setTitleColor(navigationBarColor, for: .normal)
        forgetPassWordBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15*PROPORTION_Y)
        forgetPassWordBtn.addTarget(self, action: #selector(RSDLoginVC.forgetPassWordDoingSomething), for: UIControlEvents.touchUpInside)
    }

    
    //MARK: - GetUserNameDelegate
    func getRegisterUserName(userName: String) {
        useNameTextField.text = userName
    }
    
    //MARK: - textFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == useNameTextField {
            UIView.animate(withDuration: 0.5) {
                var originalFrame = self.loginBgView.frame;
                originalFrame.origin.y = -50
                self.loginBgView.frame = originalFrame;
                self.loginBgView.snp.remakeConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsetsMake(-50, 0, 0, 0))
                }
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                var originalFrame = self.loginBgView.frame;
                originalFrame.origin.y = -100
                self.loginBgView.frame = originalFrame;
                self.loginBgView.snp.remakeConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsetsMake(-100, 0, 0, 0))
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            var originalFrame = self.loginBgView.frame;
            originalFrame.origin.y = 0
            self.loginBgView.frame = originalFrame;
            self.loginBgView.snp.remakeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
            }
        }
        userNameStr = useNameTextField.text
        userPassWordStr = userPassWordTextField.text
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
    */

}
