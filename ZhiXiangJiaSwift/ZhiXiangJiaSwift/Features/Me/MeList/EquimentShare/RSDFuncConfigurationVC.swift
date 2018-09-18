//
//  RSDFuncConfigurationVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/7.
//  Copyright © 2018年 rsdznjj. All rights reserved.
// 设备功能权限展示和编辑页面

import UIKit
import SVProgressHUD

// MARK:代理 回调编辑的数据到 设备添加界面
protocol RSDEditFuncConfigurationDelegate: AnyObject {
    func changeDataDic(dateBegin: String, dateEnd: String, timeBegin: String, timeEnd: String, repeatStr: String, accorPrame: [String: Any], repeatInts: Int)
}

class RSDFuncConfigurationVC: UIViewController {
    var signInt3 = 0
    weak var delegate: RSDEditFuncConfigurationDelegate?
    
    var isEditBool: Bool = false
    var dataDic: [String: Any]?
    var dataModel: RSDMySharedModel?
    private var timeString: String = ""
    private var funcNameArray: [String] = Array.init()
    private var funcValueArray: [String] = Array.init()

    //需要保存的参数 代理回调上个页面的数据
    private var setRepeatDayArray: [String] = Array.init()
    private var dateBeginStr: String = ""
    private var dateEndStr: String = ""
    private var timeBeginStr: String = ""
    private var timeEndStr: String = ""
    private var repeatDayStr: String = ""
  
    private var weekDayInt = 0 // 仅传参需要 周几 或者 每天
    
    
    var editPickerView: RSDChooseAuthorityPickerView?//这个不能自定义 UI实在是太丑了 而且耗内存 加载速度太慢了 即使放在Didapper里面 也不理想 没办法只能用RSDChooseDateView代替重写了
    
    var editTimeView: RSDChooseTimeView?//时间选择的view
    
