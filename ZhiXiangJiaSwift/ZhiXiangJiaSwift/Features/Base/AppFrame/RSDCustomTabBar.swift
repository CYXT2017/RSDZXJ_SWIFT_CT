
//
//  CustomTabBar.swift
//  自定义view
//
//  Created by ios on 2018/8/13.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//

import UIKit

//定义一个协议 让代理去实现点击 加号时候的方法
protocol CustomBarbuttonDelegate
{
    func barButtonAction(sender: RSDCustomCenterButton)
}

class RSDCustomTabBar: UITabBar {

    var delegateTabbar: CustomBarbuttonDelegate?
    // 引入自定义的 Button(中间的大加号)
    let addButton: RSDCustomCenterButton = RSDCustomCenterButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //# 把自定义的 Button 放到 自定义的 tabbar 上
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addButton.backgroundColor = UIColor.red
        self.addSubview(addButton)
        self.addButton.addTarget(self, action: #selector(RSDCustomTabBar.btnClick), for: UIControlEvents.touchUpInside)
        self.addButton.clipsToBounds = true
        self.addButton.layer.cornerRadius = self.bounds.size.height/2
//        addButton.addTarget(self, action: Selector(("buttonAction:")), for: UIControlEvents.touchUpInside)
        //改变tabbar 线条颜色
//        self.shadowImage = UIImage.
//        [self setShadowImage:[UIImage imageWithColor:__Cycle_ViewsColor(224, 224, 224)]];
//        //设置tabbar背景颜色
//        self.backgroundColor = __Cycle_ViewsColor(247, 247, 247);

    }
    
    
    
    //# 可视化编程时候走这个方法
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.addSubview(self.addButton)
        self.addButton.backgroundColor = UIColor.red
        self.addButton.addTarget(self, action: #selector(RSDCustomTabBar.btnClick), for: UIControlEvents.touchUpInside)

    }
    // 调用协议的方法
    @objc func btnClick() {
//        print("-调用协议方法-------->")
        let butn = RSDCustomCenterButton()
        
        self.delegateTabbar?.barButtonAction(sender: butn)
        
    }

//    // 调用协议的方法
//    @objc func btnClick(sender: CustomCenterButton) {
//        print("-调用协议方法-------->")
//        self.delegateTabbar?.barButtonAction(sender: sender)
//
//    }

    
    // 布局子控件  在这里主要是让大加号处于中间偏上的位置
    override func layoutSubviews() {
        super.layoutSubviews()
        // 布置每一个 itm 的 frame
        var itemX: CGFloat = 0.0
        let itemY: CGFloat = 0.0
        let itemH: CGFloat  = self.bounds.size.height
        // 记录 标签个数也是就是 tabbarButton 的个数
        let ddd: CGFloat = CGFloat(self.items!.count)
        // 算出每一个占据的宽度 加上了加号 Button 的位置
        let itemW: CGFloat = self.bounds.size.width / (ddd)
        
        var itemCurrent: CGFloat = 0
        
        // 遍历子视图 找出 tabbarButton 依次分配位置
        for itemTemp in self.subviews
        {
//            print("子视图->",itemTemp,"\n")
            if NSStringFromClass(itemTemp.classForCoder) == "UITabBarButton"
            {// 留出中间位置给加号 Button
//                if itemCurrent == 3
//                {
//                    itemCurrent = 4
//                }
                itemX = itemCurrent * itemW
                itemTemp.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                itemCurrent += 1
            }
            // 算出加号的位置
//            self.addButton.bounds.size = CGSize(width: itemW, height:  itemH )
            self.addButton.bounds.size = CGSize(width: 64, height:  67.5 )
            
            self.addButton.center = CGPoint(x: self.bounds.size.width / 2.0, y: 0)
            self.bringSubview(toFront: self.addButton)
        }
        
        
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//
//    }
    //这个方法就是为了让超出的加号部分也能点击响应
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 只有在没有被隐藏的时候才会需要
        if self.isHidden == false
        {
            let newPoint: CGPoint = self.convert(point, to: self.addButton)
            // 判断点击的点在加号的范围里面  那么响应的范围就是加号的范围
            if self.addButton.point(inside: newPoint, with: event)
            {
                return self.addButton
            }else
            {// 其他时候  就按照系统的方法走就行了
                return super.hitTest(point, with: event)
            }
            
        }else
        {
            // 其他时候  就按照系统的方法走就行了
            return super.hitTest(point, with: event)
        }
    }
    
    
}
