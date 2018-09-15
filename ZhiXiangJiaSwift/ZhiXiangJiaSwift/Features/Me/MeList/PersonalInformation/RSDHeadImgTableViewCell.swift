//
//  RSDHeadImgTableViewCell.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/8/31.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import Kingfisher

class RSDHeadImgTableViewCell: UITableViewCell {
    var headImgView: UIImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    convenience  init(style: UITableViewCellStyle, reuseIdentifier: String?, headImg: UIImage, titleName: String) {
//        self.init(style: style, reuseIdentifier: reuseIdentifier, headImg: headImg, titleName: titleName)
//        setupUIWithData(headImg: headImg, titleName: titleName)
//    }
    
    func setupUI() {
        self.accessoryType = .disclosureIndicator
        self.textLabel?.textColor = UIColor.titleLabelColor(red: 102, green: 102, blue: 102,alpha: 1.0);
        self.headImgView = UIImageView.init(frame:CGRect(x: RSDScreenWidth - 102, y: 5, width: 70, height: 70))
        self.headImgView.clipsToBounds = true
        self.headImgView.layer.cornerRadius = 35
        self.contentView.addSubview(self.headImgView)
    }

    func setupUIWithData(headImgString: String, titleName: String) {
        self.textLabel?.text = titleName;
        var newUrlString: String = ""
        if !headImgString.contains("http") {
            newUrlString = RSDBaseUrl_Real + headImgString
        } else {
            newUrlString = headImgString
        }
        let url = URL(string: newUrlString)
        self.headImgView.kf.setImage(with: ImageResource(downloadURL: url!), placeholder: UIImage(named: "myhead"), options: nil, progressBlock: nil, completionHandler: nil)
        
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
