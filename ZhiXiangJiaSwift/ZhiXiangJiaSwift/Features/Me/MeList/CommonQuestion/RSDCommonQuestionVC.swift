
//
//  CommonQuestionVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/31.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

class RSDCommonQuestionVC: UIViewController {
    private var titleArray : [String] = []
    private var contentArray : [String] = []
    private var stateArray : [String] = []
    
    //MARK: - SystemCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.mainTableView)
        self.mainTableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        self.mainTableView.tableFooterView = UIView()
        self.mainTableView.register(RSDUserCenterTableViewCell.classForCoder(), forCellReuseIdentifier: "cellString")
        self.getDataForFasherTabView()
    }

    //MARK: - Private
    func getDataForFasherTabView() {
        titleArray = ["家项中的常用设备是按照什么排序的?","如何将设备添加到房间里？","如何将设备从一个房间移动到另一个房间？","华为EMUI系统绑定WIFI设备时，获取不到SSID？","Android 手机收不到推送?","设备无法入网","设备在离线状态不对","收藏后的设备主界面不显示","摄像头历史信息存储问题","子设备信息日志"]
        contentArray = ["按照设备使用频率由高到低排列。","先添加相应房间，进入添加房间设备列表，勾选需要添加到该房间的设备。","家>设置房间〉选择目的房间，进入编辑，勾选您需要移动的设备即可。","请到手机设置中打开GPS。","请到设置-权限中打开应用自启动、设置中打开通知。","请先确保设备处于入网状态、设备以已经执行过退网操作，网关处于允许入网状态，设备方可入网。","设备会有上报网关数据时间，当设备上报给网关状态3-4次离线，网关会返回该设备处于离线状态，设备列表会显示该设备离线","确保设备收藏成功，确保登录方式，因为本地登录收藏后的设备不显示，仅在远程登录显示。","当摄像头处于全天录像和有人时录像，记录存储在sd卡中；当摄像头拍照和录像，记录存储在当前手机中。","仅有在远程登录下，才可查看子设备信息日志。"];
        let count = titleArray.count
        for _ in 0..<count {
            stateArray.append("0")
        }
        self.mainTableView.reloadData()
    }
    
    //MARK: 区头点击方法
    @objc func upDataTableVies(_ tap: UITapGestureRecognizer) {
        stateArray[(tap.view?.tag)! - 8888] = stateArray[(tap.view?.tag)! - 8888] == "1" ? "0" : "1"
        self.mainTableView.reloadData()
        let tempArr: [String] = stateArray
        let count = (tap.view?.tag)! - 8888
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if tempArr[count] == "1" {
                let index = IndexPath.init(row: 0, section: count);
                self.mainTableView.scrollToRow(at:index, at: UITableViewScrollPosition.bottom, animated: true);
            }
        }
    }

    //MARK: - 懒加载
    lazy var mainTableView:UITableView = {
       let tableView = UITableView.init(frame:CGRect(x: 0, y: 0, width: view.width, height: view.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = RSDBGViewColor

        return tableView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}

//MARK: - 自定义区头
class titleHeadView: UIView {
    var signImgViews: UIImageView?
    var lineView: UIImageView?
    //用遍历初始化器 就可以不用重写 指定初始化器和必要初始化器了
    convenience init(frame: CGRect, stateArr: [String], section: Int, titleArray: [String]) {
        self.init(frame: frame)
        setUpView(stateArr: stateArr, section: section, titleArray: titleArray)
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    //MARK:布局区头
    func setUpView(stateArr: [String], section: Int, titleArray: [String]) {
        self.backgroundColor = UIColor.white
        let qImgView = UIImageView.init()
        qImgView.image = UIImage.init(named: "my_usualQuestion")
        self.addSubview(qImgView)
        qImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(40 * PROPORTION_Y)
        }
        
        let headTitleLabel = UILabel.init()
        headTitleLabel.numberOfLines = 0
        headTitleLabel.font = UIFont.systemFont(ofSize: 15)
        headTitleLabel.textColor = UIColor.init(colorWithHex: "666666")
        if titleArray.count != 0 {
            headTitleLabel.text = titleArray[section]
        }
        self.addSubview(headTitleLabel)
        headTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(qImgView.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(35 * PROPORTION_Y)
            make.width.equalTo(RSDScreenWidth - 120)
        }
        
        let signImgView = UIImageView.init()
        self.signImgViews = signImgView
        //        qImgView.image = UIImage.init(named: "my_usualQuestion")
        self.addSubview(signImgView)
        signImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview();
            make.right.equalToSuperview().offset(-15);
            make.width.equalTo(40*PROPORTION_Y);
            make.height.equalTo(35*PROPORTION_Y);
        }
        
        let line = UIImageView.init()
        self.lineView = line
        self.addSubview(line)
        line.image = UIImage.init(named: "my_lineImgView")
        line.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview();
            make.height.equalTo(1);
        }
        
        let imageName = stateArr[section] == "1" ? "my_usualQuestion_downArrow" : "my_usualQuestion_rightArrow"
        signImgView.image = UIImage.init(named: imageName)
        line.isHidden = stateArr[section] == "1" ? true : false
    }
}

//MARK: - 扩展RSDCommonQuestionVC
extension  RSDCommonQuestionVC :UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headViews = titleHeadView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: 45.0 * PROPORTION_Y), stateArr: stateArray, section: section, titleArray: titleArray)
        headViews.tag = 8888 + section
        headViews.isUserInteractionEnabled = true
        let tapGuster = UITapGestureRecognizer.init(target: self, action: #selector(self.upDataTableVies (_ :)))
        headViews.addGestureRecognizer(tapGuster)
        return headViews
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0 * PROPORTION_Y
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var hieght = getTextHeigh(textStr: contentArray[indexPath.section], font: UIFont.systemFont(ofSize: 15), width: (tableView.width - 15 - 40 * PROPORTION_Y - 6 - 5))
        if hieght < 45 {
            hieght = 45
        }
        return hieght * PROPORTION_Y
    }
    
    func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        
        let normalText: NSString = textStr as NSString
        let size = CGSize(width: width, height: 1000)
        let dic:NSDictionary = [NSAttributedStringKey.font: font]
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        return stringSize.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateArray[section] == "1" ? 1 : 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return stateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cellString"
        var cell:RSDUserCenterTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RSDUserCenterTableViewCell
        if (cell == nil) {
            cell = RSDUserCenterTableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell.selectionStyle = .none
        if contentArray.count != 0 {
            cell.titleLabel?.text = contentArray[indexPath.section]
        }
        cell.titleLabel?.textColor = UIColor.init(colorWithHex: "A9ABAE")
        cell.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.titleLabel?.numberOfLines = 0;
        cell.upDataHeadImgView(cell: cell, imgName: "my_usualQuestion_A")
        creatBottomLineViewWith(view: cell.contentView)
        return cell
    }
}

func creatBottomLineViewWith(view: UIView) {
    let lineViews = UIImageView.init(image: UIImage.init(named: "my_lineImgView"))
    view.addSubview(lineViews)
    lineViews.snp.makeConstraints { (make) in
        make.left.bottom.right.equalToSuperview();
        make.height.equalTo(1)
    }
}


