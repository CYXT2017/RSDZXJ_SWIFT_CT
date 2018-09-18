//
//  RSDMyShareViewController.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/30.
//  Copyright © 2018年 rsdznjj. All rights reserved.
// 我分享的页面， 设备分享和 场景分享页面  0 默认设备  1 场景

import UIKit
import SVProgressHUD

class RSDMyShareViewController: UIViewController {
    private var mySharedArray: [Any] // 列表数组
    private var mySharedSubArray: [Any] //我分享的子设备子场景数组
    private var deletIndex: Int = 0
    var signInt1 = 0

    //MARK: - LifeCycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        mySharedArray = Array.init()
        mySharedSubArray = Array.init()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RSDBGViewColor
        getMySharedDeviceListData()
        setUpUI()
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: - Private
    private func getMySharedDeviceListData() {
        var parme: [String: Any] = Dictionary.init()
        parme["token"] = RSDUserLoginModel.users.token
        SVProgressHUD.show()
        weak var weakSelf = self
        var ttt = RSDPeosonalCenterApi.getMySharedDeviceListData(parme)
        if self.signInt1 == 1 {
            ttt = RSDPeosonalCenterApi.getScaneMySharedListData(parme)
        }
        RSDNetWorkManager.shared.request(ttt, success: { (reslut) in
            SVProgressHUD.dismiss()
            DispatchQueue.global().async {
                print(reslut)
                print(dataToDictionary(data: reslut) ?? "")
                let dic: NSDictionary = dataToDictionary(data: reslut)! as NSDictionary
                let codeStr = dic["code"] as! String
                if (codeStr != "0000") {
                    SVProgressHUD.showError(withStatus: dic["msg"] as? String)
                    return
                }
                let tempArray: NSArray = dic.object(forKey: "resultlist") as! NSArray
                if self.signInt1 == 1 {
                    for i in 0 ..< tempArray.count {
                        let model: RSDScaneMySharedModel = RSDScaneMySharedModel()
                        let tempArr: [Any] = model.getScraneSubArrayWithDic(dic: (tempArray[i] as? [String: Any])! ) as! [Any]
                        weakSelf?.mySharedSubArray.append(tempArr)
                        model.getScraneModelDataWithDic(mainDic: tempArray[i] as! [String: Any])
                        weakSelf?.mySharedArray.append(model)
                    }
                } else {
                    for dic in tempArray {
                        let model: RSDMySharedModel = RSDMySharedModel()
                        let tempArr: [Any] = model.getSubArrayWithDic(dic: dic as! NSDictionary) as! [Any]
                        weakSelf?.mySharedSubArray.append(tempArr)
                        model.getModelDataWithDic(dic: dic as! NSDictionary)
                        weakSelf?.mySharedArray.append(model)
                    }
                }
                DispatchQueue.main.async {
                    weakSelf?.mainTableView.reloadData()
                }
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            print(error)
        }

    }
    
    // MARK: 布局界面
    private func setUpUI() {
        view.addSubview(self.mainTableView)
        self.mainTableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-64)
        }
//        if #available(iOS 11.0, *) {
//            self.mainTableView.contentInsetAdjustmentBehavior = .never
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = false
//        };

        self.mainTableView.backgroundColor = RSDBGViewColor
        self.mainTableView.tableFooterView = UIView()
        self.mainTableView.register(RSDMySharedCell.classForCoder(), forCellReuseIdentifier: "mySharedCell")
        
    }
    
