//
//  RSDAddShareVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/11.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//添加设备或者场景主页面

import UIKit
import SVProgressHUD
import Kingfisher

class RSDAddShareVC: UIViewController {
    var signInt3 = 0
    private var addShareEquimentArray: [Any] = Array.init()//列表展示的数组
    private var selectStateArray: [String] = Array.init()//下一个页面的选中状态数组

    //添加门锁需要的筛选条件
    var needToVerifySecurityCodeBool = false
    var verifySuccessBool = false
    var waitCount = 0
    
    private var currentIndex = 0//当前点击的 编辑过设备功能权限的设备index

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nav: UIView = (self.navigationController?.navigationBar)!
//        let lineView: UIView = findHairlineImageViewUnder(mainView: nav)
//        lineView.isHidden = true
//        self.navigationController?.navigationBar.setBackgroundImage(imageFromColor(color: UIColor.navBackGroundColor), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()//去除导航栏底部的分割线 最简单的方法 上面的方法也可以
        self.setUpUI()
    }
    
    // MARK: - Private
    // MARK:根据颜色生成图片
    func imageFromColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height:  view.frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
    
    // MARK: 遍历导航栏视图 找到底部的细线并 删除
    func findHairlineImageViewUnder(mainView: UIView)->UIImageView!{
        if(mainView.isKind(of: UIImageView.classForCoder()) && mainView.bounds.size.height <= 1.0 ){
            return mainView as! UIImageView
        }
        
        for subview in mainView.subviews {
            let imageView = self .findHairlineImageViewUnder(mainView: subview)
            if (imageView != nil) {
                return imageView
            }
        }
        
        return nil
    }
    
    // MARK:布局UI
    private func setUpUI() {
        view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.navRightBtn)
        let topBGView = UIView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: 70 * PROPORTION_Y))
        topBGView.backgroundColor = UIColor.navBackGroundColor
        view.addSubview(topBGView)
        
        let textfieldBgView = UIView()
        topBGView.addSubview(textfieldBgView)
        textfieldBgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-70)
            make.height.equalTo(34 * PROPORTION_Y)
        }
        textfieldBgView.alpha = 0.2
        textfieldBgView.backgroundColor = UIColor.init(colorWithHex: "F4F4F4")
        textfieldBgView.clipsToBounds = true
        textfieldBgView.layer.cornerRadius = 5
        
        let cancelItem: UIBarButtonItem = UIBarButtonItem.init(title: "请输入手机号码", style: .plain, target: self, action: #selector(self.doneItemClick))
        let spaceItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let spaceItem1: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem: UIBarButtonItem = UIBarButtonItem.init(title: "完成", style: .done, target: self, action: #selector(doneItemClick))
        let toolBar: UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: 45))
        toolBar.barStyle = .default
        toolBar.setItems([spaceItem,cancelItem,spaceItem1,doneItem], animated: true)
        self.mainTextFieled.inputAccessoryView = toolBar

        topBGView.addSubview(self.mainTextFieled)
        self.mainTextFieled.delegate = self
        self.mainTextFieled.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-80)
            make.height.equalTo(34 * PROPORTION_Y)
        }
