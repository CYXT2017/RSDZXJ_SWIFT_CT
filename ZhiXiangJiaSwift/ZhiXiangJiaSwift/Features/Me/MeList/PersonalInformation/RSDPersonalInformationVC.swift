
//
//  PersonalInformationVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/31.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class RSDPersonalInformationVC: UIViewController {
    private let titleArray: [String] = ["我的头像","昵称","账号","电子邮箱","我的地址"]
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reFalshUserData), name: NSNotification.Name(rawValue: "upDateUserInfo"), object: nil)
        
        view.addSubview(self.mainTableView)
        self.mainTableView.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            self.mainTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        };
        self.title = "个人信息"
        self.mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "NomalCell")
        self.mainTableView.register(RSDHeadImgTableViewCell.classForCoder(), forCellReuseIdentifier: "HeadImgCell")

        // Do any additional setup after loading the view.
    }

    //MARK: - 懒加载
    lazy var mainTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height),style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = RSDBGViewColor
        return tableView
    }()
    
    //MARK: - Private
    func getImageFromCameraOrPhotoLibrary(type: String) {
        let imgPicker = UIImagePickerController.init()
        imgPicker.delegate = self
        imgPicker.modalPresentationStyle = .currentContext
        imgPicker.allowsEditing = true
        if type == "0" {
            imgPicker.sourceType = .camera
            print("拍照")
        } else {
            imgPicker.sourceType = .photoLibrary
            print("从相册获取")
        }
        self.present(imgPicker, animated: true) {
            let userState = AVCaptureDevice.authorizationStatus(for:.video)
            if userState == AVAuthorizationStatus.restricted || userState == AVAuthorizationStatus.denied {
                let alertMsg = "请在iPhone的“设置-隐私-相机”选项中，允许智享家访问你的相机"
                let alertController: UIAlertController = UIAlertController.init(title: "温馨提示", message: alertMsg, preferredStyle: .alert)
                alertController.addAction(UIAlertAction.init(title: "好", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc  func reFalshUserData() {
        self.mainTableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



//MARK: - 扩展
extension RSDPersonalInformationVC: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editImg: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        print("\(editImg.size)")
        let imgData = UIImageJPEGRepresentation(editImg, 0.5)
        SVProgressHUD.setStatus("上传中...")
       weak var weakSelf = self
        //先调用上传图片接口 在调用更新用户信息接口
        RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.upLoadUserHeaderImage(fileData: imgData!), success: { (reslut) in
            print(reslut)
            print(dataToDictionary(data: reslut) ?? "")
            let resultDic: [String: Any] = dataToDictionary(data: reslut) ?? [:]
            let userModel = RSDUserLoginModel.users
            var  parm = [String:String]()
            parm ["token"] = userModel.token
            parm ["icon"] = userModel.icon
            RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.upDateUserInformation(parm), success: { (reslut) in
                DispatchQueue.global().async {
                    print(reslut)
                    print(dataToDictionary(data: reslut) ?? "")
                    let dic = dataToDictionary(data: reslut) ?? [:]
                    let codeStr = dic["code"] as! String
                    if (codeStr == "0008") {
                        SVProgressHUD.showError(withStatus: "访问过期")
                        picker.dismiss(animated: true, completion: nil)
                        return
                    }
                    let userModel = RSDUserLoginModel.users
                    userModel.icon = resultDic["fileurl"] as! String
                    userModel.saved()
                    DispatchQueue.main.async {
                        if let strongSelf = weakSelf {
                            SVProgressHUD.showSuccess(withStatus: "更新成功")
                            strongSelf.mainTableView.reloadData()
                            picker.dismiss(animated: true, completion: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"upDateUserHeadImage"), object: self, userInfo: ["userHeadImg": userModel.icon])
                        }
                    }
                }
                }) { (error) in
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    picker.dismiss(animated: true, completion: nil)
                }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    //MARK: 图片点击方法
    @objc func showHeaderImgForBig(_ tap: UITapGestureRecognizer) {
        let headImgView: UIImageView = tap.view as! UIImageView
        //进入图片全屏展示
        let previewVC = RSDImagePreviewVC(images: [], index: 0)
        previewVC.OneImage = headImgView.image!
        UIView.animate(withDuration: 0.8) {
            self.navigationController?.pushViewController(previewVC, animated: false)
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usersModel = RSDUserLoginModel.users//取
        if indexPath.row == 0 {
            let cellStr = "HeadImgCell"
            var cell: RSDHeadImgTableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellStr) as? RSDHeadImgTableViewCell
            if cell == nil {
                cell = RSDHeadImgTableViewCell.init(style: .default, reuseIdentifier: cellStr)
            }
            cell.setupUIWithData(headImgString: usersModel.icon, titleName: titleArray[indexPath.row])
            cell.headImgView.isUserInteractionEnabled = true
            let tapGuster = UITapGestureRecognizer.init(target: self, action: #selector(RSDPersonalInformationVC.showHeaderImgForBig(_ :)))
            cell.headImgView.addGestureRecognizer(tapGuster)
            return cell
        }
        let identifier = "NomalCell"
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier)
//        if (cell == nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: identifier)
//        }
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        if cell.textLabel?.text == "昵称" {
            cell.detailTextLabel?.text = usersModel.nickName.count == 0 ? usersModel.realname : usersModel.nickName
        } else if cell.textLabel?.text == "账号" {
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.detailTextLabel?.text = usersModel.mobilephone
        }  else if cell.textLabel?.text == "电子邮箱" {
            cell.detailTextLabel?.text = usersModel.email
        }  else if cell.textLabel?.text == "我的地址" {
            cell.detailTextLabel?.text = usersModel.address
        }
        
        cell.textLabel?.textColor = UIColor.titleLabelColor(red: 102, green: 102, blue: 102,alpha: 1.0);
        cell.detailTextLabel?.textColor = UIColor.titleLabelColor(red: 102, green: 102, blue: 102,alpha: 1.0);
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let currentCell:RSDHeadImgTableViewCell = tableView.cellForRow(at: indexPath) as! RSDHeadImgTableViewCell
            let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
                self.getImageFromCameraOrPhotoLibrary(type: "0")
            }))
            alertController.addAction(UIAlertAction.init(title: "从手机相册选择", style: .default, handler: { (action) in
                self.getImageFromCameraOrPhotoLibrary(type: "1")
            }))
            alertController.popoverPresentationController?.sourceView = currentCell
            alertController.popoverPresentationController?.sourceRect = currentCell.bounds
            self.present(alertController, animated: true, completion: nil)
        } else {
            let currentCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
            if currentCell.textLabel?.text != "账号" {
                let newVC = RSDPeosonalInfoEditDataVC()
                newVC.title = currentCell.textLabel?.text
                if newVC.title == "昵称" {
                    newVC.showType = showModelType.nickNameType
                } else if newVC.title == "电子邮箱" {
                    newVC.showType = showModelType.emailType
                } else if newVC.title == "我的地址" {
                    newVC.showType = showModelType.addressType
                }

                newVC.view.backgroundColor = RSDBGViewColor
                self.navigationController?.pushViewController(newVC, animated: true)
            }
        }
    }
    
}
