//
//  RootViewController.swift
//  自定义view
//
//  Created by ios on 2018/8/13.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//

import UIKit

class RSDRootViewController: UITabBarController,CustomBarbuttonDelegate {
    var myTabbar: RSDCustomTabBar!
    var rootNav: RSDNavigationController?
    

    //  图片
    let tabBarNormalImages = ["tabbar_equipment","tabbar_intelligentScenes","tabbar_intelligentScenes","tabbar_message","tabbar_me"]
    let tabBarTitles = ["家","场景","","消息","我"]
    let tabbarRootVC = [UIViewController(),UIViewController(),UIViewController(),UIViewController(),RSDMyCenterViewController()]
    
    
    
    func barButtonAction(sender: RSDCustomCenterButton) {
//        print(" RSDRootViewController---->CustomBarbuttonDelegate方法")
        self.selectedIndex = 2;
        let newVc: UIAlertController = UIAlertController.init(title: "分享", message: "无兄弟不篮球", preferredStyle: UIAlertControllerStyle.alert)
        self.present(newVc, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                newVc.dismiss(animated: true, completion: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let customTabbar: RSDCustomTabBar = RSDCustomTabBar.init(frame: self.tabBar.frame)
        self.setValue(customTabbar, forKey: "tabBar")
        customTabbar.delegateTabbar = self;
        //  创建子控制器
//        addDefaultChildViewControllers()
        let arrCount = self.tabBarNormalImages.count
        for i in 0..<arrCount {
            addChildViewController(controller: self.tabbarRootVC[i], title: self.tabBarTitles[i], imageName: self.tabBarNormalImages[i])
        }

        customTabbar.barTintColor = UIColor.groupTableViewBackground;

    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let indexs = tabBar.items?.index(of: item)
        animationWithIndex(index:indexs!)
    }
    
    func animationWithIndex(index:NSInteger) {
        let tabbarbuttonArray:NSMutableArray = [];
        for tabBarButton in self.tabBar.subviews {
            if (tabBarButton.isKind(of: NSClassFromString("UITabBarButton")!)) {
                tabbarbuttonArray.add(tabBarButton);
            }
        }
        
        (tabbarbuttonArray.object(at: index) as AnyObject).layer.add(createAnimation(keyPath: "transform.scale", toValue: 0.7), forKey: nil)
    }
    
    // 创建基础Animation
    func createAnimation (keyPath: String, toValue: CGFloat) -> CABasicAnimation {
        //创建动画对象
        let scaleAni = CABasicAnimation()
        //设置动画属性
        scaleAni.keyPath = keyPath
        //设置动画的起始位置。也就是动画从哪里到哪里。不指定起点,默认就从positoin开始
        scaleAni.fromValue = 1.3
        scaleAni.toValue = toValue
        //动画持续时间
        scaleAni.duration = 0.08;
        //动画重复次数
        scaleAni.repeatCount = 1
//        scaleAni.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        return scaleAni;
    }

    
    private func addChildViewController(controller: UIViewController, title:String, imageName:String){
        controller.tabBarItem.image = UIImage(named: imageName)
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "HL")
        controller.tabBarItem.title = title
        rootNav = RSDNavigationController()
        rootNav?.addChildViewController(controller)
        addChildViewController(rootNav!)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}





    /*

     import UIKit
     
     class TabBarController: UITabBarController {
     
     override func viewDidLoad() {
     super.viewDidLoad()
     addChildViewControllers()
     }
     
     private func addChildViewControllers(){
     addChildViewController(HomeViewController(), title: "礼物说", imageName: "tabbar_home")
     addChildViewController(HotViewController(), title: "热门", imageName: "tabbar_gift")
     addChildViewController(ClassifyViewController(), title: "分类", imageName: "tabbar_category")
     addChildViewController(MeViewController(), title: "我", imageName: "tabbar_me")
     }
     
     private func addChildViewController(controller: UIViewController, title:String, imageName:String){
     
     controller.tabBarItem.image = UIImage(named: imageName)
     controller.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
     controller.tabBarItem.title = title
     
     let nav = NavigationController()
     nav.addChildViewController(controller)
     addChildViewController(nav)
     }
     }
     
     作者：子祖
     链接：https://www.jianshu.com/p/aa745ec26f58
     來源：简书
     简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
     
     
     import UIKit
     
     class NavigationController: UINavigationController {
     
     override func viewDidLoad() {
     super.viewDidLoad()
     self.interactivePopGestureRecognizer!.delegate = nil;
     
     let appearance = UINavigationBar.appearance()
     appearance.translucent = false
     appearance.setBackgroundImage(UIImage.imageWithColor(Color_NavBackground, size: CGSizeMake(1, 1)), forBarMetrics: UIBarMetrics.Default)
     var textAttrs: [String : AnyObject] = Dictionary()
     textAttrs[NSForegroundColorAttributeName] = UIColor.whiteColor()
     textAttrs[NSFontAttributeName] = UIFont.systemFontOfSize(16)
     appearance.titleTextAttributes = textAttrs
     }
     
     lazy var backBtn: UIButton = UIButton(backTarget: self, action: #selector(NavigationController.backBtnAction))
     
     func backBtnAction() {
     self.popViewControllerAnimated(true)
     }
     
     override func pushViewController(viewController: UIViewController, animated: Bool) {
     if self.childViewControllers.count > 0 {
     viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
     viewController.hidesBottomBarWhenPushed = true
     }
     super.pushViewController(viewController, animated: animated)
     }
     
     }
     
     作者：子祖
     链接：https://www.jianshu.com/p/aa745ec26f58
     來源：简书
     简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
     */



/*
 /// 添加默认的页面
 fileprivate func addDefaultChildViewControllers() {
 let vc1 = ViewController()
 vc1.view.backgroundColor = UIColor.white
 let item1 : UITabBarItem = UITabBarItem (title: "第一页面", image: UIImage(named: "tabbar_equipment"), selectedImage: UIImage(named: "tabbar_equipmentHL"))
 let nav1 = UINavigationController(rootViewController: vc1);
 vc1.tabBarItem = item1
 
 
 let vc2 = UIViewController()
 vc2.view.backgroundColor = UIColor.lightGray
 let item2 : UITabBarItem = UITabBarItem (title: "第二页面", image: UIImage(named: "tabbar_intelligentScenes"), selectedImage: UIImage(named: "tabbar_intelligentScenesHL"))
 let nav2 = UINavigationController(rootViewController: vc2);
 vc2.tabBarItem = item2
 
 let vc3 = UIViewController()
 vc3.view.backgroundColor = UIColor.purple
 let item3 : UITabBarItem = UITabBarItem (title: "", image: UIImage(named: ""), selectedImage: UIImage(named: ""))
 let nav3 = UINavigationController(rootViewController: vc3);
 vc3.tabBarItem = item3
 
 let vc4 = UIViewController()
 vc4.view.backgroundColor = UIColor.orange
 let item4 : UITabBarItem = UITabBarItem (title: "第四页面", image: UIImage(named: "tabbar_message"), selectedImage: UIImage(named: "tabbar_messageHL"))
 let nav4 = UINavigationController(rootViewController: vc4);
 vc4.tabBarItem = item4
 
 let vc5 = MyCenterViewController()
 vc5.view.backgroundColor = UIColor.yellow
 let item5 : UITabBarItem = UITabBarItem (title: "第五页面", image: UIImage(named: "tabbar_me"), selectedImage: UIImage(named: "tabbar_meHL"))
 let nav5 = UINavigationController(rootViewController: vc5);
 vc5.tabBarItem = item5
 
 //        self.viewControllers = [vc1, vc2]
 let tabArray = [nav1,nav2,nav3,nav4,nav5]
 self.viewControllers = tabArray
 
 }
 */