//
        self.mainTextFieled.font = UIFont.systemFont(ofSize: 17)
        self.mainTextFieled.textColor = UIColor.black
        self.mainTextFieled.leftView = UIView.init();
        self.mainTextFieled.leftViewMode = .always;

        let searchBgView = UIView.init()
        view.addSubview(searchBgView)
        searchBgView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.mainTextFieled)
            make.left.equalTo(self.mainTextFieled.snp.right)
            make.right.equalToSuperview()
        }
        
        searchBgView.addSubview(self.searchBtn)
        self.searchBtn.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let bottomBtnView = UIView.init()
        view.addSubview(bottomBtnView)
        bottomBtnView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        bottomBtnView.addSubview(self.shareBtn)
        self.shareBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        view.addSubview(self.mainTableView)
        self.mainTableView.backgroundColor = RSDBGViewColor
        self.mainTableView.tableFooterView = UIView()
        self.mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "mySharedCell")
        self.mainTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBGView.snp.bottom)
            make.bottom.equalTo(bottomBtnView.snp.top)
        }
    }
    
    
    // MARK: - 懒加载
    lazy var mainTableView: UITableView = {
        let tableview = UITableView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: 100), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0)
        tableview.keyboardDismissMode = .onDrag
        return tableview
    }()

    lazy var mainTextFieled: UITextField = {
       let textField = UITextField.init()
        textField.delegate = self
        textField.layer.cornerRadius  = 5
        textField.clipsToBounds = true
        textField.textColor = UIColor.init(colorWithHex: "333333")
        textField.placeholder = "输入手机号码"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("立即分享", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.navBackGroundColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(self.shareBtnClick), for: .touchUpInside)
        return btn
    }()

    lazy var searchBtn: UIButton = {
       let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "my_center_device_share_search"), for: .normal)
        btn.addTarget(self, action: #selector(self.searchBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var navRightBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "scene_right_add_normal"), for: .normal)
        btn.addTarget(self, action: #selector(self.addDoing), for: .touchUpInside)
        return btn
    }()


    // MARK: - BtnClick
    //MARK:toolbar完成按钮点击
    @objc func doneItemClick() {
        if self.mainTextFieled.isFirstResponder {
            self.mainTextFieled.resignFirstResponder()
        }
    }

    //分享设备
    @objc  private  func shareBtnClick() {
        if self.addShareEquimentArray.count == 0 {
            if self.signInt3 == 1 {
                SVProgressHUD.showError(withStatus: "请添加分享场景")
            } else {
                SVProgressHUD.showError(withStatus: "请添加分享设备")
            }
            return
        }
        let zhenzeStr = "^1(3[0-9]|4[579]|5[0-35-9]|7[0135-8]|8[0-9]|9[89]|6[6])\\d{8}$"
        if self.mainTextFieled.text == "" || self.mainTextFieled.text?.count != 11 || !(NSPredicate(format: "SELF MATCHES %@", zhenzeStr).evaluate(with: self.mainTextFieled.text)){
            SVProgressHUD.showError(withStatus: "请输入正确的手机号码")
            return
        }
        if self.mainTextFieled.text == RSDUserLoginModel.users.loginname {
            SVProgressHUD.showError(withStatus: "不能分享给自己")
            return
        }
        SVProgressHUD.show(withStatus: "保存分享中...")
        DispatchQueue.global(qos: .default).async {
            if self.signInt3 == 0 {
                for i in 0..<self.addShareEquimentArray.count {
                    let subDic: [String: Any] =  self.addShareEquimentArray[i]  as! Dictionary
                    let deviceType = subDic["device"] as! String
                    if deviceType == RSD_EQUIPMENT_TYPE_ZIGBEE_DOORLOCK || deviceType == RSD_EQUIPMENT_TYPE_NB_DOORLOCK {
                        self.needToVerifySecurityCodeBool = true;
                        break;
                    }
                }
                
                if self.needToVerifySecurityCodeBool {
                    //验证门锁
                    //FIXME: -这里面有东西没写完 待写
                    RSDDevicesModel.init().getDoorLockModel().verifySecurityCodeMethod(mainVC: self, completion: { (reslutBool) in
                        self.waitCount = self.waitCount + 1
                        self.verifySuccessBool = reslutBool
                    })
                    while(self.waitCount <= 0) { sleep(1) }
                    if !self.verifySuccessBool { return }
                }
            }

            //操作完成，调用主线程来刷新界面
            DispatchQueue.main.async {
                let userPhone = self.mainTextFieled.text
                weak var weakSelf = self
                if self.signInt3 == 1 {
                    self.addScraneDataMethod(shareUser: userPhone!, completion: { (success, errorMsg) in
                        if success {
                            if errorMsg.count == 0 {
                                DispatchQueue.main.async {
                                    SVProgressHUD.showSuccess(withStatus: "保存成功")
                                    //FIXME: - 成功之后发通知 刷新界面
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:REFALSH_NOTIFICATION), object: nil)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                        weakSelf?.navigationController?.popViewController(animated: true)
                                    })
                                }
                            } else {
                                SVProgressHUD.showError(withStatus: errorMsg)
                            }
                        } else {
                            SVProgressHUD.showError(withStatus: errorMsg)
                        }
                    })
                } else {
                    self.addMyShareDeviceMethod(deviceArray: self.addShareEquimentArray, shareUser: userPhone!, completion: { (success, errorMsg) in
                        if success {
                            if errorMsg.count == 0 {
                                DispatchQueue.main.async {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                        weakSelf?.navigationController?.popViewController(animated: true)
                                    })
                                    SVProgressHUD.showSuccess(withStatus: "保存成功")
                                    //FIXME: - 成功之后发通知 刷新界面
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:REFALSH_NOTIFICATION), object: nil)
                                }
                            } else {
                                SVProgressHUD.showError(withStatus: errorMsg)
                            }
                        } else {
                            SVProgressHUD.showError(withStatus: errorMsg)
                        }
                    })
                }
            }
        }
    }
    
    // MARK: 进入系统通讯录联系人界面
    @objc  private  func searchBtnClicked() {
        let contactVC = RSDIphoneContactVC()
        contactVC.title = "联系人"
        contactVC.delegate = self
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
    
    //点击 进入添加设备或者场景二级页面
    @objc  private  func addDoing() {
        self.mainTextFieled.resignFirstResponder()
        let addVC = RSDAddDeviceAndScanListVC()
        addVC.title = "添加设备"
        if self.signInt3 == 1 {
            addVC.title = "添加场景"
        }
        if self.addShareEquimentArray.count != 0 {
            addVC.btnStateArray = self.selectStateArray
        }
        addVC.signInt4 = self.signInt3
        addVC.delegates = self
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK: - 扩展
extension RSDAddShareVC: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AddDeviceAndScaneDelegate, RSDEditFuncConfigurationDelegate, RSDChooseIphoneContactDelegate {
    // MARK:通讯录联系人 回调
    func seleIphoneContact(iphoneString: String) {
        self.mainTextFieled.text = iphoneString
    }
    
    // MARK:获取设备或者场景数据的回调
    func chooseDeviceAndScaneMethod(selectArray: [Any], btnStateArr: [String]) {
        self.addShareEquimentArray = selectArray
        self.selectStateArray = btnStateArr
        self.mainTableView.reloadData()
    }
    
    // MARK:权限页面保存的数据回调
    func changeDataDic(dateBegin: String, dateEnd: String, timeBegin: String, timeEnd: String, repeatStr: String, accorPrame: [String : Any], repeatInts: Int) {
        var subDic: [String: Any] =  self.addShareEquimentArray[currentIndex]  as! Dictionary
        subDic["timebegin"] = timeBegin
        subDic["timeend"] = timeEnd
        subDic["datebegin"] = dateBegin
        subDic["dateend"] = dateEnd
        //        subDic["weekvalid"] = repeatStr
        subDic["weekvalid"] = repeatInts
        subDic["accessPermission"] = accorPrame
    }
    

  
    // MARK: - tableviewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addShareEquimentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "mySharedCell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "mySharedCell")
        }
        if self.addShareEquimentArray.count != 0 {
            if self.signInt3 == 1 {
                let dataModel: RSDScaneListModel =  self.addShareEquimentArray[indexPath.row]  as! RSDScaneListModel
                cell.textLabel?.text = dataModel.name
                let url: URL = KEY_STING.getSuccessIconImageUrl(oldString: dataModel.picurl!)
                cell.imageView?.kf.setImage(with: ImageResource(downloadURL: url), placeholder: UIImage(named: "DefaultModeImage"), options: nil, progressBlock: nil, completionHandler: nil)
                cell.accessoryType = .none
            } else {
                let subDic: [String: Any] =  self.addShareEquimentArray[indexPath.row]  as! Dictionary
                let phoneStr = subDic["deviceName"] as! String
                cell.textLabel?.text = phoneStr
                let typeString = subDic["device"] as! String
                let modelString = subDic["model"] as! String
                cell.imageView?.image = RSDEquipmentPubLicFun.shareInstance.getDeviceImage(type: typeString, model: modelString)
                cell.accessoryType = .disclosureIndicator
            }
            if indexPath.row == self.addShareEquimentArray.count - 1 {
//                self.hideLastCellLineView(lastSupView: cell.contentView)
//                self.filerCellSeperateLine(cell: cell)
                tableView.separatorStyle = .none
            }
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.signInt3 == 1 {
            return;
        }
        currentIndex = indexPath.row
        let FuncConfigurationVC = RSDFuncConfigurationVC()
        FuncConfigurationVC.isEditBool = true
        FuncConfigurationVC.delegate = self
        FuncConfigurationVC.dataDic = self.addShareEquimentArray [indexPath.row] as? [String : Any]
        self.navigationController?.pushViewController(FuncConfigurationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.layer.opacity = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.layer.opacity = 0.2
    }
    
    
    // MARK: - 保存设备接口
    func  addMyShareDeviceMethod(deviceArray: [Any], shareUser: String, completion: @escaping (_ resultBool: Bool, _ resultStr: String) -> ()) {
//        var errorTemp: NSError = NSError.init()
        var arr: [Any] = Array.init()
         //FIXME: - 看了下OC版 摄像头相关很多代码 需要开通萤石云等等的 暂时先不写了  门锁相关的暂时也分享不了
        for i in 0..<self.addShareEquimentArray.count {
            let subDic: [String: Any] =  self.addShareEquimentArray[i]  as! Dictionary
            var dic: [String: Any] = Dictionary.init()
            dic["deviceid"] = subDic["deviceId"]
            dic["type"] = 2
            dic["timebegin"] = subDic["timebegin"]
            dic["timeend"] = subDic["timeend"]
            dic["datebegin"] = subDic["datebegin"]
            dic["dateend"] = subDic["dateend"]
            dic["weekvalid"] = subDic["weekvalid"]
            dic["access_permission"] = subDic["accessPermission"]
            arr.append(dic)
        }
        
        var params: [String: Any] = Dictionary.init()
        params["phone"] = shareUser
        params["inShareList"] = arr
            RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.UserAddMainDeviceShare(params), success: { (result) in
            let dic: NSDictionary = dataToDictionary(data: result)! as NSDictionary
            let  codeStr = dic["code"] as? String
            if (codeStr == "0000") {
                completion(true, "")
            } else {
                completion(false, (dic["msg"] as? String)!)
            }
        }) { (error) in
            completion(false, error.localizedDescription)
        }
    }
    
    
    // MARK: - 保存场景接口
    func  addScraneDataMethod(shareUser: String, completion: @escaping (_ resultBool: Bool, _ resultStr: String) -> ()) {
        var arr: [Any] = Array.init()
        for i in 0..<self.addShareEquimentArray.count {
            let dataModel: RSDScaneListModel =  self.addShareEquimentArray[i]  as! RSDScaneListModel
            arr.append(dataModel.id!)
        }
        var params: [String: Any] = Dictionary.init()
        params["phone"] = shareUser
        params["sceneIds"] = arr
        RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.addMyShareScaneListData(params), success: {(result) in
            let dic: NSDictionary = dataToDictionary(data: result)! as NSDictionary
            let  codeStr = dic["code"] as? String
            if (codeStr == "0000") {
                completion(true, "")
            } else {
                completion(false, (dic["msg"] as? String)!)
            }
        }) { (error) in
            completion(false, error.localizedDescription)
        }
    }
}



/*
 private func hideLastCellLineView(lastSupView: UIView) {
 for subview in (lastSupView.superview?.subviews)! {
 if NSStringFromClass(subview.classForCoder).hasSuffix("SeparatorView") {
 subview.isHidden = true
 }
 }
 
 for subview in lastSupView.subviews {
 if subview.isKind(of: NSClassFromString("_UITableViewCellSeparatorView")!) {
 subview.isHidden = true
 }
 }
 
 }
 
 func filerCellSeperateLine(cell:UITableViewCell) {
 let subviews = cell.subviews
 for subview in subviews {
 
 if let separatorViewClass: AnyClass = NSClassFromString("_UITableViewCellSeparatorView") {
 
 if subview.isKind(of: separatorViewClass) {
 
 subview.isHidden = true
 
 }
 
 }
 
 }
 
 }

 
 */

