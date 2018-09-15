
//
//  RSDChooseDateView.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/13.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

public let MAXYEAR = 2100
public let MINYEAR = 1970

protocol RSDChooseDatePickerDelegate {
    func chooseDate(year: Int32, month: Int32, day: Int32)
    func showErrorMessage(message: String)
    func disMissViewMethod()
}

class RSDChooseDateView: UIView {
    
    var delegate: RSDChooseDatePickerDelegate?

    //日期存储数组
    var yearArray:NSMutableArray?
    var monthArray:NSMutableArray?
    var dayArray:NSMutableArray?
    //记录日期位置
    var yearIndex:NSInteger?
    var monthIndex:NSInteger?
    var dayIndex:NSInteger?
    
    //用于左边选择的数据年月日  也可以表示右边的数据年月日
    var leftYearSelect: Int32?
    var leftMonthSelect: Int32?
    var leftDaySelect: Int32?

    //左边还是右边的pickerview
    var isRightBool = false
    
    //用于比较 开始时间小于结束时间
    private var timeInt1: Int = 000000
    private var timeInt2: Int = 235959

    
    convenience init(frame: CGRect, isRight: Bool) {
        self.init(frame: frame)
        self.frame = frame
        self.isRightBool = isRight
        setUpView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpView() {
        self.defaultConfig()
        //盛放按钮的View
        let btnBgView = UIView.init(frame: CGRect(x: -2, y: 0, width: self.width + 4, height: 45))
        btnBgView.backgroundColor = UIColor.init(red: 249 / 255.0, green: 249 / 255.0 , blue: 249 / 255.0, alpha: 1.0)
        self.addSubview(btnBgView)
        if !self.isRightBool {  //左边的取消按钮
             let cancelButton: UIButton = UIButton.init(frame: CGRect(x: 12, y: 2.5, width: 40, height: 40)) ;
            cancelButton.setTitleColor(UIColor.black, for: .normal)
            cancelButton.setTitle("取消", for: .normal)
            cancelButton.addTarget(self, action: #selector(self.cancelBtnClick), for: .touchUpInside)
            btnBgView.addSubview(cancelButton)
        }
        
        if self.isRightBool { //右边的确定按钮
            let sureButton: UIButton = UIButton.init(frame: CGRect(x: self.width - 50, y: 2.5, width: 40, height: 40)) ;
            sureButton.setTitleColor(UIColor.black, for: .normal)
            sureButton.setTitle("确定", for: .normal)
            sureButton.addTarget(self, action: #selector(self.sureBtnClick), for: .touchUpInside)
            btnBgView.addSubview(sureButton)
        }
        let currentDate = NSDate()
        self.scrollToDate(date: currentDate)
        
        leftYearSelect = (yearArray![yearIndex!] as! NSString).intValue
        leftMonthSelect = (monthArray![monthIndex!] as! NSString).intValue
        leftDaySelect = (dayArray![dayIndex!] as! NSString).intValue
//        print("左边选择的年月日=====\(String(describing: leftYearSelect)) - \(String(describing: leftMonthSelect)) - \(String(describing: leftDaySelect))")
    }
    
    fileprivate func scrollToDate (date:NSDate) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day,.month,.year,.hour], from: date as Date)
        let _ = self.daysCount(year: dateComponents.year!, month: dateComponents.month!)
        
        yearIndex = dateComponents.year!-MINYEAR
        monthIndex = dateComponents.month!-1
        dayIndex = dateComponents.day!-1
        
        self.addSubview(self.datePicker)
        self.datePicker.reloadAllComponents()
        if self.isRightBool {
            yearIndex = MAXYEAR - MINYEAR
            monthIndex = 11
            let dayAllIndex = self.daysCount(year: MAXYEAR, month: 12)
            dayIndex = dayAllIndex-1
        }
        
        self.datePicker.selectRow(yearIndex!, inComponent: 0, animated: true)
        self.datePicker.selectRow(monthIndex!, inComponent: 1, animated: true)
        self.datePicker.selectRow(dayIndex!, inComponent: 2, animated: true)
    }

    /// 计算每个月的天数
    fileprivate func daysCount(year:Int,month:Int) -> Int{
        let isrunNian = year%4 == 0 ? (year%100 == 0 ? (year%400 == 0 ? true:false):true):false
        if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12{
            self.setDayArr(num: 31)
            return 31
        }else if month == 4 || month == 6 || month == 9 || month == 11{
            self.setDayArr(num: 30)
            return 30
        }else if month == 2{
            if isrunNian{
                self.setDayArr(num: 29)
                return 29
            }else{
                self.setDayArr(num: 28)
                return 28
            }
        }
        return 0
    }
    
    fileprivate func setDayArr(num:NSInteger){
        dayArray?.removeAllObjects()
        for i in 1...num {
            let dayStr = String(format:"%02d",i)
            dayArray?.add(dayStr)
        }
    }
  
