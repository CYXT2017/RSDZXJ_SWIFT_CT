//
//  RSDPeosonalInfoEditDataVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/31.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//这个类应该是我写的最好的一个了 简洁明了

import UIKit
import Foundation
import SVProgressHUD

enum showModelType {
    case nickNameType
    case emailType
    case addressType
}

class RSDPeosonalInfoEditDataVC: UIViewController {
    
    private var provinceArray: [Any]?
    var showType: showModelType?
    private var inputTextField: UITextField? = nil
    private var pickerView: UIPickerView
    
    //MARK: - LifeCycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        pickerView = UIPickerView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.dismiss()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextField?.resignFirstResponder()
    }

    //MARK: - Private
    private func loadLocalDataFromPlist() {
        provinceArray = NSArray.init(contentsOfFile: Bundle.main.path(forResource: "Address", ofType: "plist")!) as? [Any]
    }
    
    //MARK:toolbar 取消按钮点击
    @objc func cancelItemClicked() {
        if (inputTextField?.isFirstResponder)! {
            inputTextField?.resignFirstResponder()
        }
    }
    
    //MARK:toolbar完成按钮点击
    @objc func doneItemClick() {
        if (inputTextField?.isFirstResponder)! {
            inputTextField?.resignFirstResponder()
        }
        //获取地址
        let provinceDic: [String: Any] = provinceArray![pickerView.selectedRow(inComponent: 0)] as! [String : Any]
        let provinceString: String = provinceDic["province"] as! String
        let cityArr: [String] = provinceDic["cities"] as! [String]
        let cityString: String = cityArr[pickerView.selectedRow(inComponent: 1)]
        let addressStr = provinceString + " " + cityString
        inputTextField?.text = addressStr
        
        if addressStr == RSDUserLoginModel.users.address {
            SVProgressHUD.showError(withStatus: "新地址不能与之前的地址相同")
            return
        } else if  addressStr.count == 0 {
            SVProgressHUD.showError(withStatus: "新地址不能为空")
            return
        }
        //更新地址
        self.upDateUserData(newString: addressStr, keyString: "address")
    }

    //MARK:网络请求 更新用户数据
    private func upDateUserData(newString: String, keyString: String) {
        var parme: [String: Any] = Dictionary.init()
        parme["token"] = RSDUserLoginModel.users.token
        parme[keyString] = newString
        SVProgressHUD.show(withStatus: "更新中")
        weak var weakSelf = self
        RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.upDateUserInformation(parme), success: { (reslut) in
            
            DispatchQueue.global().async {
                print(reslut)
                print(dataToDictionary(data: reslut) ?? "")
                let dic = dataToDictionary(data: reslut) ?? [:]
                let codeStr = dic["code"] as! String
                if (codeStr == "0008") {
                    SVProgressHUD.showError(withStatus: "访问过期")
                    return
                }
                let userModel = RSDUserLoginModel.users
                if keyString == "email" {
                    userModel.email = newString
                } else if keyString == "realname" {
                    userModel.realname = newString
                } else if keyString == "address" {
                    userModel.address = newString
                }
                userModel.saved()
                DispatchQueue.main.async {
                    if let strongSelf = weakSelf {
                        SVProgressHUD.showSuccess(withStatus: "更新成功")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            strongSelf.navigationController?.popViewController(animated: true)
                        })
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"upDateUserInfo"), object: self)
                    }
                }
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            print(error)
        }
    }

    //MARK:检查用户邮箱格式
    private func checkingEmial(newString: String) -> Bool {
        if newString.count == 0 {
            return false
        }
        let  emailStr = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", argumentArray: [emailStr])
        let result = emailTest.evaluate(with: newString)
        return result
    }
    
    //MARK:布局界面
    private func creatUI() {
        let bgView = UIView()
        view.addSubview(bgView)
        bgView.backgroundColor = UIColor.white
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(30*PROPORTION_Y)
            make.top.equalToSuperview().offset(30)
        }
        inputTextField = UITextField.init()
        inputTextField?.delegate = self
        inputTextField?.clearButtonMode = .whileEditing
        inputTextField?.backgroundColor = UIColor.white
        inputTextField?.returnKeyType = .done
        inputTextField?.becomeFirstResponder()
        bgView.addSubview(inputTextField!)
        inputTextField?.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        if self.showType == showModelType.nickNameType {
            inputTextField?.text = RSDUserLoginModel.users.realname
            inputTextField?.keyboardType =  .default
        } else if self.showType == showModelType.emailType {
            inputTextField?.text = RSDUserLoginModel.users.email
            inputTextField?.keyboardType =  .emailAddress
        } else if self.showType == showModelType.addressType {
            loadLocalDataFromPlist()
            
            pickerView = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: 216))
            pickerView.showsSelectionIndicator = true
            pickerView.delegate = self
            pickerView.dataSource = self

            let cancelItem: UIBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(self.cancelItemClicked))
            let spaceItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let doneItem: UIBarButtonItem = UIBarButtonItem.init(title: "完成", style: .done, target: self, action: #selector(doneItemClick))
          
            let toolBar: UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: 45))
            toolBar.barStyle = .default
            toolBar.setItems([cancelItem,spaceItem,doneItem], animated: true)
            inputTextField?.inputView = pickerView
            inputTextField?.inputAccessoryView = toolBar
            inputTextField?.text = RSDUserLoginModel.users.address
        } else {}

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK: - 扩展
extension RSDPeosonalInfoEditDataVC: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return (provinceArray?.count)!
        } else {
            let provinceDic: [String: Any] = provinceArray![pickerView.selectedRow(inComponent: 0)] as! [String : Any]
            let cityArr: [String] = provinceDic["cities"] as! [String]
            return cityArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let provinceDic: [String: Any] = provinceArray![row] as! [String : Any]
            let provinceString: String = provinceDic["province"] as! String
            return provinceString
        } else {
            let provinceDic: [String: Any] = provinceArray![pickerView.selectedRow(inComponent: 0)] as! [String : Any]
            let cityArr: [String] = provinceDic["cities"] as! [String]
            if (row < cityArr.count) {
                let city = cityArr[row];
                return city;
            } else {
                return "";
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
    }
    
    
//    @available(iOS 10.0, *)
//    @available(iOS 10.0, *)
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//        
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.showType == showModelType.nickNameType {
            if textField.text == RSDUserLoginModel.users.realname {
                SVProgressHUD.showError(withStatus: "新昵称不能与之前的昵称相同")
                return true
            } else if  textField.text?.count == 0 {
                SVProgressHUD.showError(withStatus: "新昵称不能为空")
                return true
            }
            //上传新昵称
            self.upDateUserData(newString: textField.text!, keyString: "realname")
        } else if self.showType == showModelType.emailType {
            if textField.text == RSDUserLoginModel.users.email {
                SVProgressHUD.showError(withStatus: "新邮箱不能与之前的昵称相同")
                return true
            } else if  textField.text?.count == 0 {
                SVProgressHUD.showError(withStatus: "新邮箱不能为空")
                return true
            } else if !(self.checkingEmial(newString: (textField.text)!)) {
                SVProgressHUD.showError(withStatus: "新邮箱格式不正确")
                return true
            }
            //上传新邮箱
            self.upDateUserData(newString: textField.text!, keyString: "email")
        }
        return true
    }
    
}