    var editDateView2: RSDChooseDateView?//日期选择的view
    var editDateView: RSDChooseDateView?//本来想在把两个日期选择器写一起的 但是数据什么的都要分情况 还有别的问题  所以就用外部的2个大view 而不是内部的2个小pickerview

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataModelForTab()
        setUpUI()
        if #available(iOS 11.0, *) {
            self.mainTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        };
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        creatDatePickerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
//        editPickerView?.hideDatePickerView()
        editTimeView?.hideDatePickerView()
        
        editDateView?.hideDatePickerView()
        editDateView2?.hideDatePickerView()
    }
    
    //MARK: - Private
    private func getDataModelForTab() {
        dataModel = RSDMySharedModel.init()
        timeString = (dataModel?.getFuncConfilgDataModelWithDic(mainDic: self.dataDic!))!
        self.mainTableView.reloadData()
        if dataModel?.device == RSD_EQUIPMENT_TYPE_WIFI_CAMERA {
            if dataModel?.model == RSD_CAMERA_TYPE_WIFI_A1 || dataModel?.model == RSD_CAMERA_TYPE_WIFI_A4 {
                funcNameArray = ["云台控制", "语音监听", "抓拍", "手动录像", "语音对讲", "视频质量", "视频模式", "环境模式", "移动侦测", "录像模式", "格式化SD卡", "设备信息"]
                funcValueArray.append(dataModel?.accessPermission![CAMERA_PTZ_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_MONITOR_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_SNAP_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_RECORD_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_TALK_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_VIDEOQUALITY_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_VIDEOMODEL_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_ENVMODEL_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_MOTIONDETECT_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_RECORDMODEL_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_FORMATSDCORD_CONTROL] as! String)
                funcValueArray.append((dataModel?.accessPermission![CAMERA_DEVICEINFO_CONTROL] as! String) ?? "1")// 默认值
            } else if dataModel?.model == RSD_CAMERA_TYPE_WIFI_A2 {
                funcNameArray = ["录像回放", "报警推送", "语音监听", "抓拍", "手动录像", "语音对讲"]
                funcValueArray.append(dataModel?.accessPermission![CAMERA_PLAYBACK_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_ALARM_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_MONITOR_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_SNAP_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_RECORD_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_TALK_CONTROL] as! String)

            } else if dataModel?.model == RSD_CAMERA_TYPE_WIFI_A3 {
                funcNameArray = ["录像回放","云台控制", "报警推送", "语音监听", "抓拍", "手动录像", "语音对讲", "视频遮挡"]
                funcValueArray.append(dataModel?.accessPermission![CAMERA_PLAYBACK_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_PTZ_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_ALARM_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_MONITOR_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_SNAP_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_RECORD_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_TALK_CONTROL] as! String)
                funcValueArray.append(dataModel?.accessPermission![CAMERA_VIDEOBLIND_CONTROL] as! String)
            }
        } else {}
        
        dateBeginStr = RSDFuncConfigurationVC.getCurrentTime()
        dateEndStr = "\(MAXYEAR)-12-31"
        timeBeginStr = "00:00:00"
        timeEndStr = "23:59:59"
        repeatDayStr  = "每天"
    }
    
    // MARK:布局UI
    private func setUpUI() {
        self.title = "功能权限配置"
        view.addSubview(self.mainTableView)
        self.mainTableView.backgroundColor = RSDBGViewColor
        self.mainTableView.tableFooterView = UIView()
        self.mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "mySharedCell")
        if self.isEditBool {
            self.mainTableView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-80)
            }
            view.addSubview(self.saveBtn)
            self.saveBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.bottom.equalToSuperview().offset(-20)
                make.height.equalTo(40)
            }
        }
    }
    
    //MARK:类方法 获取当前时间
    class  func getCurrentTime() -> String {
        let date: Date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"// HH:mm:ss.SSS
        let strNowTime = timeFormatter.string(from: date) as String
        return strNowTime
    }

    //MARK:加载日期的PickerView
    func creatOtherDatePickerView() {
        editTimeView?.hideDatePickerView()
        if editDateView2 == nil {//这里注意 因为确定按钮的位置原因  右边的view 一定要先于左边的view加载 数据先行  没办法 想偷懒不重复建立文件夹和重复写数据源代理方法之类的分情况讨论 、
            editDateView2 = RSDChooseDateView.init(frame: CGRect(x: RSDScreenWidth/2, y: view.height , width: RSDScreenWidth/2, height: 260), isRight: true)
            editDateView2?.backgroundColor = UIColor.white
            editDateView2?.delegate = self;
            view.addSubview(editDateView2!)
        }
        
        if editDateView == nil {
            editDateView = RSDChooseDateView.init(frame: CGRect(x: 0, y: view.height , width: RSDScreenWidth/2, height: 260), isRight: false)
            editDateView?.backgroundColor = UIColor.white
            editDateView?.delegate = self;
            view.addSubview(editDateView!)
        }
    }
    
    //MARK:加载时间的PickerView
    func creatTimePickerView() {
//        editPickerView?.hideDatePickerView()
        disMissViewMethod()
        if editTimeView == nil {
            editTimeView = RSDChooseTimeView.init(frame: CGRect(x: 0, y: view.height , width: RSDScreenWidth, height: 260))
            editTimeView?.backgroundColor = UIColor.white
            editTimeView?.delegate = self;
            view.addSubview(editTimeView!)
        }
    }
    
    //MARK:用DatePickerView写的加载日期 有缺点暂时不用
    func creatDatePickerView() {
        editTimeView?.hideDatePickerView()
        if editPickerView == nil {
            editPickerView = RSDChooseAuthorityPickerView.init(frame: CGRect(x: 0, y: view.height , width: RSDScreenWidth, height: 260))
            editPickerView?.backgroundColor = UIColor.white
            editPickerView?.delegate = self;
            view.addSubview(editPickerView!)
        }
    }

    //MARK:保存权限信息
    @objc func saveBtnClick() {
        var permissionDic: [String: Any] = Dictionary.init()
        if dataModel?.device == RSD_EQUIPMENT_TYPE_WIFI_CAMERA {
            if dataModel?.model == RSD_CAMERA_TYPE_WIFI_A1 || dataModel?.model == RSD_CAMERA_TYPE_WIFI_A4 {
                permissionDic[CAMERA_PTZ_CONTROL] = funcValueArray[0]
                permissionDic[CAMERA_MONITOR_CONTROL] = funcValueArray[1]
                permissionDic[CAMERA_SNAP_CONTROL] = funcValueArray[2]
                permissionDic[CAMERA_RECORD_CONTROL] = funcValueArray[3]
                permissionDic[CAMERA_TALK_CONTROL] = funcValueArray[4]
                permissionDic[CAMERA_VIDEOQUALITY_CONTROL] = funcValueArray[5]
                permissionDic[CAMERA_VIDEOMODEL_CONTROL] = funcValueArray[6]
                permissionDic[CAMERA_ENVMODEL_CONTROL] = funcValueArray[7]
                permissionDic[CAMERA_MOTIONDETECT_CONTROL] = funcValueArray[8]
                permissionDic[CAMERA_RECORDMODEL_CONTROL] = funcValueArray[9]
                permissionDic[CAMERA_FORMATSDCORD_CONTROL] = funcValueArray[10]
                permissionDic[CAMERA_DEVICEINFO_CONTROL] = funcValueArray[11]
                permissionDic[CAMERA_PASSWD_CONTROL] = "0"
                permissionDic[CAMERA_WIFI_CONTROL] = "0"
            } else if dataModel?.model == RSD_CAMERA_TYPE_WIFI_A2 {
                permissionDic[CAMERA_PLAYBACK_CONTROL] = funcValueArray[0]
                permissionDic[CAMERA_ALARM_CONTROL] = funcValueArray[1]
                permissionDic[CAMERA_MONITOR_CONTROL] = funcValueArray[2]
                permissionDic[CAMERA_SNAP_CONTROL] = funcValueArray[3]
                permissionDic[CAMERA_RECORD_CONTROL] = funcValueArray[4]
                permissionDic[CAMERA_TALK_CONTROL] = funcValueArray[5]
            } else if dataModel?.model == RSD_CAMERA_TYPE_WIFI_A3 {
                permissionDic[CAMERA_PLAYBACK_CONTROL] = funcValueArray[0]
                permissionDic[CAMERA_PTZ_CONTROL] = funcValueArray[1]
                permissionDic[CAMERA_ALARM_CONTROL] = funcValueArray[2]
                permissionDic[CAMERA_MONITOR_CONTROL] = funcValueArray[3]
                permissionDic[CAMERA_SNAP_CONTROL] = funcValueArray[4]
                permissionDic[CAMERA_RECORD_CONTROL] = funcValueArray[5]
                permissionDic[CAMERA_TALK_CONTROL] = funcValueArray[6]
                permissionDic[CAMERA_VIDEOBLIND_CONTROL] = funcValueArray[7]
            }
        } else {}
        //回传数据
//        dataModel?.datebegin = dateBeginStr
//        dataModel?.dateend = dateEndStr
//        dataModel?.timebegin = timeBeginStr
//        dataModel?.timeend = timeEndStr
//        dataModel?.accessPermission = permissionDic
        self.delegate?.changeDataDic(dateBegin: dateBeginStr, dateEnd: dateEndStr, timeBegin: timeBeginStr, timeEnd: timeEndStr, repeatStr: repeatDayStr, accorPrame: permissionDic, repeatInts: self.weekDayInt)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - 懒加载
    lazy var saveBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("保存", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.navBackGroundColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(self.saveBtnClick), for: .touchUpInside)
        return btn
    }()

    lazy var mainTableView: UITableView = {
        let tableview = UITableView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: view.height), style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
}

