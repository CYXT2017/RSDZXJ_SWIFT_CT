//
//  RSDCycleScrollView.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/29.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//
/* 无限轮播图功能 使用方法如下：
 let tmpCycleScrollView: RSDCycleScrollView = RSDCycleScrollView.cycleScrollView(withFrame: CGRect.init(x: 0, y: 64, width: kScreenWidth, height: 250), delegate: self, placeholderImage: UIImage(),isOnBottom: true)
 tmpCycleScrollView.images = [UIImage.init(named: "lead01"),UIImage.init(named: "lead02"),UIImage.init(named: "lead03")] as! [UIImage]
 tmpCycleScrollView.imageUrlStrings = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502367139&di=2ff6ffaa08b7299102ec84c8c8616c9d&imgtype=jpg&er=1&src=http%3A%2F%2Fimg9.zol.com.cn%2Fpic%2Fyouxi%2F800_36%2F366903.jpg",
 "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502367158&di=cd3492acccb7f7bff1e4f92f128eba08&imgtype=jpg&er=1&src=http%3A%2F%2Fimg9.zol.com.cn%2Fpic%2Fyouxi%2F800_38%2F384531.jpg",
 "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502367209&di=c5ea6d23987ac893ce900ca584a0a90c&imgtype=jpg&er=1&src=http%3A%2F%2Fimage14-c.poco.cn%2Fmypoco%2Fmyphoto%2F20130327%2F11%2F64758065201303271100381930863592037_005_640.jpg",
 "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502367369&di=a98c285235c07c57c7a468632e363fd5&imgtype=jpg&er=1&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Flvpics%2Fw%3D1000%2Fsign%3Db9eb46ab53fbb2fb342b5c127f7a21a4%2Fe850352ac65c1038b3468034b4119313b07e8908.jpg"]
 //        tmpCycleScrollView.titleNameArray = ["111111说道说道1了11","22赛诺菲金卡戴珊复健科2222222","33333s节省空间快乐十分333"]
 //        tmpCycleScrollView.isShowCircleDotBool = false
 tmpCycleScrollView.showCycleScrollView()
 self.view.addSubview(tmpCycleScrollView)
 */

import UIKit
import Kingfisher

@objc protocol RSDCycleScrollViewDelegate {
    
    /** 点击图片回调 */
    @objc optional func cycleScrollView(didSelectItemAt index: NSInteger);
    
}

class RSDCycleScrollView: UIView, UIScrollViewDelegate {
    
    private var isTitLabelOnBottom: Bool
    private var mPlaceholderImage: UIImage
    private var mFrame: CGRect
    let titleLabelHeight:CGFloat = 30
    
    weak var mDelegate: RSDCycleScrollViewDelegate?
    
    private var mTimer: RSDTimer?
    
    //MARK: - 初始化方法
    open class func cycleScrollView(withFrame frame: CGRect, delegate: AnyObject, placeholderImage: UIImage,isOnBottom:Bool) -> RSDCycleScrollView {
        return RSDCycleScrollView.init(withFrame: frame, delegate: delegate, placeholderImage: placeholderImage,isOnBottom:isOnBottom)
    }
    
    init(withFrame frame: CGRect, delegate: AnyObject, placeholderImage: UIImage,isOnBottom:Bool) {
        self.isTitLabelOnBottom = isOnBottom
        self.mPlaceholderImage = placeholderImage
        self.mFrame = frame
        self.mDelegate = delegate as? RSDCycleScrollViewDelegate
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - private 设置数据源 图片点击事件
    private func start() {
        /**
         *  如果同时设置了本地图片和网络图片地址,默认优先选择网络图片
         */
        if mScrollView.subviews.count > 0 {
            for subView in mScrollView.subviews {
                subView.removeFromSuperview()
            }
        }
        guard imageUrlStrings.count != 0 else {
            guard images.count != 0 else {
                return
            }
            
            /**
             *  配置轮播数据源
             */
            var newImages: [UIImage] = images
            if images.count > 1 {
                newImages.insert(images.last!, at: 0)
                newImages.append(images.first!)
            }

            var x: CGFloat = 0
            for image in newImages {
                let tmpImageView = UIImageView.init(frame: CGRect.init(x: x, y: 0, width: mFrame.width, height: mFrame.height))
                tmpImageView.tag = images.index(of: image)!
                self.mScrollView.addSubview(tmpImageView)
                
                /**
                 *  设置数据源
                 */
                tmpImageView.image = image
                
                /**
                 *  添加图片点击事件
                 */
                tmpImageView.isUserInteractionEnabled = true
                tmpImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.didSelectImageView(tap:))))
                
                x+=mFrame.width
            }
            
