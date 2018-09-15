//
//  RSDSharedMeViewController.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/30.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class RSDSharedMeViewController: UIViewController {
    private var sharedForMeArray: [Any]
    private var deletIndex: Int = 0
    private var shareForMeFuncConfigDicArray: [Any]
    
    //MARK: - LifeCycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        shareForMeFuncConfigDicArray = Array.init()
        sharedForMeArray = Array.init()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RSDBGViewColor
        getsharedForMeListData()
        setUpUI()
    }
    
    private func getsharedForMeListData() {
        var parme: [String: Any] = Dictionary.init()
        parme["token"] = RSDUserLoginModel.users.token
        weak var weakSelf = self
        RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.getUserEquimentListData(parme), success: { (response) in
//            let jsonDic = JSON(response)
            let dic: NSDictionary = dataToDictionary(data: response)! as NSDictionary
            let  codeStr = dic["code"] as? String
            if (codeStr == "0000") {
                let tempArray: [Any] = dic["resultlist"] as! [Any]
                for item in tempArray {
                    let model = RSDDevicesModel.init()
                    model.getDeviceModelWithDic(dic: item as! [String : Any])
                    if model.mainSubType == 2 {
                       
                        weakSelf?.shareForMeFuncConfigDicArray.append(item)
                        weakSelf?.sharedForMeArray.append(model)
                    }
                }
                if weakSelf?.sharedForMeArray.count != 0 {
                    DispatchQueue.main.async {
                        weakSelf?.mainTableView.reloadData()
                    }
                }
            } else {
                SVProgressHUD.showError(withStatus:dic["msg"] as? String)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            print(error)
        }
        
    }
    
    private func setUpUI() {
        view.addSubview(self.mainTableView)
        self.mainTableView.backgroundColor = RSDBGViewColor
        self.mainTableView.tableFooterView = UIView()
        self.mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "mySharedCell")
    }
    
    private func deletShareDevice() {
        print("删除----\(deletIndex)" )
        var model = RSDDevicesModel.init()
        model = self.sharedForMeArray[deletIndex] as! RSDDevicesModel
        let deviceID = model.deviceId
        var parm: [String: Any] = Dictionary.init()
        parm["deviceID"] = deviceID
        let a =  RSDUserLoginModel.users.token
//        parm["token"] = RSDUserLoginModel.users.token
        weak var weakSelf = self
        SVProgressHUD.show(withStatus: "取消分享中...")
        RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.deleShareForMeDeviceData(parm),success: { (reslut) in
            print(reslut)
            print(dataToDictionary(data: reslut) ?? "")
            let dic: NSDictionary = dataToDictionary(data: reslut)! as NSDictionary
            let codeStr = dic["code"] as! String
            if (codeStr == "0000") {
                DispatchQueue.main.async {
                    SVProgressHUD.showSuccess(withStatus: "取消分享成功")
                    weakSelf?.mainTableView.reloadData()
                }
            } else {
                SVProgressHUD.showError(withStatus: dic.object(forKey: "msg") as? String)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
        
    }
    
    lazy var mainTableView: UITableView = {
        let tableview = UITableView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: view.height), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        return tableview
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RSDSharedMeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "mySharedCell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "mySharedCell")
        }
        if self.sharedForMeArray.count != 0 {
            var model = RSDDevicesModel.init()
           model = self.sharedForMeArray[indexPath.section] as! RSDDevicesModel
            cell.imageView?.image = RSDEquipmentPubLicFun.shareInstance.getDeviceImage(type: model.device!, model: model.model!)
            cell.textLabel?.text = model.deviceName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let views = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 10))
        view.backgroundColor = UIColor.gray
        return views
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let views = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 10))
            view.backgroundColor = UIColor.gray
            return views
        }
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sharedForMeArray.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletIndex = indexPath.section
            let alertController = UIAlertController.init(title: "提示", message: "确定放弃该设备的分享吗", preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                self.deletShareDevice()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let cell: RSDMySharedCell = tableView.cellForRow(at: indexPath) as! RSDMySharedCell
//        var model = RSDDevicesModel.init()
//        model = self.sharedForMeArray[indexPath.section] as! RSDDevicesModel
        let FuncConfigurationVC = RSDFuncConfigurationVC()
        FuncConfigurationVC.dataDic = self.shareForMeFuncConfigDicArray[indexPath.section] as? [String : Any]
        self.navigationController?.pushViewController(FuncConfigurationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * PROPORTION_Y
    }
}
