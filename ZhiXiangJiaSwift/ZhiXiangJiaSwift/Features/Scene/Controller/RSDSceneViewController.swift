//
//  RSDSceneViewController.swift
//  ZhiXiangJiaSwift
//
//  Created by Jack(张军) on 2018/8/20.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//
/*
 场景列表控制界面
 */

import UIKit
let cellId = "JKSceneCell"
class RSDSceneViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    var dataArray: Array<Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initTableView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 初始化数据;
    func loadData(){
        dataArray = Array()
    }
    
    // MARK: - 获取网络数据;
    func getServiceData(){
        
    }
    
    //测试Json解析
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    //解析数据
    func anlayDat(arr:NSArray) -> Void {
        dataArray.removeAll()
        for it in arr
        {
            let jsonString = (it as! [AnyHashable : Any]).toJSONString()
            if let jsonData = jsonString?.data(using: String.Encoding.utf8)
            {
                // 解码成功
                if let model = try? JSONDecoder().decode(RSDSceneModel.self, from: jsonData)
                {
                    print(model.name)
                }
            }
        }
    }
    
    // MARK: - 初始化View;
    private func initTableView(){
        mainTableView.register(UINib.init(nibName: "RSDSceneTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
}

extension RSDSceneViewController:UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray == nil {
            return 0;
        }
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dataArray[indexPath.row] as!RSDSceneModel;
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as!RSDSceneTableViewCell
        cell.textLabel?.text = object.name
        return cell
    }
    
}

//测试上传图片
extension RSDSceneViewController: UIImagePickerControllerDelegate {
    // 用户选取图片之后
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 参数 UIImagePickerControllerOriginalImage 代表选取原图片，这里使用 UIImagePickerControllerEditedImage 代表选取的是经过用户拉伸后的图片。
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            // 这里对选取的图片进行你需要的操作，通常会调整 ContentMode。
            //先把图片转成NSData
            let data1 = UIImageJPEGRepresentation(pickedImage, 0.5)
            
        }
        // 必须写这行，否则拍照后点击重新拍摄或使用时没有返回效果。
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RSDSceneViewController: UINavigationControllerDelegate {
    // 这里可以什么都不写
}

extension RSDSceneViewController {
    private func open() -> Void {
        // 判断相机是否可用
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            // 表示操作为拍照
            imagePicker.sourceType = .camera
            // 拍照后允许用户进行编辑
            imagePicker.allowsEditing = true
            // 也可以设置成视频
            imagePicker.cameraCaptureMode = .photo
            // 设置代理为 ViewController，已经实现了协议
            imagePicker.delegate = self
            // 进入拍照界面
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            // 照相机不可用
        }
    }
}

