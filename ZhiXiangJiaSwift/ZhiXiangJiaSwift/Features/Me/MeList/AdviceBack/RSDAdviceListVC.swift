//
//  RSDAdviceListVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/30.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import SVProgressHUD

class RSDAdviceListVC: UIViewController {
    private var listArray: [Any] = Array.init() // 列表数组

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RSDBGViewColor
        self.title = "历史反馈"
        setUpUI()
        getMyAdviceListData()

    }
    // MARK: - Private
    //MARK:获取我分享的列表数据
    private func getMyAdviceListData() {
        self.listArray.removeAll()
        var parme: [String: Any] = Dictionary.init()
        parme["phone"] = RSDUserLoginModel.users.loginname
//        SVProgressHUD.show()
        weak var weakSelf = self
        RSDNetWorkManager.shared.request(RSDPeosonalCenterApi.getMyHistoryAdviceListData(parme), success: { (reslut) in
            SVProgressHUD.dismiss()
            print(reslut)
            if reslut.count == 0 {
                SVProgressHUD.show(withStatus: "暂无历史反馈列表")
                return
            }
            print(dataToDictionary(data: reslut) ?? "")
            let dic: NSDictionary = dataToDictionary(data: reslut)! as NSDictionary
            let codeStr = dic["code"] as! String
            if (codeStr != "0000") {
                SVProgressHUD.showError(withStatus: dic["msg"] as? String)
                return
            } else {
                let tempArray: NSArray = dic.object(forKey: "resultlist") as! NSArray
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
            make.bottom.top.left.right.equalToSuperview()
        }
        self.mainTableView.tableFooterView = UIView()
        self.mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "mySharedCell")

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

extension   RSDAdviceListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "mySharedCell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "mySharedCell")
        }
//        if self.listDataArray?.count != 0 {
//            let subDic: [String: Any] =  self.listDataArray![indexPath.section]  as! Dictionary
//            var phoneStr = ""
//            if self.signInt2 == 1 {
//                phoneStr = subDic["loginname"] as! String
//                cell.accessoryType = .none
//            } else {
//                cell.accessoryType = .disclosureIndicator
//                phoneStr = subDic["phone"] as! String
//            }
            cell.textLabel?.text = "分享给了: "
//        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    
    
    
}
