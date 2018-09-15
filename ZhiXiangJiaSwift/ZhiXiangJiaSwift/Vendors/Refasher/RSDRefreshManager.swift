//
//  RSDRefreshManager.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/28.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//  刷新库管理者 使用方法 类似如下：
/*
tabview.rsd_Header = RSDmj_freshHeader_Nomal{
    [weak self] in self?.loadData()
}
tabview.uHead = RSDmj_freshHeader_Nomal{
    
}
tabview.rsd_Footer = RSDmj_freshFooter_Tips(with: "使用妖气币可以购买订阅漫画\nVIP会员购买还有优惠哦~")
tabview.rsd_Footer = URefreshFooter() {
    [weak self] in self?.loadData()
}
 tabview.rsd_Footer.endRefreshing()
 tabview.rsd_Footer.endRefreshingWithNoMoreData()
*/



import Foundation
import UIKit
import MJRefresh

extension UIScrollView {
    var rsd_Header: MJRefreshHeader {
        get { return mj_header }
        set { mj_header = newValue }
    }
    
    var rsd_Footer: MJRefreshFooter {
        get { return mj_footer }
        set { mj_footer = newValue }
    }
}

class RSDmj_freshHeader_Nomal: MJRefreshNormalHeader {}
class RSDmj_freshFooter_Nomal: MJRefreshBackNormalFooter {}

class RSDmj_freshHeader_Auto: MJRefreshHeader {}
class RSDmj_freshFooter_Auto: MJRefreshAutoFooter {}

class RSDmj_freshHeader_Gif: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()
        setImages([UIImage(named: "refresh_normal")!], for: .idle)
        setImages([UIImage(named: "refresh_will_refresh")!], for: .pulling)
        setImages([UIImage(named: "refresh_loading_1")!,
                   UIImage(named: "refresh_loading_2")!,
                   UIImage(named: "refresh_loading_3")!], for: .refreshing)
        lastUpdatedTimeLabel.isHidden = true
        stateLabel.isHidden = true
    }
}

class RSDmj_freshFooter_Discover: MJRefreshBackGifFooter {
    override func prepare() {
        super.prepare()
        backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        setImages([UIImage(named: "refresh_discover")!], for: .idle)
        stateLabel.isHidden = true
        refreshingBlock = { self.endRefreshing() }
    }
}

class RSDmj_freshFooter_Tips: MJRefreshBackFooter {
    lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = UIColor.lightGray
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.numberOfLines = 0
        return tl
    }()
    
    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.image = UIImage(named: "refresh_kiss")
        return iw
    }()
    
    override func prepare() {
        super.prepare()
        backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        mj_h = 240
        addSubview(tipLabel)
        addSubview(imageView)
    }
    
    override func placeSubviews() {
        tipLabel.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 60)
        imageView.frame = CGRect(x: (bounds.width - 80 ) / 2, y: 110, width: 80, height: 80)
    }
    
    convenience init(with tip: String) {
        self.init()
        refreshingBlock = { self.endRefreshing() }
        tipLabel.text = tip
    }
}


