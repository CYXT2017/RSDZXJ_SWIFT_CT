//
//  RSDScaneShareVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/30.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//这个文件夹除了model有用 其余都没用上

import UIKit
import DNSPageView

class RSDScaneShareVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showOrHideNavRightBtn(_:)), name: NSNotification.Name(rawValue: "getCurrentIndexNotif"), object: nil)

        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.titleSelectedColor = UIColor.black
        style.titleColor = UIColor.gray
        style.isContentScrollEnable = false

        let titles = ["我分享的","被分享的"]
        let viewControllers:[UIViewController] = [RSDScaneMyShareViewController(),RSDScaneSharedMyViewController()]
        
        for vc in viewControllers{
            self.addChildViewController(vc)
        }
        let pageView = DNSPageView(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height:view.height), style: style, titles: titles, childViewControllers: viewControllers)
        pageView.backgroundColor = RSDBGViewColor
        view.addSubview(pageView)
        if pageView.titleView.currentIndex == 0 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.navRightBtn)
        }
    }

    lazy var navRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "scene_right_add_normal"), for: .normal)
        btn.addTarget(self, action: #selector(self.addDoing), for: .touchUpInside)
        return btn
    }()

    @objc  private  func addDoing() {
        let addVC = RSDAddShareVC()
        addVC.title = "添加分享"
        //        addVC.view.backgroundColor = UIColor.white*****假的一比 这个比居然是罪魁祸首 去除导航栏底部的线条
        self.navigationController?.pushViewController(addVC, animated: true)
    }

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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
