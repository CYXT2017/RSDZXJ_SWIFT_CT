//
//  RSDMySharedCell.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/6.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

class RSDMySharedCell: UITableViewCell {
    private var leftImgView: UIImageView
    var titleLabel: UILabel
    private var titleDetailLabel001: UILabel
    private var titleDetailLabel002: UILabel
    private var downArrowImgView: UIImageView

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        leftImgView = UIImageView.init()
        downArrowImgView = UIImageView.init()
        titleLabel = UILabel.init()
        titleDetailLabel001 = UILabel()
        titleDetailLabel002 = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        self.contentView.backgroundColor = RSDBGViewColor
        let  bgView = UIView.init()
        self.contentView.addSubview(bgView)
        bgView.backgroundColor = UIColor.white
        bgView.snp.makeConstraints { (make) in
//            make.bottom.equalToSuperview().offset(-10)
            make.left.top.bottom.right.equalToSuperview()
        }
        
        bgView.addSubview(leftImgView)
        leftImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(32*PROPORTION_Y)
            
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.text = "安徽金凤凰交换机"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftImgView.snp.right).offset(10)
            make.top.equalToSuperview().offset(15)
        }
        
        bgView.addSubview(titleDetailLabel001)
        titleDetailLabel001.text = "分享给了：11111111"
        titleDetailLabel001.font = UIFont.systemFont(ofSize: 11)
        titleDetailLabel001.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        bgView.addSubview(titleDetailLabel002)
        titleDetailLabel002.text = "分享给了：11111111"
        titleDetailLabel002.font = UIFont.systemFont(ofSize: 11)
        titleDetailLabel002.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleDetailLabel001.snp.bottom).offset(10)
        }

        bgView.addSubview(downArrowImgView)
        downArrowImgView.image = UIImage.init(named: "news_center_drop_down")
        downArrowImgView.snp.makeConstraints { (make) in
            make.left.equalTo(titleDetailLabel001.snp.left).offset(50)
//            make.top.equalTo(titleDetailLabel002.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.height.equalTo(22)
        }
    }
    
    func updateTab(model: RSDMySharedModel, subArraysss: Array<Any>) {
        let headImg = RSDEquipmentPubLicFun.shareInstance.getDeviceImage(type: model.device!, model: model.model!)
        leftImgView.image = headImg
        titleLabel.text =  model.device_name
        let subArray: [Any] = subArraysss.first as! Array
        
        let subDic1: [String: Any] = subArray.first as! Dictionary
        let phoneStr1 = subDic1["phone"] as! String
        titleDetailLabel001.text = "分享给了：" + phoneStr1
        
        if subArray.count == 1 {
            titleDetailLabel002.isHidden = true
            downArrowImgView.isHidden = true
        } else if subArray.count == 2 {
            let subDic2: [String: Any] = subArray[1]  as! Dictionary
            let phoneStr2 = subDic2["phone"] as! String
            titleDetailLabel002.text = "分享给了：" + phoneStr2
            
            titleDetailLabel002.isHidden = false
            downArrowImgView.isHidden = true
        } else if subArray.count > 2 {
            downArrowImgView.isHidden = false
            titleDetailLabel002.isHidden = false
            
            let subDic2: [String: Any] = subArray[1]  as! Dictionary
            let phoneStr2 = subDic2["phone"] as! String
            titleDetailLabel002.text = "分享给了：" + phoneStr2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
