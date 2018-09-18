//
//  RSDIphoneContactVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/18.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

protocol RSDChooseIphoneContactDelegate: AnyObject {
    func seleIphoneContact(iphoneString: String)
}

class RSDIphoneContactVC: UIViewController {
    weak var delegate: RSDChooseIphoneContactDelegate?
    
    var tableView: UITableView!
    /// 所有联系人信息的字典
    var addressBookSouce = [String:[RSDIphoneContactModle]]()
    /// 所有分组的key值
    var keysArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.title = "联系人"
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60.0
        view.addSubview(tableView)
        
        
        // MARK: - 获取A~Z分组顺序的通讯录
        RSDGetIphoneContact.getOrderAddressBook(addressBookInfo: { (addressBookDict, nameKeys) in
            var tempDic = [String:[RSDIphoneContactModle]]()
            for i in 0 ..< nameKeys.count {
                let key = nameKeys[i]
                var sectionArray = addressBookDict[key]
                if (sectionArray?.count)! >= 2 {
                    sectionArray?.remove(at: 0)
                }
                tempDic[key] = sectionArray
            }
            
            self.addressBookSouce = tempDic  // 所有联系人信息的字典
            self.keysArray = nameKeys       // 所有分组的key值
            // 刷新tableView
            self.tableView.reloadData()
            
        }, authorizationFailure: {
            let alertView = UIAlertController.init(title: "提示", message: "请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBookSwift访问您的通讯录", preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction.init(title: "现在就去", style: .default, handler: { (action) in
                let url = URL(string:"APP-Prefs:root=General&path=ACCESSIBILITY")//UIApplicationOpenSettingsURLString
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            })
            let confirm = UIAlertAction.init(title: "知道啦", style: UIAlertActionStyle.cancel, handler:nil)
            alertView.addAction(cancel)
            alertView.addAction(confirm)
            self.present(alertView, animated: true, completion: nil)
        })
    }
    
    deinit{
        print("挂了")
    }
    
}

extension RSDIphoneContactVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = keysArray[section]
        let array = addressBookSouce[key]
        
        return (array?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keysArray[section]
    }
    
    // 右侧索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keysArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        
        let modelArray = addressBookSouce[keysArray[indexPath.section]]
        let model = modelArray![indexPath.row]
        
        
        cell?.textLabel?.text = model.name
        cell?.imageView?.image = model.headerImage ?? UIImage.init(named: "defult")
        cell?.imageView?.layer.cornerRadius = 30
        cell?.imageView?.clipsToBounds = true
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modelArray = addressBookSouce[keysArray[indexPath.section]]
        let model = modelArray![indexPath.row]
        
        let alertViewVC = UIAlertController.init(title: "确认选择" + model.name, message:"\(model.mobileArray)", preferredStyle: UIAlertControllerStyle.alert)
        let confirm = UIAlertAction.init(title: "确定", style: .cancel) { (action) in
            let str = model.mobileArray[indexPath.row]
            self.delegate?.seleIphoneContact(iphoneString: str)
            self.navigationController?.popViewController(animated: true)
        }
        alertViewVC.addAction(confirm)
        self.present(alertViewVC, animated: true, completion: nil)
        
    }
    
}
