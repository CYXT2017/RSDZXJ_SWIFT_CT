
//
//  RSDAdviceBackVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/30.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import SVProgressHUD

class RSDAdviceBackVC: UIViewController {

    private var mainTextView : UITextView?
    private var submitBtn : UIButton?
    private var showMessageBtn : UIButton?
    private var placeHolderLabel : UILabel?
    private var showCoutLabel : UILabel?
    private let remainCount : Int = 500
    
    private var adviceModel: RSDAdviceModel = RSDAdviceModel()
    
    //MARK: - SystemCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.showNewMessageView);
        self.upDateConstranints()
        self.creatUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.testUI(showStr : "1")
        self.checkIsHaveNewMessageMethod()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         view.endEditing(true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - Private
    //MARK:查询是否有新回复接口
    func checkIsHaveNewMessageMethod() {
        let userModel = RSDUserLoginModel.users
        let phoneNumber = userModel.mobilephone
        var  parm = [String:String]()
        parm ["phone"] = phoneNumber
        RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.checkIsNewMessage(parm), success: { (reslut) in
            DispatchQueue.global().async {
                let resultDic: [String: Any] = dataToDictionary(data: reslut) ?? [:]
                self.adviceModel.isNewReply = resultDic["isNewReply"] as! String
                self.adviceModel.code = resultDic["code"] as! String
                self.adviceModel.msg = resultDic["msg"] as! String
                let showStr: String = self.adviceModel.isNewReply == "false" ? "0" : "1"
                DispatchQueue.main.async {
                    self.testUI(showStr : showStr)
                }
            }
        }) { (error) in
            print(error)
        }

    }
    //MARK:上传意见
    @objc func submitAction(_ btn : UIButton) {
        if mainTextView?.text.count == 0 {
            SVProgressHUD.showError(withStatus: "反馈内容不能为空！")
            return
        }
        let userModel = RSDUserLoginModel.users
        let phoneNumber = userModel.mobilephone
        var  parm = [String:String]()
        parm ["phone"] = phoneNumber
        parm ["category"] = "2"
        parm ["content"] = mainTextView?.text
        parm ["version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        parm ["email"] = phoneNumber
        parm ["phone"] = phoneNumber
        RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.commitAdvice(parm), success: { (reslut) in
            print(dataToDictionary(data: reslut) ?? "")
            let resultDic: [String: Any] = dataToDictionary(data: reslut) ?? [:]
            let codeStr = resultDic["code"] as? String
            if codeStr == "0000" {
                DispatchQueue.main.async {
                    SVProgressHUD.showSuccess(withStatus: "提交成功")
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
            
            
        }) { (error) in
            print(error)
        }

    }
    
    func testUI(showStr : String) {//1 显示 0 隐藏
        showNewMessageView.height = showStr == "0" ? 1 : 49
        showNewMessageView.isHidden = showStr == "0" ? true : false
    }
    
    //MARK:进入 『您之前的反馈有新的回复』 『历史反馈』页面
    @objc func pushAdviceListVC() {
        self.navigationController?.pushViewController(RSDAdviceListVC(), animated: true)
        self.testUI(showStr: "0")//这里有问题 当网速不好或者进入页面瞬间返回的时候 没看到反馈列表时 就改变这个页面的状态时不正确的逻辑 最好是等以上2个页面数据加载完 确认用户看到新回复时 再改变这个页面的状态 。但是 、、但是  但是这个页面不重要 随便洒洒水啦、
   
        //时隔大半个月我又回来了 最好是等进入历史反馈页面数据加载完成 发通知就好了
    }
 
    @objc func textViewTextDidChanges(_ notif : Notification) {
        if mainTextView?.text.count == 0 {
            placeHolderLabel?.text = "请输入您宝贵的建议";
        } else {
            placeHolderLabel?.text = ""
        }
        let  remainCount = self.remainCount - (mainTextView?.text.count)!
        showCoutLabel?.text = "\(remainCount)" + "字"
    }
    
    private func upDateConstranints() {
        //这么设置 页面更新隐藏showNewMessageView的时候 maintextview 上不去 不知道为什么
//        self.showNewMessageView.snp.makeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.height.equalTo(49)
//        }
        self.showMessageBtn?.snp.makeConstraints({ (make) in
            make.top.left.bottom.right.equalToSuperview()
        })
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() +  10) {
        //            self.showNewMessageView.isHidden = true
        //        }
    }
    
    private func creatUI() {
        let adviceBGView = UIView.init()
        view.addSubview(adviceBGView)
        adviceBGView.backgroundColor = UIColor.white
        adviceBGView.layer.borderColor = UIColor.init(colorWithHex: "D5D5D5").cgColor
        adviceBGView.layer.borderWidth = 1
        adviceBGView.clipsToBounds = true
        adviceBGView.layer.cornerRadius = 8
        adviceBGView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20);
            make.top.equalTo(self.showNewMessageView.snp.bottom).offset(20);
            make.right.equalToSuperview().offset(-20);
            make.height.equalTo(180*PROPORTION_Y)
        }
        
        mainTextView = UITextView.init()
        mainTextView?.font = UIFont.systemFont(ofSize: 17)
        mainTextView?.returnKeyType = .done
        adviceBGView.addSubview(mainTextView!)
        mainTextView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsetsMake(25, 15, -15, -15))
        })
        
        placeHolderLabel = UILabel.init()
        placeHolderLabel?.text = "请输入您宝贵的建议"
        placeHolderLabel?.textColor = UIColor.groupTableViewBackground
        placeHolderLabel?.font = UIFont.systemFont(ofSize: 18)
        placeHolderLabel?.isEnabled = false
        mainTextView?.addSubview(placeHolderLabel!)
        placeHolderLabel?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
        })
        
        showCoutLabel = UILabel.init()
        showCoutLabel?.text = "500字"
        showCoutLabel?.textColor = UIColor.init(colorWithHex: "666666")
        showCoutLabel?.font = UIFont.systemFont(ofSize: 14)
        showCoutLabel?.isEnabled = false
        view.addSubview(showCoutLabel!)
        showCoutLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(adviceBGView.snp.bottom).offset(10)
            make.right.equalTo(adviceBGView.snp.right)
        })
        
        submitBtn = UIButton.init()
        submitBtn?.backgroundColor = UIColor.init(colorWithHex: "25B8F4")
        submitBtn?.clipsToBounds = true
        submitBtn?.layer.cornerRadius = 10
        submitBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        submitBtn?.setTitle("提 交", for: .normal)
        submitBtn?.addTarget(self, action: #selector(self.submitAction(_:)), for: .touchUpInside)
        view.addSubview(submitBtn!)
        submitBtn?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(16*PROPORTION_X);
            make.top.equalTo((showCoutLabel?.snp.bottom)!).offset(30);
            make.right.equalToSuperview().offset(-16*PROPORTION_X);
            make.height.equalTo(33*PROPORTION_Y);
        })
        
        let historyListBtn = UIButton.init()
        historyListBtn.setTitleColor(UIColor.init(colorWithHex: "666666"), for: .normal)
        historyListBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        historyListBtn.setTitle("历史反馈", for: .normal)
        historyListBtn.addTarget(self, action: #selector(self.pushAdviceListVC), for: .touchUpInside)
        view.addSubview(historyListBtn)
        historyListBtn.snp.makeConstraints({ (make) in
            make.top.equalTo((submitBtn?.snp.bottom)!).offset(10);
            make.right.equalTo((showCoutLabel?.snp.right)!);
        })
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textViewTextDidChanges(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
    }
    
    
    //MARK: - 懒加载
    lazy var showNewMessageView : UIView = {
//       let messageView = UIView.init()
        let messageView = UIView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: 49))
        messageView.backgroundColor = UIColor.white
        
        let showImgView = UIImageView.init(frame: CGRect(x: 20, y: 4.5, width: 40, height: 40))
        showImgView.image = UIImage.init(named: "my_advice_message")
        messageView.addSubview(showImgView)
        
        let showLabel = UILabel.init(frame: CGRect(x:showImgView.frame.maxX + 15, y: showImgView.y, width: RSDScreenWidth - 100, height: showImgView.height))
        showLabel.text = "您之前的反馈有新的回复!"
        showLabel.textColor = UIColor.init(colorWithHex: "7B8080")
//        showLabel.textColor = UIColor.colorWithHexString(hex: "7B8080")
        showLabel.font = UIFont.systemFont(ofSize: 17)
        messageView.addSubview(showLabel)
        
        let messageBtn = UIButton.init(frame: messageView.bounds)
        self.showMessageBtn = messageBtn
        messageBtn.addTarget(self, action: #selector(self.pushAdviceListVC), for: .touchUpInside)
        messageView.addSubview(messageBtn)
        return messageView
    }()
    

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
