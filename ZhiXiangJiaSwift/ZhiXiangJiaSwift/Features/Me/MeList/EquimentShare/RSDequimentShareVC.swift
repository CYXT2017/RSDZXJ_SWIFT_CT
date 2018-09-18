//
//  RSDequimentShareVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/30.
//  Copyright © 2018年 rsdznjj. All rights reserved.
// 

import UIKit
import DNSPageView
class RSDequimentShareVC: UIViewController {
    var signInt = 0 //标记
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //修改第三方库 添加通知 判断点击回调
        NotificationCenter.default.addObserver(self, selector: #selector(self.showOrHideNavRightBtn(_:)), name: NSNotification.Name(rawValue: "getCurrentIndexNotif"), object: nil)
        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        //        style.isTitleScrollEnable = true
        //        style.isScaleEnable = true
        //        style.isShowBottomLine = true
        style.isContentScrollEnable = false
        style.titleSelectedColor = UIColor.navBackGroundColor
        style.titleColor = UIColor.gray
//        style.bottomLineColor = UIColor.navBackGroundColor
//        style.bottomLineHeight = 2
        let titles = ["我分享的","被分享的"]
        let rsdMyShareVC = RSDMyShareViewController()
        rsdMyShareVC.signInt1 = self.signInt
      
        let rsdSharedVC = RSDSharedMeViewController()
        rsdSharedVC.signInt1 = self.signInt

        let viewControllers:[UIViewController] = [rsdMyShareVC,rsdSharedVC]
        
        for vc in viewControllers{
            self.addChildViewController(vc)
        }
        let pageView = DNSPageView(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height:view.height), style: style, titles: titles, childViewControllers: viewControllers)
        pageView.backgroundColor = RSDBGViewColor
//        pageView.titleView.delegate = self
        view.addSubview(pageView)
        if pageView.titleView.currentIndex == 0 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.navRightBtn)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private
    @objc func showOrHideNavRightBtn(_ nofi: Notification) {
        //        self.mainTableView.reloadData()
        let dict = nofi.userInfo
        let index = dict!["currentIndex"] as! Int
        if index == 0 {
            self.creatNav()
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: UIView())
        }
    }
    
    func creatNav() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.navRightBtn)
    }
    
    @objc  private  func addDoing() {
        let addVC = RSDAddShareVC()
        addVC.title = "添加分享"
        addVC.signInt3 = self.signInt
//        addVC.view.backgroundColor = UIColor.white*****假的一比 这个比居然是罪魁祸首 去除导航栏底部的线条
        self.navigationController?.pushViewController(addVC, animated: true)
    }

    // MARK: - 懒加载
    lazy var navRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "scene_right_add_normal"), for: .normal)
        btn.addTarget(self, action: #selector(self.addDoing), for: .touchUpInside)
        return btn
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 }