//MARK: - 扩展
extension RSDFuncConfigurationVC: UITableViewDelegate, UITableViewDataSource, RSDChooseAuthorityPickerViewDelegate, RSDChooseTimePickerDelegate, RSDChooseDatePickerDelegate, RSDSetRepeatDeleagte {
    
    //MARK: - RSDSetRepeatDeleagte
    func setRepeatDay(repeatStr: String, currentStateArray: [String], weekDayInt: Int) {
        self.weekDayInt = weekDayInt
        let indexPath = IndexPath.init(row: 2, section: 0)
        self.mainTableView.reloadRows(at: [indexPath], with: .automatic)
        let cell: UITableViewCell = self.mainTableView.cellForRow(at: indexPath)!
        cell.detailTextLabel?.text = repeatStr
        self.setRepeatDayArray = currentStateArray
        repeatDayStr = repeatStr
    }
    
    //MARK: - RSDChooseDatePickerDelegate
    //pickerView确定按钮点击方法 代理传的是右边的年月日数据
    func chooseDate(year: Int32, month: Int32, day: Int32) {
        //获取左边pickView年月日数据 是Int32
        let leftSelectYear = editDateView?.leftYearSelect
        let leftSelectMonth = editDateView?.leftMonthSelect
        let leftSelectDay = editDateView?.leftDaySelect
        //将左右pickerview 的 月日数据转化成字符串 =====》方便比较大小和cell上的展示
        var leftMonethStr = "\(String(describing: leftSelectMonth!))"
        var leftDayStr = "\(String(describing: leftSelectDay!))"
        var rightMonethStr = "\(String(describing: month))"
        var rightDayStr = "\(String(describing: day))"

        if leftMonethStr.count == 1 {
            leftMonethStr = "0" + leftMonethStr
        }
        if leftDayStr.count == 1 {
            leftDayStr = "0" + leftDayStr
        }
        if rightMonethStr.count == 1 {
            rightMonethStr = "0" + rightMonethStr
        }
        if rightDayStr.count == 1 {
            rightDayStr = "0" + rightDayStr
        }

        let leftStr = "\(String(describing: leftSelectYear!))" + leftMonethStr + leftDayStr
        let rightStr = "\(year)" + rightMonethStr + rightDayStr
        let leftInt = Int32(leftStr)
        let rightInt = Int32(rightStr)
//        print("左边选择的年月日=====\(leftSelectYear!) -\(leftMonethStr)-\(leftDayStr)")
//        print("右边选择的年月日=====\(year) -\(rightMonethStr)-\(rightDayStr)")
        if leftInt! > rightInt! {
            showErrorMessage(message: "开始日期不能大于结束日期，请重新选择")
            return
        }
        let indexPath = IndexPath.init(row: 0, section: 0)
        self.mainTableView.reloadRows(at: [indexPath], with: .automatic)
        let cell: UITableViewCell = self.mainTableView.cellForRow(at: indexPath)!
        cell.detailTextLabel?.text = "\(leftSelectYear!)-\(leftMonethStr)-\(leftDayStr)" + "到" + "\(year)-\(rightMonethStr)-\(rightDayStr)"
        dateBeginStr = "\(leftSelectYear!)-\(leftMonethStr)-\(leftDayStr)"
        dateEndStr = "\(year)-\(rightMonethStr)-\(rightDayStr)"
    }
    
