//
//  MyCenterViewController.swift
//  自定义view
//
//  Created by ios on 2018/8/14.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//

import UIKit
import Kingfisher

class RSDMyCenterViewController: UIViewController {
    let titleArr:NSArray = [["昵称"],["设备分享","场景分享"],["产品介绍","常见问题","意见反馈"],["设置"]]
    let imgArray: NSArray = [["skjfk"],["myEquipmentshare","myScaneShare"],["my_pruductReduce","my_usualProblem","my_adviceBack"],["my_seting"]];

    let  PROPORTION_Y = ((UIScreen.main.bounds.size.height * 1.0)/568)

    lazy var mainTableView : UITableView = {
       let mainTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: view.height - RSDTabbarHeight), style:.grouped)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.backgroundColor = UIColor.groupTableViewBackground
        return mainTableView
    }()
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func upDateHeadImage(_ nofi: Notification) {
//        self.mainTableView.reloadData()
        let dict = nofi.userInfo
        var newUrlString = dict!["userHeadImg"] as! String
        if !newUrlString.contains("http") {
            newUrlString = RSDBaseUrl_Real + newUrlString
        }
        let url = URL(string: newUrlString)
        let cell: RSDUserCenterTableViewCell = self.mainTableView.cellForRow(at: NSIndexPath.init(row: 0, section: 0) as IndexPath) as! RSDUserCenterTableViewCell;
        cell.headImgView?.kf.setImage(with: ImageResource(downloadURL: url!), placeholder: UIImage(named: "myhead"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    @objc  func reFalshUserData() {
        self.mainTableView.reloadData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我";
        
        NotificationCenter.default.addObserver(self, selector: #selector(reFalshUserData), name: NSNotification.Name(rawValue: "upDateUserInfo"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.upDateHeadImage(_:)), name: NSNotification.Name(rawValue: "upDateUserHeadImage"), object: nil)
//        let tmpCycleScrollView: RSDCycleScrollView = RSDCycleScrollView.cycleScrollView(withFrame: CGRect.init(x: 0, y: 64, width: RSDScreenWidth, height: 250), delegate: self, placeholderImage: UIImage(),isOnBottom: true)
////        tmpCycleScrollView.images = [UIImage.init(named: "lead01"),UIImage.init(named: "lead02"),UIImage.init(named: "lead03")] as! [UIImage]
//        tmpCycleScrollView.imageUrlStrings = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502367139&di=2ff6ffaa08b7299102ec84c8c8616c9d&imgtype=jpg&er=1&src=http%3A%2F%2Fimg9.zol.com.cn%2Fpic%2Fyouxi%2F800_36%2F366903.jpg",
//                                              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502367158&di=cd3492acccb7f7bff1e4f92f128eba08&imgtype=jpg&er=1&src=http%3A%2F%2Fimg9.zol.com.cn%2Fpic%2Fyouxi%2F800_38%2F384531.jpg",
//                                              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502367209&di=c5ea6d23987ac893ce900ca584a0a90c&imgtype=jpg&er=1&src=http%3A%2F%2Fimage14-c.poco.cn%2Fmypoco%2Fmyphoto%2F20130327%2F11%2F64758065201303271100381930863592037_005_640.jpg",
//                                              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502367369&di=a98c285235c07c57c7a468632e363fd5&imgtype=jpg&er=1&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Flvpics%2Fw%3D1000%2Fsign%3Db9eb46ab53fbb2fb342b5c127f7a21a4%2Fe850352ac65c1038b3468034b4119313b07e8908.jpg"]
//                tmpCycleScrollView.titleNameArray = ["111111说道说道1了11","22赛诺菲金卡戴珊复健科2222222","33333s节省空间快乐十分333","ww4444节省空间快乐十分333"]
////                tmpCycleScrollView.isShowCircleDotBool = false
//        tmpCycleScrollView.showCycleScrollView()
//        self.view.addSubview(tmpCycleScrollView)
//        return
        
        if #available(iOS 11.0, *) {
            self.mainTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        };

        weak var weakSelf = self
        self.mainTableView.rsd_Header = RSDmj_freshHeader_Nomal() {
            weakSelf?.mainTableView.reloadData()
            weakSelf?.mainTableView.rsd_Header.endRefreshing()
        }
//        self.mainTableView.rsd_Footer = RSDmj_freshFooter_Nomal() {
//            self.mainTableView.reloadData()
//            self.mainTableView.rsd_Footer.endRefreshing()
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() +  10) {
            self.mainTableView.rsd_Header.endRefreshing()
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() +  20) {
//            self.mainTableView.rsd_Footer.endRefreshing()
//        }
        self.mainTableView.register(RSDUserCenterTableViewCell.classForCoder(), forCellReuseIdentifier: "cellString")
        self.view.addSubview(self.mainTableView)
        self.mainTableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-RSDTabbarHeight)
        }
//        if(self.mainTableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) ){
//            self.mainTableView.separatorInset = .zero
//        }
//        if(self.mainTableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) ){
//            self.mainTableView.layoutMargins = .zero
//        }
        
//        作者：纯洁的坏蛋
//        链接：https://www.jianshu.com/p/e894f165fcd9
//        來源：简书
//        简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
//        hildTableViewExtraCellLineHidden(tableView: self.mainTableView)
//        self.mainTableView.tableFooterView?.addSubview(UIView())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RSDMyCenterViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 10.0 * PROPORTION_Y
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        if section != 0  {
            view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 10 * PROPORTION_Y)
//            view.backgroundColor = UIColor.red
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80 * PROPORTION_Y
        }
        return 45.0 * PROPORTION_Y
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let  arrCount = self.titleArr.count
        return arrCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let  arr = self.titleArr.object(at: section) as! NSArray
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cellString"
        var cell:RSDUserCenterTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RSDUserCenterTableViewCell
        if (cell == nil) {
            cell = RSDUserCenterTableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell?.accessoryType = .disclosureIndicator
        cell.setUpDataForTableViewCell(titleArr: titleArr, index: indexPath)
        let imgArr = imgArray.object(at: indexPath.section) as? NSArray
        cell.headImgView?.image = UIImage.init(named: (imgArr?.object(at: indexPath.row) as? String)!)
        
        if indexPath.section == 0 {
            cell.titleLabel?.text = RSDUserLoginModel.users.realname.count != 0 ? RSDUserLoginModel.users.realname : "点此设置昵称"
            let headImgString = RSDUserLoginModel.users.icon
            var newUrlString: String = ""
            if !headImgString.contains("http") {
                newUrlString = RSDBaseUrl_Real + headImgString
            } else {
                newUrlString = headImgString
            }
            let url = URL(string: newUrlString)
            cell.headImgView?.kf.setImage(with: ImageResource(downloadURL: url!), placeholder: UIImage(named: "myhead"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell:RSDUserCenterTableViewCell = tableView.cellForRow(at: indexPath) as! RSDUserCenterTableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        var newVC : UIViewController?
        newVC = RSDLoginVC()
        if indexPath.row == 0 && indexPath.section == 0 {
            newVC = RSDPersonalInformationVC()
        } else if currentCell.titleLabel?.text == "产品介绍" {
            newVC = RSDProductIntroduceVC()
        } else if currentCell.titleLabel?.text == "设备分享" {
            newVC = RSDequimentShareVC()
            (newVC as! RSDequimentShareVC) .signInt = 0
        } else if currentCell.titleLabel?.text == "场景分享" {
            newVC = RSDequimentShareVC()
            (newVC as! RSDequimentShareVC).signInt = 1
        } else if currentCell.titleLabel?.text == "意见反馈" {
            newVC = RSDAdviceBackVC()
        } else if currentCell.titleLabel?.text == "常见问题" {
            newVC = RSDCommonQuestionVC()
        }
        newVC?.title = currentCell.titleLabel?.text
        newVC?.view.backgroundColor = RSDBGViewColor
        self.navigationController?.pushViewController(newVC!, animated: true)
        
    }
}


//    override
//去除掉指定的cell 的分割线

//func filerCellSeperateLine(cell:UITableViewCell) {
//    //   cell.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0)
//    let subviews = cell.subviews
//    for subview in subviews {
//        if subview.isKind(of: NSClassFromString("_UITableViewCellSeparatorView")!) {
//            subview.isHidden = true
//        }
//        //            if let separatorViewClass: AnyClass = NSClassFromString("_UITableViewCellSeparatorView") {
//        //            }
//    }
//}

//for (UIView *subview in self.contentView.superview.subviews) {
//    if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
//        subview.hidden = NO;
//    }
//}

