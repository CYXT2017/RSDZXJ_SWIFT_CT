//
//  RSDNavigationController.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/22.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//

import UIKit

class RSDNavigationController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate{

    var arrayScreenshot : NSMutableArray!
    var panGesture : UIPanGestureRecognizer?
    var webURL : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.isEnabled = !RSDIsCanleSystemPan
        arrayScreenshot = NSMutableArray.init()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture!)
        panGesture?.delegate = self
        defaultSetting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view == self.view && gestureRecognizer.location(in: view).x < (RSDDistanceToStart == 0 ? UIScreen.main.bounds.width : RSDDistanceToStart)) {
            return true
            //以下代码没什么用 但是加上之后 以后的创建的文件都要继承RSDGestureBaseController 所以还是去掉好了
            let topView = topViewController as! RSDGestureBaseController
            if (!topView.isEnablePanGesture!) {
                return false;
            } else {
                let gesture = gestureRecognizer as! UIPanGestureRecognizer
                let translate = gesture.translation(in :view)
                let possible = translate.x != 0 && fabs(translate.y) == 0;
                
                if (possible){
                    return true
                }else {
                    return false
                }
            }
        }
        return false
    }
        
    func defaultSetting(){
        //导航栏的背景色与标题设置
        self.navigationBar.barStyle = UIBarStyle.default
        self.navigationBar.barTintColor = UIColor.navBackGroundColor
        self.navigationBar.isTranslucent = false
        //         self.navigationBar.titleTextAttributes = {[
        //            kCTForegroundColorAttributeName: UIColor.white,
        //            kCTFontAttributeName: UIFont(name: "Heiti SC", size: 20)!
        //            ]}() as [NSAttributedStringKey : Any]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationBar.tintColor = UIColor.white
        let dict:NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20)]
        //标题颜色
        self.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : AnyObject]
        //        self.navigationBar.isHidden = false;
        self.navigationBar.isTranslucent = false
    }

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) || otherGestureRecognizer.isKind(of: NSClassFromString("UIPanGestureRecognizer")!)){
            return false
        }
        return true
    }
    
    @objc func handlePanGesture(_ panGesture : UIPanGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootVC = appDelegate.window?.rootViewController
        let presentedVC = rootVC?.presentedViewController
        if (self.viewControllers.count == 1) {
            return
        }
        if (panGesture.state == UIGestureRecognizerState.began) {
            appDelegate.gestureBaseView?.isHidden = false;
        }
        else if (panGesture.state == UIGestureRecognizerState.changed) {
            let point_inView = panGesture.translation(in: view)
            if (point_inView.x >= 10) {
                rootVC?.view.transform = CGAffineTransform(translationX: point_inView.x - 10, y: 0)
                presentedVC?.view.transform = CGAffineTransform(translationX: point_inView.x - 10, y: 0)
            }
            //pop时 上个页面截图随手势移动
            var originalRect = appDelegate.gestureBaseView?.frame
            var newX = -RSDDistanceToLeft + point_inView.x/5
            if newX >= 0 {
                newX = 0
            }
            originalRect?.origin.x = newX
            appDelegate.gestureBaseView?.frame = originalRect!
        }
        else if (panGesture.state == UIGestureRecognizerState.ended) {
            appDelegate.gestureBaseView?.backgroundColor = UIColor.white
            let point_inView = panGesture.translation(in: view)
            if (point_inView.x >= RSDDistanceToLeft) {
                UIView.animate(withDuration: 0.3, animations: {
                    rootVC?.view.transform = CGAffineTransform(translationX: RSDScreenWidth, y: 0)
                    presentedVC?.view.transform = CGAffineTransform(translationX: RSDScreenWidth, y: 0)
                    var originalRect = appDelegate.gestureBaseView?.frame
                    originalRect?.origin.x = 0
                    appDelegate.gestureBaseView?.frame = originalRect!
                }, completion: { (true) in
                    self.popViewController(animated: false)
                    rootVC?.view.transform = CGAffineTransform.identity
                    presentedVC?.view.transform = CGAffineTransform.identity
                    appDelegate.gestureBaseView?.isHidden = true
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    rootVC?.view.transform = CGAffineTransform.identity
                    presentedVC?.view.transform = CGAffineTransform.identity
                }, completion: { (true) in
                    appDelegate.gestureBaseView?.isHidden = true
                })
            }
        }
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (viewControllers.count == 0) {
            return super.pushViewController(viewController, animated: animated)
        }else if (viewControllers.count>=1) {
            viewController.hidesBottomBarWhenPushed = true//隐藏二级页面的taRSDar
            
            let backImg = UIImage.init(named:"scene_left_back_normal")
            //导航栏返回按钮自定义
            let backButton = UIButton(frame:CGRect.init(x:0, y: 0, width: (backImg?.size.width)!, height: (backImg?.size.height)!))
            backButton.setImage(UIImage.init(named:"scene_left_back_normal"), for: UIControlState.normal)
            backButton.addTarget(self, action:#selector(self.didBackButton(sender:)), for: UIControlEvents.touchUpInside)
            backButton.sizeToFit()
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView:backButton)
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        UIGraphicsBeginImageContextWithOptions(CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), true, 0);
        appDelegate.window?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        arrayScreenshot.add(image!)
        appDelegate.gestureBaseView?.imgView?.image = image
        super.pushViewController(viewController, animated: animated)
    }
    //点击事件
    @objc func didBackButton(sender:UIButton){
        self.popViewController(animated:true)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//        }
     }
    

    @discardableResult
    override func popViewController(animated: Bool) -> UIViewController? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        arrayScreenshot.removeLastObject()
        let image = arrayScreenshot.lastObject
        if (image != nil) {
            appDelegate.gestureBaseView?.imgView?.image = image as! UIImage?;
        }
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (arrayScreenshot.count > 2) {
            arrayScreenshot.removeObjects(in: NSMakeRange(1, arrayScreenshot.count - 1))
        }
        let image = arrayScreenshot.lastObject
        if (image != nil) {
            appDelegate.gestureBaseView?.imgView?.image = image as! UIImage?
        }
        return super.popToRootViewController(animated: animated)
    }
    
    @discardableResult
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let arr = super.popToViewController(viewController, animated: animated)
        if (self.arrayScreenshot.count > (arr?.count)!) {
            for _ in 0  ..< (arr?.count)! {
                arrayScreenshot.removeLastObject()
            }
        }
        return arr;
    }
}

//    lazy var backBtn : UIButton = {
//        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        btn.setTitle("返回", for: .normal)
//        btn.setTitleColor(UIColor.red, for: .normal)
//        btn.setImage(UIImage.init(named: "nav_bar_back"), for: .normal)
//        btn.addTarget(self, action: #selector(RSDNavgationController.backBtnAction), for: UIControlEvents.touchUpInside)
//        return btn
//    }()