    //pickView隐藏方法
    func disMissViewMethod() {
        UIView.animate(withDuration: 0.3) {
            self.editDateView2?.frame = CGRect(x: RSDScreenWidth/2, y: (self.view?.height)!, width: RSDScreenWidth/2, height: 260)
            self.editDateView?.frame = CGRect(x: 0, y: (self.view?.height)!, width: RSDScreenWidth/2, height: 260)
        }
    }
 
    //显示错误信息
    func showErrorMessage(message: String) {
        SVProgressHUD.showError(withStatus: message)
    }
    
    //MARK: - RSDChooseTimePickerDelegate
    //时间选择确认代理方法
    func chooseTime(timeString1: String, timeString2: String) {
        // 刷新cell
        let indexPath = IndexPath.init(row: 1, section: 0)
        self.mainTableView.reloadRows(at: [indexPath], with: .automatic)
        let cell: UITableViewCell = self.mainTableView.cellForRow(at: indexPath)!
        cell.detailTextLabel?.text = timeString1 + "到" + timeString2
        timeBeginStr = timeString1
        timeEndStr = timeString2
    }
    
    //MARK: - RSDChooseAuthorityPickerViewDelegate
    //DatePickerView的确认代理方法  现在已经不用了 还是那个问题 不能自定义 字体太大界面改不了
    func chooseDateOrTime(timeString1: String, timeString2: String) {
        // 刷新cell
        let indexPath = IndexPath.init(row: 0, section: 0)
        self.mainTableView.reloadRows(at: [indexPath], with: .automatic)
        let cell: UITableViewCell = self.mainTableView.cellForRow(at: indexPath)!
        cell.detailTextLabel?.text = timeString1 + "到" + timeString2
    }
    
