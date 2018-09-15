//
//  RSDScaneShareVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/30.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import DNSPageView

class RSDScaneShareVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.titleSelectedColor = UIColor.black
        style.titleColor = UIColor.gray
        
        let titles = ["我分享的","被分享的"]
        let viewControllers:[UIViewController] = [RSDScaneMyShareViewController(),RSDScaneSharedMyViewController()]
        
        for vc in viewControllers{
            self.addChildViewController(vc)
        }
        let pageView = DNSPageView(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height:view.height), style: style, titles: titles, childViewControllers: viewControllers)
        pageView.backgroundColor = RSDBGViewColor
        view.addSubview(pageView)
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