            self.mScrollView.contentSize = CGSize.init(width: mFrame.width * CGFloat(newImages.count), height: mFrame.height)
            
            if images.count != 0 {
                self.mPage.numberOfPages = images.count
            }
            self.startTimer()

            return
        }
        var x: CGFloat = 0
        /**
         *  配置轮播数据源
         */
        var newImageUrlStrings: [String] = imageUrlStrings
        if imageUrlStrings.count > 1 {
            newImageUrlStrings.insert(imageUrlStrings.last!, at: 0)
            newImageUrlStrings.append(imageUrlStrings.first!)
        }
        
        for imageUrlStrig in newImageUrlStrings {
            let tmpImageView = UIImageView.init(frame: CGRect.init(x: x, y: 0, width: mFrame.width, height: mFrame.height))
            tmpImageView.tag = imageUrlStrings.index(of: imageUrlStrig)!
            self.mScrollView.addSubview(tmpImageView)
            
            /**
             *  设置数据源
             */
            tmpImageView.kf.setImage(with: URL.init(string: imageUrlStrig), placeholder: mPlaceholderImage, options: nil, progressBlock: { (a, b) in
                
            }, completionHandler: { (image, error, cacheType, url) in
                
            })
            
            /**
             *  添加图片点击事件
             */
            tmpImageView.isUserInteractionEnabled = true
            tmpImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.didSelectImageView(tap:))))
            
            x+=mFrame.width
        }
        if imageUrlStrings.count != 0 {
            self.mPage.numberOfPages = imageUrlStrings.count
        }

        self.mScrollView.contentSize = CGSize.init(width: mFrame.width * CGFloat(newImageUrlStrings.count), height: mFrame.height)
        
        if newImageUrlStrings.count > 0 {
            mScrollView.scrollRectToVisible(CGRect.init(origin: CGPoint.init(x: mScrollView.frame.width, y: mScrollView.frame.origin.y), size: mScrollView.frame.size), animated: false)
        }
        
        self.startTimer()
        
    }
    
    deinit {
        self.mTimer?.invalidate()
    }
    
    private func startTimer() {
        weak var weakSelf = self
        mTimer = RSDTimer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (mTimer) in
            weakSelf?.timerTask()
        })
    }

    /**
     *  图片点击事件
     */
    @objc private func didSelectImageView(tap: UITapGestureRecognizer) {
        mDelegate?.cycleScrollView!(didSelectItemAt: (tap.view?.tag)!)
    }
    
    //MARK: - 显示 这个暂时就这么写 以后有特殊需求直接在这个方法里面修改 可以增加属性或者方法
    func showCycleScrollView() {
        self.addSubview(self.mScrollView)
        self.addSubview(self.titleLabelBGView)
        self.addSubview(self.titlesLabel)
        if self.isShowCircleDotBool {
            self.addSubview(self.mPage)
        }
        if (self.titleNameArray.count == images.count || self.titleNameArray.count == imageUrlStrings.count) && self.titleNameArray.count != 0 {
            self.titlesLabel.text = self.titleNameArray[self.mPage.currentPage]
        }
        self.start()
    }

    
    //MARK: - 定时器方法
    /**
     *  定时任务
     */
    func timerTask() {
        mScrollView.scrollRectToVisible(CGRect.init(origin: CGPoint.init(x: mScrollView.contentOffset.x + mScrollView.frame.width, y: mScrollView.frame.origin.y), size: mScrollView.frame.size), animated: true)
        /**
         *  因为动画的存在，所以直接检测pages会有误差，做短暂的延迟
         */
        sleep(UInt32(0.2))
        self.checkEnableToUpdateVisible()
    }
    
    /**
     *  判断是否需要隐形改变当前位置
     */
    func checkEnableToUpdateVisible() {
        let allPages: Int = Int(mScrollView.contentSize.width/mScrollView.frame.width)
        let currentPage: Int = Int(mScrollView.contentOffset.x/mFrame.width) + 1
        if currentPage == 1 {
            // 跳转到倒数第二张
            mScrollView.scrollRectToVisible(CGRect.init(origin: CGPoint.init(x: mScrollView.frame.width * CGFloat(allPages - 2), y: mScrollView.frame.origin.y), size: mScrollView.frame.size), animated: false)
        }
        else if currentPage == allPages {
            // 跳转到第二张
            mScrollView.scrollRectToVisible(CGRect.init(origin: CGPoint.init(x: mScrollView.frame.width, y: mScrollView.frame.origin.y), size: mScrollView.frame.size), animated: false)
        }
        else {

        }
    }

    //MARK: - ScorllViewDelegate
    /**
     *  当没有动画的时候，该方法会被执行一次
     *  有动画存在的时候，该方法会被调N次
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let allPages: Int = Int(mScrollView.contentSize.width/mScrollView.frame.width)
        let currentPage: Int = Int(mScrollView.contentOffset.x/mFrame.width) + 1
        if currentPage == 1 {
            mPage.currentPage = allPages - 3
        }
        else if currentPage == allPages {
            mPage.currentPage = 0
        }
        else {
            self.mPage.currentPage = currentPage - 2
        }
        if (self.titleNameArray.count == images.count || self.titleNameArray.count == imageUrlStrings.count) && self.titleNameArray.count != 0 {
            self.titlesLabel.text = self.titleNameArray[self.mPage.currentPage]
        }
    }
    
    /**
     *  即将开始拖动
     */
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.mTimer?.invalidate()
    }
    
    /**
     *  减速停止
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.startTimer()
        self.checkEnableToUpdateVisible()
    }


    
    //MARK: - Setter and Getter
    //MARK:网络图片地址数组
    var imageUrlStrings: [String] = [] {
        willSet(newValue) {
        }
        didSet(oldValue) {
        }
    }
    //MARK:标题数组
    var titleNameArray: [String] = [] {
        willSet(newValue) {
        }
        didSet(oldValue) {
        }
    }
    //MARK:本地图片名称数组
    var images: [UIImage] = [] {
        willSet(newValue) {
        }
        didSet(oldValue) {
        }
    }
    //MARK:是否显示小圆点
    var isShowCircleDotBool : Bool = true {
        willSet(newValue) {
        }
        didSet(oldValue) {
        }
    }
    
    
    //MARK: - 懒加载
    private lazy var mScrollView: UIScrollView = {
        let tmp: UIScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.mFrame.width, height: self.mFrame.height))
        tmp.bounces = false
        tmp.showsHorizontalScrollIndicator = false
        tmp.isPagingEnabled = true
        tmp.delegate = self
        return tmp
    }()
    
    private lazy var mPage: UIPageControl = {
        let tmp: UIPageControl = UIPageControl.init(frame: CGRect.init(x: self.mFrame.width - 60, y: self.mFrame.height - 20, width: 60, height: 10))
        tmp.currentPage = 0
        tmp.pageIndicatorTintColor = UIColor.white
        tmp.currentPageIndicatorTintColor = UIColor.red
        return tmp
    }()
    
    private lazy var titlesLabel:UILabel = {
        let lable = UILabel.init()
        if self.isTitLabelOnBottom {
            lable.frame = CGRect(x: 0, y: self.mFrame.height - self.titleLabelHeight, width: self.mFrame.width, height: self.titleLabelHeight)
        } else {
            lable.frame = CGRect(x: 0, y: (self.mFrame.height - self.titleLabelHeight)/2, width: self.mFrame.width, height: self.titleLabelHeight)
        }
        lable.textColor = UIColor.black
        //        lable.backgroundColor = UIColor.groupTableViewBackground
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textAlignment = .center
        return lable
    }()
    
    private lazy var titleLabelBGView:UIView = {
        let view = UIView.init()
        if self.isTitLabelOnBottom {
            view.frame = CGRect(x: 0, y: self.mFrame.height - self.titleLabelHeight, width: self.mFrame.width, height: self.titleLabelHeight)
        } else {
            view.frame = CGRect(x: 0, y: (self.mFrame.height - self.titleLabelHeight)/2, width: self.mFrame.width, height: self.titleLabelHeight)
        }
        view.alpha = 0.4
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
}


/*
 /MARK:- runtime
 // 修改pageControl的小点样式
 extension ViewController {
 
 func runtime() {
 
 // 1, 利用runtime 遍历出pageControl的所有属性
 var count : UInt32 = 0
 let ivars = class_copyIvarList(UIPageControl.self, &count)
 for i in 0..<count {
 
 let ivar = ivars?[Int(i)]
 let name = ivar_getName(ivar)
 print(String(cString: name!))
 
 /* 打印出来的所有属性
 _lastUserInterfaceIdiom
 _indicators
 _currentPage
 _displayedPage
 _pageControlFlags
 _currentPageImage // 图片样式
 _pageImage // 图片样式
 _currentPageImages
 _pageImages
 _backgroundVisualEffectView
 _currentPageIndicatorTintColor
 _pageIndicatorTintColor
 _legibilitySettings
 _numberOfPages
 */
 }
 
 // 2, 利用kvc修改图片
 pageControl.setValue(UIImage(named: "page"), forKey: "_pageImage")
 pageControl.setValue(UIImage(named: "currentpage"), forKey: "_currentPageImage")
 }
 }
 */
