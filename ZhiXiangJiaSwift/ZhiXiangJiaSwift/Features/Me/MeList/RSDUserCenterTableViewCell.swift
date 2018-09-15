//
//  RSDUserCenterTableViewCell.swift
//  自定义view
//
//  Created by ios on 2018/8/14.
//  Copyright © 2018年 ctbhongwaibao. All rights reserved.
//

import UIKit

class RSDUserCenterTableViewCell: UITableViewCell {
    var titleLabel:UILabel?
    var  headImgView: UIImageView?
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.headImgView = UIImageView.init()
        self.titleLabel = UILabel()
        self.contentView.addSubview(self.headImgView!)
        self.contentView.addSubview(self.titleLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpDataForTableViewCell(titleArr:NSArray ,index:IndexPath) {
        let title = titleArr.object(at: index.section) as? NSArray
        self.titleLabel?.text = title?.object(at: index.row) as? String
        
        if index.section == 0 {
            self.headImgView?.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(60 * PROPORTION_Y)
            })
            self.headImgView?.clipsToBounds = true
            self.headImgView?.layer.cornerRadius = 30 * PROPORTION_Y
            
        } else {
            self.headImgView?.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(30 * PROPORTION_Y)
            }
            self.headImgView?.clipsToBounds = true
            self.headImgView?.layer.cornerRadius = 15 * PROPORTION_Y
        }
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((self.headImgView?.snp.right)!).offset(10)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview()
        })
    }
    
    func upDataHeadImgView(cell: RSDUserCenterTableViewCell, imgName: String) {
//        self.headImgView?.frame = CGRect(x: 6, y: (cell.height-40 * PROPORTION_Y)/2, width: 40 * PROPORTION_Y, height: 40 * PROPORTION_Y)
        self.headImgView?.image = UIImage.init(named: imgName)
        self.headImgView?.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(40 * PROPORTION_Y)
        }
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((self.headImgView?.snp.right)!).offset(5)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        })
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
