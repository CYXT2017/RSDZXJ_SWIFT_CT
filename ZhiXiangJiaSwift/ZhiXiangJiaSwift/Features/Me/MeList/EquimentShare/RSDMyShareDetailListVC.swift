//
//  RSDMyShareDetailListVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/7.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import SVProgressHUD

class RSDMyShareDetailListVC: UIViewController {
    var signInt2 = 0

    var listDataArray: [Any]?
    private var deletIndex: Int = 0
    var deviceId: String = ""
    var scraneID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    private func setUpUI() {
        view.addSubview(self.mainTableView)
        self.mainTableView.backgroundColor = RSDBGViewColor
        self.mainTableView.tableFooterView = UIView()
        self.mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "mySharedCell")
        if #available(iOS 11.0, *) {
            self.mainTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        };
    }
    private func deletShareDevice() {
        let subDic: [String: Any] =  self.listDataArray![deletIndex]  as! Dictionary
        var phoneStr = ""
        var phoneArr: [Any] = Array.init()
        var parm: [String: Any] = Dictionary.init()
        if self.signInt2 == 1 {
            phoneStr = subDic["loginname"] as! String
            parm["sceneId"] = self.scraneID
        } else {
            phoneStr = subDic["phone"] as! String
            parm["deviceid"] = self.deviceId
        }
        phoneArr.append(phoneStr)
        parm["phonelist"] = phoneArr

        //        parm["token"] = RSDUserLoginModel.users.token
        weak var weakSelf = self
        SVProgressHUD.show(withStatus: "取消分享中...")
        var ttt = RSDPeosonalCenterApi.deleMyShareDeviceData(parm)
        if self.signInt2 == 1 {
            ttt = RSDPeosonalCenterApi.deletMyShareScaneListData(parm)
        }

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


extension RSDMyShareDetailListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "mySharedCell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "mySharedCell")
        }
        if self.listDataArray?.count != 0 {
            let subDic: [String: Any] =  self.listDataArray![indexPath.section]  as! Dictionary
            var phoneStr = ""
            if self.signInt2 == 1 {
                phoneStr = subDic["loginname"] as! String
            } else {
                phoneStr = subDic["phone"] as! String
            }
            cell.textLabel?.text = "分享给了: " +  phoneStr
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let views = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 10))
        view.backgroundColor = RSDBGViewColor
        return views
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listDataArray!.count
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
            let subDic: [String: Any] =  self.listDataArray![deletIndex]  as! Dictionary
            var phoneStr = ""
            if self.signInt2 == 1 {
                phoneStr = subDic["loginname"] as! String
            } else {
                phoneStr = subDic["phone"] as! String
            }
            let msgStr = "确定取消对" + phoneStr + "的分享吗？"
            let alertController = UIAlertController.init(title: "提示", message: msgStr, preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                self.deletShareDevice()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.signInt2 == 1 {
            return
        }
        let FuncConfigurationVC = RSDFuncConfigurationVC()
        FuncConfigurationVC.dataDic = self.listDataArray?[indexPath.section] as? [String : Any]
        self.navigationController?.pushViewController(FuncConfigurationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * PROPORTION_Y
    }
}
