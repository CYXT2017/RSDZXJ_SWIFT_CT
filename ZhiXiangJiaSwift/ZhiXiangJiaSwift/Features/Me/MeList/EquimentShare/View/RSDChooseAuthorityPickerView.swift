//
//  RSDChooseAuthorityPickerView.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/12.
//  Copyright © 2018年 rsdznjj. All rights reserved.
// 哈哈 choosedateview终于写了差不多了  这个类可以删了 但是花时间写了 还是留着吧 当初还不是想偷懒直接用datepicker 结果不让自定义 字体太大 没法搞 只能重写choosedateview了 

import UIKit
import Foundation

protocol RSDChooseAuthorityPickerViewDelegate {
    func chooseDateOrTime(timeString1: String, timeString2: String)
    func showErrorMessage(message: String)

}

class RSDChooseAuthorityPickerView: UIView {
    
//    var pickerView: UIPickerView = UIPickerView.init()
    var datePickerView: UIDatePicker = UIDatePicker.init()
    var datePickerView2: UIDatePicker = UIDatePicker.init()


    private var timeString001: String = ""
    private var timeString002: String = ""
    //用于比较开始时间和结束时间
    private var DateInt1 = 0
    private var DateInt2 = 29991231

     var delegate: RSDChooseAuthorityPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        let currentString = RSDFuncConfigurationVC.getCurrentTime()
        let currentInt: Int = Int(currentString.replacingOccurrences(of: "-", with: ""))!
        DateInt1 = currentInt
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDateTextColor(picker:UIDatePicker){
        var count:UInt32 = 0
        let propertys = class_copyPropertyList(UIDatePicker.self, &count)
        for index in 0..<count {
            let i = Int(index)
            let property = propertys![i]
            let propertyName = property_getName(property)
            
            let strName = String.init(cString: propertyName, encoding: String.Encoding.utf8)
            print("=====属性值-----====" + strName!)
            if strName == "highlightColor"{
                picker.setValue(UIColor.red, forKey: strName!)
            }
        }
    }
    
//    作者：秋雨W
//    链接：https://www.jianshu.com/p/72d84b25071a
//    來源：简书
//    简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
    
    func setUpView() {
         //盛放按钮的View
        let btnBgView = UIView.init(frame: CGRect(x: -2, y: 0, width: self.width + 4, height: 45))
        btnBgView.backgroundColor = UIColor.init(red: 249 / 255.0, green: 249 / 255.0 , blue: 249 / 255.0, alpha: 1.0)
        self.addSubview(btnBgView)
        //左边的取消按钮
        let cancelButton: UIButton = UIButton.init(frame: CGRect(x: 12, y: 2.5, width: 40, height: 40)) ;
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelBtnClick), for: .touchUpInside)
        btnBgView.addSubview(cancelButton)
        //右边的确定按钮
        let sureButton: UIButton = UIButton.init(frame: CGRect(x: self.width - 50, y: 2.5, width: 40, height: 40)) ;
        sureButton.setTitleColor(UIColor.black, for: .normal)
        sureButton.setTitle("确定", for: .normal)
        sureButton.addTarget(self, action: #selector(self.sureBtnClick), for: .touchUpInside)
        btnBgView.addSubview(sureButton)
        
        let format = DateFormatter.init()
        format.dateFormat = "HH:mm:ss" //将日期转为指定格式显示
        let minDate = format.date(from: "1970-01-01")
        let maxDate = format.date(from: "2999-12-31")
        
        datePickerView.frame = CGRect(x: -15, y: btnBgView.maxY, width: self.width/2 + 50, height: self.height - btnBgView.height)
        datePickerView.datePickerMode = .date
        datePickerView.tag = 88888
        datePickerView.locale = Locale.init(identifier: "zh")
//        设置字体颜色
//        datePickerView.setValue(UIColor.red, forKey: "highlightColor")
//        setDateTextColor(picker: datePickerView)
//        datePickerView.minimumDate = minDate
//        datePickerView.maximumDate = maxDate
        datePickerView.addTarget(self, action: #selector(self.valueChange(_:)), for: .valueChanged)
        self.addSubview(datePickerView)//[alert setValue:datePicker forKey:@"accessoryView"];
        
        datePickerView2.frame = CGRect(x: self.width/2 - 15, y: btnBgView.maxY, width: self.width/2 + 50, height: self.height - btnBgView.height)
//        datePickerView2.minimumDate = minDate
//        datePickerView2.maximumDate = maxDate
        datePickerView2.datePickerMode = .date
        datePickerView2.tag = 99999
        datePickerView2.locale = Locale.init(identifier: "zh")
        datePickerView2.addTarget(self, action: #selector(self.valueChange(_:)), for: .valueChanged)
        self.addSubview(datePickerView2)

    }
    
    func showDatePickerView() {
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: 0, y: (self.superview?.height)! - 260, width: RSDScreenWidth, height: 260)
        }
    }
    
    func hideDatePickerView() {
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: 0, y: (self.superview?.height)!, width: RSDScreenWidth, height: 260)
        }
    }

    
    
    @objc private func valueChange(_  datePicker : UIDatePicker) {
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd" //将日期转为指定格式显示HH:mm:ss
        if datePicker.tag == 88888 {
            timeString001 = format.string(from: datePicker.date)
        } else if datePicker.tag == 99999 {
            timeString002 = format.string(from: datePicker.date)
        }
        if timeString001.contains("-") {
            DateInt1 = Int(timeString001.replacingOccurrences(of: "-", with: ""))!
        }
        
        if timeString002.contains("-") {
            DateInt2 = Int(timeString002.replacingOccurrences(of: "-", with: ""))!
        }
//        self.delegate?.chooseDateOrTime(timeString1: timeString001, timeString2: timeString002)
    }


    
    @objc private func cancelBtnClick() {
        hideDatePickerView()
    }
    
    @objc private func sureBtnClick() {
        if DateInt1 >= DateInt2 {
            self.delegate?.showErrorMessage(message: "结束时间需要超过起始时间")
            return
        }
        if timeString001.count == 0 {
            timeString001 = RSDFuncConfigurationVC.getCurrentTime()
            hideDatePickerView()
        }
        
        if timeString002.count == 0 {
            timeString002 = "2999-12-31"
        }

        self.delegate?.chooseDateOrTime(timeString1: timeString001, timeString2: timeString002)
        hideDatePickerView()
    }

}

//extension RSDChooseAuthorityPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
//    
//    
//}