    // MARK: 删除我分享的设备或者场景
    private func deletShareDevice() {
        print("删除----\(deletIndex)" )
        var parm: [String: Any] = Dictionary.init()
        var ttt = RSDPeosonalCenterApi.deleMyShareDeviceData(parm)
        let tempArr: [Any] = [self.mySharedSubArray[deletIndex]]
        let subArray: [Any] = tempArr.first as! Array
        var phoneArr: [Any] = Array.init()
        for subDic in subArray {
            if self.signInt1 == 0 {
                let phoneStr = (subDic as! [String: Any])["phone"] as! String
                phoneArr.append(phoneStr)
            } else {
                let userId = (subDic as! [String: Any])["id"] as! Int
                let idString = "\(userId)"
                phoneArr.append(idString)
            }
        }
        if self.signInt1 == 1 {
            ttt = RSDPeosonalCenterApi.deletMyShareScaneListData(parm)
            let model: RSDScaneMySharedModel = self.mySharedArray[deletIndex] as! RSDScaneMySharedModel
            var parm: [String: Any] = Dictionary.init()
            parm["customerIds"] = phoneArr
            parm["sceneId"] = model.sceneId
            parm["token"] = RSDUserLoginModel.users.token
        } else {
            let model: RSDMySharedModel = self.mySharedArray[deletIndex] as! RSDMySharedModel
            let deviceID = model.device_id
            parm["deviceid"] = deviceID
            parm["phonelist"] = phoneArr
            //        parm["token"] = RSDUserLoginModel.users.token
        }
        weak var weakSelf = self
        SVProgressHUD.show(withStatus: "取消分享中...")
 RSDNetWorkManager.shared.request(ttt,success: { (reslut) in
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
    
    
    // MARK: - 懒加载
    lazy var mainTableView: UITableView = {
       let tableview = UITableView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: self.view.height), style: .plain)
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


// MARK: - 扩展
extension RSDMyShareViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: RSDMySharedCell! = tableView.dequeueReusableCell(withIdentifier: "mySharedCell") as? RSDMySharedCell
        if (cell == nil) {
            cell = RSDMySharedCell.init(style: .default, reuseIdentifier: "mySharedCell")
        }
        if self.mySharedArray.count != 0 {
            if self.signInt1 == 1 {
                let model: RSDScaneMySharedModel = self.mySharedArray[indexPath.section] as! RSDScaneMySharedModel
                cell.showScaneListCell(model: model, subArraysss: [self.mySharedSubArray[indexPath.section]])
            } else {
                let model: RSDMySharedModel = self.mySharedArray[indexPath.section] as! RSDMySharedModel
                cell.updateTab(model: model, subArraysss: [self.mySharedSubArray[indexPath.section]])
            }
            
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
//        else if section == self.mySharedArray.count - 1 {
//            return
//        }
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
        return self.mySharedArray.count
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
            var titleString = ""
            if self.signInt1 == 1 {
                titleString = "确定取消对该场景的分享吗"
            } else {
                titleString = "确定取消对该设备的分享吗"
            }
            let alertController = UIAlertController.init(title: "提示", message: titleString, preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                self.deletShareDevice()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell: RSDMySharedCell = tableView.cellForRow(at: indexPath) as! RSDMySharedCell
        let listVC = RSDMyShareDetailListVC()
        if self.signInt1 == 1 {
            let model: RSDScaneMySharedModel = self.mySharedArray[deletIndex] as! RSDScaneMySharedModel
            let tempArr: [Any] = [self.mySharedSubArray[indexPath.section]]
            let subArray: [Any] = tempArr.first as! Array
            listVC.listDataArray = subArray
            listVC.scraneID = model.sceneId!
        } else {
            let model: RSDMySharedModel = self.mySharedArray[deletIndex] as! RSDMySharedModel
            let tempArr: [Any] = [self.mySharedSubArray[indexPath.section]]
            let subArray: [Any] = tempArr.first as! Array
            listVC.listDataArray = subArray
            listVC.deviceId = model.device_id!
        }
        listVC.signInt2 = self.signInt1
        listVC.title = cell.titleLabel.text
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.mySharedArray.count != 0 {
            let tempArr: [Any] = [self.mySharedSubArray[indexPath.section]]
            let subArray: [Any] = tempArr.first as! Array
            if subArray.count == 1 {
                return 60 * PROPORTION_Y
            } else if subArray.count == 2 {
                return 75 * PROPORTION_Y
            } else if subArray.count > 2 {
                return 90 * PROPORTION_Y
            }
        }
        return 0
    }
}



