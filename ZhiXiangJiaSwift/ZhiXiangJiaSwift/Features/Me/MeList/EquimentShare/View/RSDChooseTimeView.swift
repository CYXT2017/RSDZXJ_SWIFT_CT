//
//  RSDChooseTimeView.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/13.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

protocol RSDChooseTimePickerDelegate {
    func chooseTime(timeString1: String, timeString2: String)
    
    func showErrorMessage(message: String)
    
}

class RSDChooseTimeView: UIView {

    var delegate: RSDChooseTimePickerDelegate?

    var pickerView: UIPickerView = UIPickerView.init()

    private var timeString001: String = ""
    private var timeString002: String = ""
    //用于比较 开始时间小于结束时间
    private var timeInt1: Int = 000000
    private var timeInt2: Int = 235959

    private var time0 = "00"
    private var time1 = "00"
    private var time2 = "00"
    private var time3 = "23"
    private var time4 = "59"
    private var time5 = "59"

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setUpView() {
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
        
//        let format = DateFormatter.init()
//        format.dateFormat = "HH:mm:ss" //将日期转为指定格式显示
//        let minDate = format.date(from: "1970-01-01")
//        let maxDate = format.date(from: "2999-12-31")
        
        pickerView.frame = CGRect(x: 0, y: btnBgView.maxY, width: self.width, height: self.height - btnBgView.height)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 88888
        self.addSubview(pickerView)
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.selectRow(0, inComponent: 1, animated: true)
        pickerView.selectRow(0, inComponent: 2, animated: true)
        pickerView.selectRow(23, inComponent: 3, animated: true)
        pickerView.selectRow(59, inComponent: 4, animated: true)
        pickerView.selectRow(59, inComponent: 5, animated: true)
    }
    
    
    
    @objc private func valueChange(_  datePicker : UIDatePicker) {
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd" //将日期转为指定格式显示HH:mm:ss
        if datePicker.tag == 88888 {
            timeString001 = format.string(from: datePicker.date)
        } else if datePicker.tag == 99999 {
            timeString002 = format.string(from: datePicker.date)
        }
        //        self.delegate?.chooseDateOrTime(timeString1: timeString001, timeString2: timeString002)
    }
    
    
    
    @objc private func cancelBtnClick() {
        hideDatePickerView()
    }
    
    @objc private func sureBtnClick() {
        if timeInt1 >= timeInt2 {
            self.delegate?.showErrorMessage(message: "开始时间必须小于结束时间，请重新选择")
            hideDatePickerView()
            return
        }
        if timeString001.count == 0 {
            timeString001 = "00:00:00"
        }

        if timeString002.count == 0 {
            timeString002 = "23:59:59"
        }

        self.delegate?.chooseTime(timeString1: timeString001, timeString2: timeString002)
        hideDatePickerView()
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

}

extension RSDChooseTimeView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 60
        case 2:
            return 60
        case 3:
            return 24
        case 4:
            return 60
        case 5:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let labelX: CGFloat = pickerView.width * CGFloat(component) / CGFloat(3.0)
        let titleLabel: UILabel = UILabel.init(frame: CGRect(x:labelX, y: 0, width:pickerView.width / 3.0, height: 30))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.tag = component * 100 + row
        titleLabel.textAlignment = .center
        switch component {
        case 0:
            titleLabel.text = "\(row)" + "时"
        case 1:
            titleLabel.text = "\(row)" + "分"
        case 2:
            titleLabel.text = "\(row)" + "秒"
        case 3:
            titleLabel.text = "\(row)" + "时"
        case 4:
            titleLabel.text = "\(row)" + "分"
        case 5:
            titleLabel.text = "\(row)" + "秒"
        default: break
        }
        return titleLabel
     }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            time0 = "\(row)"
        case 1:
            time1 = "\(row)"
        case 2:
            time2 = "\(row)"
        case 3:
            time3 = "\(row)"
        case 4:
            time4 = "\(row)"
        case 5:
            time5 = "\(row)"
        default: break
        }
        if time0.count == 1 {
            time0 = "0" + time0
        } else if time1.count == 1 {
            time1 = "0" + time1
        } else if time2.count == 1 {
            time2 = "0" + time2
        } else if time3.count == 1 {
            time3 = "0" + time3
        } else if time4.count == 1 {
            time4 = "0" + time4
        } else if time5.count == 1 {
            time5 = "0" + time5
        }
        timeString001 = time0 + ":" + time1 + ":" + time2
        timeString002 = time3 + ":" + time4 + ":" + time5
        
        timeInt1 = Int(time0 + time1 + time2)!
        timeInt2 = Int(time3 + time4 + time5)!
    }




}

