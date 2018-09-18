
//
//  RSDAddDeviceAndScanListVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/11.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher

protocol AddDeviceAndScaneDelegate: NSObjectProtocol {
    func chooseDeviceAndScaneMethod(selectArray: [Any])
}

class RSDAddDeviceAndScanListVC: UIViewController {
    var signInt4 = 0

    private var dataListArray: [Any] = Array.init()//列表数据
    private var selectDataArray: [Any] = Array.init()//选择的数据
    private var btnStateArray: [String] = Array.init()//状态数组

    weak var delegates: AddDeviceAndScaneDelegate?


    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getShareData()
        self.setUpUI()
    }
    
    
    // MARK: - Private
    private func getShareData() {
        var parme: [String: Any] = Dictionary.init()
        parme["token"] = RSDUserLoginModel.users.token
        var ttt = RSDPeosonalCenterApi.getUserEquimentListData(parme)
        if self.signInt4 == 1 {
            ttt = RSDPeosonalCenterApi.getUserInteligentScaneListData(parme)
        }
        weak var weakSelf = self
        RSDNetWorkManager.shared.request(ttt, success: { (response) in
            //            let jsonDic = JSON(response)
            let dic: NSDictionary = dataToDictionary(data: response)! as NSDictionary
            let  codeStr = dic["code"] as? String
            if (codeStr == "0000") {
                let tempArray: [Any] = dic["resultlist"] as! [Any]
                for item in tempArray {
                    if self.signInt4 == 1 {
                        let scaneModel = RSDScaneListModel.init()
                        scaneModel.getUserScaneListModel(mainDic: item as! [String: Any])
                        if RSDUserLoginModel.users.id == scaneModel.owner! {
                            weakSelf?.dataListArray.append(scaneModel)
                        }
                    } else {
                        let deviceModel = RSDDevicesModel.init()
                        deviceModel.getDeviceModelWithDic(dic: item as! [String : Any])
                        if deviceModel.device == RSD_EQUIPMENT_TYPE_WIFI_SCENESWITCH || deviceModel.device == RSD_EQUIPMENT_TYPE_WIFI_VOICEHOME || (deviceModel.device == RSD_EQUIPMENT_TYPE_433_CIRCLESWITCH_NO_POWER && deviceModel.model == RSD_CIRCLESWITCH_NO_POWER_TYPE_433_A2) || deviceModel.device == RSD_EQUIPMENT_TYPE_433_EMITTER_NO_POWER || (deviceModel.device == RSD_EQUIPMENT_TYPE_433_CIRCLESWITCH_NO_POWER && deviceModel.model == RSD_CIRCLESWITCH_NO_POWER_TYPE_433_A4) {
                            continue
                        }
                        //FIXME: - 这里条件筛选不全 可能有问题 以后再说
                        if deviceModel.mainSubType == 1 {
                            weakSelf?.dataListArray.append(item)
                        }
                    }
                }
                if weakSelf?.dataListArray.count != 0 {
                    for _ in 0...((weakSelf?.dataListArray.count)! - 1) {
                        weakSelf?.btnStateArray.append("0")
                    }
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
        view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.navRightBtn)
 
        let bottomBtnView = UIView.init()
        view.addSubview(bottomBtnView)
        bottomBtnView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(70)
        }
        
        bottomBtnView.addSubview(self.addDeviceBtn)
        self.addDeviceBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        view.addSubview(self.mainTableView)
//        self.mainTableView.backgroundColor = RSDBGViewColor
        self.mainTableView.tableFooterView = UIView()
        self.mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "mySharedCell")
        self.mainTableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomBtnView.snp.top)
        }
    }
    
    
    // MARK: - 懒加载
    lazy var addDeviceBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("添加设备", for: .normal)
        if self.signInt4 == 1 {
            btn.setTitle("添加场景", for: .normal)
        }
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.navBackGroundColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(self.addDeviceBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var mainTableView: UITableView = {
        let tableview = UITableView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: 100), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0)
        return tableview
    }()
    
    lazy var navRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        btn.setTitle("全选", for: .normal)
        btn.setTitle("取消全选", for:.selected)
        btn.addTarget(self, action: #selector(self.chooseDevice(_:)), for: .touchUpInside)
        return btn
    }()

    
    // MARK: - BtnClick
    @objc private func chooseDevice(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {//选中所有
            for (n, c) in self.btnStateArray.enumerated() {
                if c == "0" {
                    self.btnStateArray.replaceSubrange(Range(n..<n+1), with: ["1"])
                }
            }
        } else {// 取消所有
            for (n, c) in self.btnStateArray.enumerated() {
                if c == "1" {
                    self.btnStateArray.replaceSubrange(Range(n..<n+1), with: ["0"])
                }
            }
        }
        self.mainTableView.reloadData()
    }
    
    
    // MARK:添加设备 代理回调上个页面
    @objc private func addDeviceBtnClick() {
        for (index, item) in self.btnStateArray.enumerated() {
            if item == "1" {
                self.selectDataArray.append(self.dataListArray[index])
            }
        }
        self.delegates?.chooseDeviceAndScaneMethod(selectArray: self.selectDataArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: 检查 是否所有设备都被选中
    private func checkDeviceIsAllChoose() {
        self.mainTableView.reloadData()
        if self.btnStateArray.contains("0") {
            self.navRightBtn.isSelected = false
            return //有等于0 表示没有全选
        }
        print("//都等于1 全选中") //都等于1 全选中
        self.navRightBtn.isSelected = true
    }
    
    // MARK:cell 按钮点击
    @objc private func click(_ btn: UIButton) {
        let btnIndex = btn.tag - 999
        if btn.isSelected {
            self.btnStateArray.replaceSubrange(Range(btnIndex..<btnIndex + 1), with: ["0"])
        } else {
            self.btnStateArray.replaceSubrange(Range(btnIndex..<btnIndex + 1), with: ["1"])
        }
        btn.isSelected = !btn.isSelected
        self.checkDeviceIsAllChoose()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



// MARK: - 扩展
extension RSDAddDeviceAndScanListVC: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "mySharedCell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "mySharedCell")
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        let  showAddBtn = UIButton.init(type: .custom)
        cell.contentView.addSubview(showAddBtn)
        showAddBtn.setImage(UIImage.init(named: "my_center_device_share_selectedImg"), for: .selected)
        showAddBtn.setImage(UIImage.init(named: "my_center_device_share_unSelectedImg"), for: .normal)
        showAddBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-40)
        }
        showAddBtn.addTarget(self, action: #selector(self.click(_:)), for: .touchUpInside)
        showAddBtn.tag = 999 + indexPath.row

        if self.dataListArray.count != 0 {
            if self.signInt4 == 1 {
                let scaneModel: RSDScaneListModel = self.dataListArray[indexPath.row]  as! RSDScaneListModel
                let url: URL = KEY_STING.getSuccessIconImageUrl(oldString: scaneModel.picurl!)
                cell.imageView?.kf.setImage(with: ImageResource(downloadURL: url), placeholder: UIImage(named: "DefaultModeImage"), options: nil, progressBlock: nil, completionHandler: nil)
                cell.textLabel?.text = scaneModel.name
            } else {
                let subDic: [String: Any] = self.dataListArray[indexPath.row]  as! Dictionary
                let phoneStr = subDic["deviceName"] as! String
                let typeString = subDic["device"] as! String
                let modelString = subDic["model"] as! String
                cell.imageView?.image = RSDEquipmentPubLicFun.shareInstance.getDeviceImage(type: typeString, model: modelString)
                cell.textLabel?.text = phoneStr
            }
            if self.btnStateArray[indexPath.row] == "0" {
                showAddBtn.isSelected = false
            } else {
                showAddBtn.isSelected = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        let addBtn: UIButton = cell.contentView.viewWithTag(999 + indexPath.row) as! UIButton
        let btnIndex = addBtn.tag - 999
        if self.btnStateArray[btnIndex] == "0" {
            self.btnStateArray[btnIndex] = "1"
            addBtn.isSelected = true
        } else {
            self.btnStateArray[btnIndex] = "0"
            addBtn.isSelected = false
        }
        self.checkDeviceIsAllChoose()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