    //MARK: - TableViewDelegate 和 dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return funcNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "mySharedCell")
//        if (cell == nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "mySharedCell")
//        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "分享日期"
                cell.detailTextLabel?.text = (dataModel?.datebegin)! + "到" + (dataModel?.dateend)!
                if self.isEditBool {
                    let maxYearStr = "\(MAXYEAR)"
                    cell.detailTextLabel?.text = RSDFuncConfigurationVC.getCurrentTime() + "到" + maxYearStr + "-12-31"
                }
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "分享时间段"
                cell.detailTextLabel?.text = (dataModel?.timebegin)! + "到" + (dataModel?.timeend)!
                if self.isEditBool {
                    cell.detailTextLabel?.text = "00:00:00" + "到" + "23:59:59"
                }
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "重复"
                cell.detailTextLabel?.text = timeString
                if self.isEditBool {
                    cell.detailTextLabel?.text = "每天"
                }
            }
        } else {
            let funcValue = funcValueArray[indexPath.row]
            cell.textLabel?.text = funcNameArray[indexPath.row]
            if funcValue == "1" {
                cell.accessoryType = .checkmark;
            } else {
                cell.accessoryType = .none;
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let views = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 20))
        view.backgroundColor = UIColor.groupTableViewBackground
        let titleLabel = UILabel.init(frame: CGRect(x: 15, y: 0, width: 200, height: 20))
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        views.addSubview(titleLabel)
        if section == 0 {
            titleLabel.text = "分享时间"
        } else {
            titleLabel.text = "设备功能"
        }
        return views
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !self.isEditBool { return }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
//                creatDatePickerView()
                creatOtherDatePickerView()
                editDateView?.showDatePickerView()
                editDateView2?.showDatePickerView()
//                editPickerView?.showDatePickerView()
            } else if indexPath.row == 1 {
                creatTimePickerView()
                editTimeView?.showDatePickerView()
            } else if indexPath.row == 2 {
                disMissViewMethod()
                editTimeView?.hideDatePickerView()
                let repeatVC = RSDSetRepeatVC()
                repeatVC.title = "重复日"
                repeatVC.delegate = self
                repeatVC.stateArray = self.setRepeatDayArray
                self.navigationController?.pushViewController(repeatVC, animated: true)
            }
        } else {
            let funcValue = funcValueArray[indexPath.row]
            if funcValue == "1" {
                funcValueArray.replaceSubrange(Range(indexPath.row..<indexPath.row + 1), with: ["0"])
            } else {
                funcValueArray.replaceSubrange(Range(indexPath.row..<indexPath.row + 1), with: ["1"])
            }
            self.mainTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        if funcNameArray.count > 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 * PROPORTION_Y
    }
}

