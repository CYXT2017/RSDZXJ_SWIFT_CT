//
//  RSDTimer.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/29.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

class RSDTimer: NSObject {
    
    private let mTimer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global(qos: .background))
    
    deinit {
        print("deinit_at_",self.classForCoder)
    }
    
    open class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (RSDTimer) -> Swift.Void) -> RSDTimer {
        return RSDTimer.init(withTimeInterval: interval, repeats: repeats, block: block)
    }
    
    init(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (RSDTimer) -> Swift.Void) {
        super.init()
        
        weak var weakSelf = self
        
        mTimer.setEventHandler {
            DispatchQueue.main.async {
                block(weakSelf!)
            }
        }
        
        mTimer.schedule(deadline: DispatchTime.now() + interval, repeating: interval)
        mTimer.resume()
    }
    
    func invalidate() {
        mTimer.cancel()
    }

}