    fileprivate func defaultConfig(){
        yearArray = NSMutableArray.init()
        monthArray = NSMutableArray.init()
        dayArray = NSMutableArray.init()
        
        yearIndex = 0
        monthIndex = 0
        dayIndex = 0
        
        for i in 1...12 {
            let monthStr = String(format:"%02d",i)
            monthArray?.add(monthStr)
        }
        for i in MINYEAR...MAXYEAR {
            let yearStr = String(format:"%d",i)
            yearArray?.add(yearStr)
        }
    }

    
    @objc private func cancelBtnClick() {
        hideDatePickerView()
    }
    
    @objc private func sureBtnClick() {
//        if timeInt1 >= timeInt2 {
//            self.delegate?.showErrorMessage(message: "结束时间需要超过起始时间")
//            hideDatePickerView()
//            return
//        }
//        if timeString001.count == 0 {
//            timeString001 = "00:00:00"
//        }
//
//        if timeString002.count == 0 {
//            timeString002 = "23:59:59"
//        }
//
//        self.delegate?.chooseTime(timeString1: timeString001, timeString2: timeString002)
//        hideDatePickerView()
        
        let selctYears = (yearArray![yearIndex!] as! NSString).intValue
        let selctMonths = (monthArray![monthIndex!] as! NSString).intValue
        let selectDays = (dayArray![dayIndex!] as! NSString).intValue
//        print("右边选择的年月日=====\(selctYears) - \(selctMonths) - \(selectDays)")
//        print("右边选择的年月日=====\(selctYears) - \(selctMonths) - \(selectDays)   左边选择的年月日 ===\(String(describing: leftYearSelect)) - \(String(describing: leftMonthSelect)) - \(String(describing: leftDaySelect))")

        //注意 代理传的是右边的年月日  想获取左边的年月日数据的话 在外部用editDateView.leftYearSelect 获取  哎 不想重复建文件写代码 结果有点麻烦
        self.delegate?.chooseDate(year: selctYears, month: selctMonths, day: selectDays)
        hideDatePickerView()
    }
    
    
    func showDatePickerView() {
        if self.isRightBool {
            UIView.animate(withDuration: 0.3) {
                self.frame = CGRect(x: self.width, y: (self.superview?.height)! - self.height, width: self.width, height: self.height)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.frame = CGRect(x: 0, y: (self.superview?.height)! - self.height, width: self.width, height: self.height)
            }
        }
    }
    
    func hideDatePickerView() {
        self.delegate?.disMissViewMethod()
    }
 
    lazy var datePicker:UIPickerView = {
        let view = UIPickerView.init()
        view.frame = CGRect(x:0, y:45, width:self.width, height:215)
//        if self.isRightBool {
//            view.frame = CGRect(x:self.width/2, y:45, width:self.width/2, height:215)
//        } else {
//            view.frame = CGRect(x:0, y:45, width:self.width/2, height:215)
//        }
        view.showsSelectionIndicator = true
        view.delegate = self
        view.dataSource = self
        return view
    }()

}

extension RSDChooseDateView: UIPickerViewDelegate,UIPickerViewDataSource {
    //MARK: 代理方法
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let yearNum = yearArray?.count
        let monthNum = monthArray?.count
        
        let selctYear = (yearArray![yearIndex!] as! NSString).intValue
        let selctMonth = (monthArray![monthIndex!] as! NSString).intValue
        
        let dayNum = self.daysCount(year: Int(selctYear) , month: Int(selctMonth))
        let numberArr = [yearNum,monthNum,dayNum]
        return numberArr[component]!
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let headLabel = UILabel.init()
        headLabel.textColor  = UIColor.black
        headLabel.textAlignment = NSTextAlignment.center
        if component == 0 {
            headLabel.text = (yearArray?[row] as? String)! + "年"
        }
        if component == 1 {
            headLabel.text = (monthArray?[row] as? String)! + "月"
        }
        if component == 2 {
            headLabel.text = (dayArray?[row] as? String)! + "日"
        }
        //        pickerView.subviews[1].backgroundColor = UIColor.clear
        //        pickerView.subviews[2].backgroundColor = UIColor.clear
        
        return headLabel
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            yearIndex = row
        }
        if component == 1 {
            monthIndex = row
        }
        if component == 2 {
            dayIndex = row
        }
        if component == 0 || component == 1{
            let selctYear = (yearArray![yearIndex!] as! NSString).intValue
            let selctMonth = (monthArray![monthIndex!] as! NSString).intValue
            let _ = self.daysCount(year: Int(selctYear) , month: Int(selctMonth))
            
            if (dayArray?.count)!-1 < dayIndex! {
                dayIndex = (dayArray?.count)!-1
            }
//            print("选择的年月日=====\(selctYear) - \(selctMonth) - \(selectDay)")
        }
        
        leftYearSelect = (yearArray![yearIndex!] as! NSString).intValue
        leftMonthSelect = (monthArray![monthIndex!] as! NSString).intValue
        leftDaySelect = (dayArray![dayIndex!] as! NSString).intValue
//        print("左边选择的年月日 课代表右边的选择数据=====\(String(describing: leftYearSelect)) - \(String(describing: leftMonthSelect)) - \(String(describing: leftDaySelect))")
        
        pickerView.reloadAllComponents()
        
    }
}


