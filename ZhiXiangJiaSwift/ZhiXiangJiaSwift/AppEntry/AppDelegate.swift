//
//  AppDelegate.swift
//  自定义view
//
//  Created by ios on 2018/8/13.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//

/*
 import UIKit
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
 
 var window: UIWindow?
 
 func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
 
 // 设置全局nav与tab色值
 UINavigationBar.appearance().tintColor = UIColor(red: 255.0/255.0, green: 2.0/255.0, blue: 51.0/255, alpha: 1.0)
 UITabBar.appearance().tintColor = UIColor(red: 255.0/255.0, green: 2.0/255.0, blue: 51.0/255, alpha: 1.0)
 
 // 创建窗口
 window = UIWindow(frame: UIScreen.mainScreen().bounds)
 window?.rootViewController = TabBarController()
 window?.makeKeyAndVisible()
 
 
 
 return true
 }
 
 作者：子祖
 链接：https://www.jianshu.com/p/aa745ec26f58
 來源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
 */

import UIKit
import Alamofire
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// 共享实例
    static let shareInstance = AppDelegate()

    var securitySetUpValue: [String: Any] = Dictionary.init()
    
    var window: UIWindow?
    var gestureBaseView: RSDGestureBaseView?
    var tabBarController: RSDRootViewController?

    var reachability: Reachability?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        tabBarController = RSDRootViewController()
        tabBarController?.view.backgroundColor = UIColor.white
        self.window!.rootViewController = tabBarController
        
        gestureBaseView = RSDGestureBaseView.init(frame: CGRect(x: 0, y: 0, width: (window?.frame.size.width)!, height: (window?.frame.size.height)!))
        window?.insertSubview(gestureBaseView!, at: 0)
        gestureBaseView?.isHidden = true;
        window?.makeKeyAndVisible()

        
//        reachability = Reachability.init(hostname: "www.apple.com")
//        monitorNet()
//        // 网络可用或切换网络类型时执行
//        reachability?.whenReachable = { reachability in
//            // 判断网络状态及类型
//            print("当前网络是====状态\(reachability.connection.description)")
//        }
//        // 网络不可用时执行
//        reachability?.whenUnreachable = { reachability in
//            // 判断网络状态及类型
//            print("当前网络不可用 ====状态\(reachability.connection.description)")
//        }

        return true
    }
    
//    func monitorNet(){
//        var str : String!
//        do {
//           try str =  reachability?.connection.description
////            reachability = try Reachability.reachabilityForInternetConnection()
//        } catch let err as NSError {
//            print("unable to create Reachability\(err.description)")
//            return
//        }
//        let signString = String(describing: reachability?.connection)
////        let sign = reachability?.connection.description//"No Connection"  "WiFi"
//        if signString == "Optional(No Connection)" {
//            print("appDelegate:网络连接：不可用")
//        } else {
//            print("appDelegate:网络连接：可用\(String(describing: reachability?.connection))")
//        }
//        
//        if reachability?.connection == .wifi{
//            print("连接类型：WiFi")
//        } else if reachability?.connection == .cellular {
//            print("连接类型：移动网络")
//        } else {
//            print("连接类型：没有网络连接")
//        }
//        do {
//            try reachability?.startNotifier()//开始监测
//        } catch {
//            print("could not start reachability notifier")
//        }
//    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

