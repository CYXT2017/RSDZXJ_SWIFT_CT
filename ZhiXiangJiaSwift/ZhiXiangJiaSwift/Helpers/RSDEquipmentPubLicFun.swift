//
//  RSDEquipmentPubLicFun.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/6.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit

class RSDEquipmentPubLicFun: NSObject {
    /// 共享实例
    static let shareInstance = RSDEquipmentPubLicFun()
    /// 初始化
    override init(){}

    func getDeviceImage(type: String, model: String) ->UIImage {
        var image :UIImage
        image = UIImage.init(named: "myhead")!
      
        if(  type == RSD_EQUIPMENT_TYPE_WIFI_SOCKET  )
        {
            image = UIImage.init(named: "device_socket1")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_WIFI_IR  )
        {
            if (  model == RSD_IR_TYPE_WIFI_A1  ) {
                image = UIImage.init(named: "device_ir")!
            }
            else {
                image = UIImage.init(named: "device_ir_kk")!
            }
        }
        else if(  type == RSD_EQUIPMENT_TYPE_WIFI_SPYHOLE  )
        {
            image = UIImage.init(named: "device_spyhole")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_WIFI_CAMERA  )
        {
            if (  model == RSD_CAMERA_TYPE_WIFI_A1  )
            {
                image = UIImage.init(named: "device_camera")!
            }
            else if (  model == RSD_CAMERA_TYPE_WIFI_A2  )
            {
                image = UIImage.init(named: "device_camera_c2")!
            }
            else if (  model == RSD_CAMERA_TYPE_WIFI_A3  )
            {
                image = UIImage.init(named: "device_camera_c6")!
            }
            else if (  model == RSD_CAMERA_TYPE_WIFI_A4  )
            {
                image = UIImage.init(named: "device_camera_yse")!
            }
        }
        else if(  type == RSD_EQUIPMENT_TYPE_WIFI_CURTAIN  )
        {
            image = UIImage.init(named: "device_curtain")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_WIFI_PUSH  )
        {
            image = UIImage.init(named: "device_push")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_COMBUSTIBLEGAS  )
        {
            image = UIImage.init(named: "device_combustibleGas")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_PM25  )
        {
            image = UIImage.init(named: "device_PM25")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_SWITCH  )
        {
            image = UIImage.init(named: "device_four_switch")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_SCENESWITCH  )
        {
            image = UIImage.init(named: "device_scene_switch")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_MUSICBOARD  )
        {
            image = UIImage.init(named: "device_musicboard")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_VOICEHOME  )
        {
            image = UIImage.init(named: "device_voice_home")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_ROBOT  )
        {
            image = UIImage.init(named: "device_robot")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_TEMPECONTROL  )
        {
            image = UIImage.init(named: "device_tempControl")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_MASSAGECHAIR  )
        {
            image = UIImage.init(named: "device_massage_chair")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_VIDEODOOR  )
        {
            image = UIImage.init(named: "device_musicboard")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_WIFI_GATEWAY433  )
        {
            image = UIImage.init(named: "device_gateway433")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_WIFI_GATEWAYZAX  )
        {
            image = UIImage.init(named: "device_zaxGateway")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZAX_WIRELESS_DOOR_SENSOR  )
        {
            image = UIImage.init(named: "device_zax_doorMangent")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZAX_WIRELESS_IR  )
        {
            image = UIImage.init(named: "device_zax_humbody")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZAX_COMBUSTIBLEGAS  )
        {
            
            if (  model == RSD_COMBUSTIBLEGAS_TYPE_ZAX_A1  )
            {
                image = UIImage.init(named: "device_zax_combusti")!
            }
            else if (  model == RSD_COMBUSTIBLEGAS_TYPE_NB_A2  )
            {
                image = UIImage.init(named: "device_zax_combusti")!
            }
            else if (  model == RSD_COMBUSTIBLEGAS_TYPE_NB_A3  )
            {
                image = UIImage.init(named: "device_nb_combusti")!
            }
            else
            {
                image = UIImage.init(named: "device_zax_combusti")!
            }
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZAX_MIST_SENSOR  )
        {
            if (  model == RSD_EQUIPMENT_TYPE__NB_004_A4  ) {
                image = UIImage.init(named: "device_nb_combusti_A4")!
            } else {
                image = UIImage.init(named: "device_sensor_zax_mist")!
            }
            
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZAX_WATERLOG_SENSOR  )
        {
            image = UIImage.init(named: "device_zax_watrer")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_WIFI_GATEWAY  )
        {
            image = UIImage.init(named: "device_gateway")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZIGBEE_SOCKET  )
        {
            image = UIImage.init(named: "device_socket1")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZIGBEE_SWITCH  )
        {
            if (  model == RSD_SWITCH_TYPE_ZIGBEE_A1  )
            {
                image = UIImage.init(named: "device_switch1")!
            }
            else if (  model == RSD_SWITCH_TYPE_ZIGBEE_A2  )
            {
                image = UIImage.init(named: "device_switch2")!
            }
            else if (  model == RSD_SWITCH_TYPE_ZIGBEE_A3  )
            {
                image = UIImage.init(named: "device_switch3")!
            }
            else
            {
                image = UIImage.init(named: "device_switch1")!
            }
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZIGBEE_CURTAIN  )
        {
            image = UIImage.init(named: "device_curtain")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZIGBEE_MOTION_DETECT_SENSOR  )
        {
            image = UIImage.init(named: "device_sensor_motion_detect")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZIGBEE_DOOR_SENSOR  )
        {
            image = UIImage.init(named: "device_sensor_doorlock")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZIGBEE_TEMP_HUMI_SENSOR  )
        {
            image = UIImage.init(named: "device_tempAndHum")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZIGBEE_URGENT_SENSOR  )
        {
            image = UIImage.init(named: "device_sensor_urgent")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZIGBEE_DOORLOCK   ||   type == RSD_EQUIPMENT_TYPE_NB_DOORLOCK  )
        {
            image = UIImage.init(named: "device_doorlock")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZIGBEE_PUSH  )
        {
            image = UIImage.init(named: "device_push")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_ZIGBEE_ROLLER_BLIND  )
        {
            image = UIImage.init(named: "device_roller_blind")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_433_RECEIVER_POWER  )
        {
            image = UIImage.init(named: "device_reciver")!
        }
        else if(  type == RSD_EQUIPMENT_TYPE_433_WALLSWITCH_POWER  )
        {
            
        }
        else if(  type == RSD_EQUIPMENT_TYPE_433_CHANNELWALLSWITCH_POWER  )
        {
            
        }
        else if(  type == RSD_EQUIPMENT_TYPE_433_LIGHTCONTROL_POWER  )
        {
            
        }
        else if(  type == RSD_EQUIPMENT_TYPE_433_SWITCH_NO_POWER  )
        {
            if (  model == RSD_SWITCH_NO_POWER_TYPE_433_A1  ) {
                image = UIImage.init(named: "device_nopower_switch_A1")!
            }
            else if (  model == RSD_SWITCH_NO_POWER_TYPE_433_A2  )
            {
                image = UIImage.init(named: "device_nopower_switch_A2")!
            }
            else if (  model == RSD_SWITCH_NO_POWER_TYPE_433_A3  )
            {
                image = UIImage.init(named: "device_nopower_switch_A1")!
            }   else if (  model == RSD_SWITCH_NO_POWER_TYPE_SINGER_FIRE_Aa  )
            {
                image = UIImage.init(named: "device_add_singerFire1")!
            }  else if (  model == RSD_SWITCH_NO_POWER_TYPE_SINGER_FIRE_Ab  )
            {
                image = UIImage.init(named: "device_add_singerFire2")!
            }  else if (  model == RSD_SWITCH_NO_POWER_TYPE_SINGER_FIRE_Ac  )
            {
                image = UIImage.init(named: "device_add_singerFire3")!
            }
            
        }
        else if(  type == RSD_EQUIPMENT_TYPE_433_CIRCLESWITCH_NO_POWER  )
        {
            if (  model == RSD_CIRCLESWITCH_NO_POWER_TYPE_433_A1  ) {
                image = UIImage.init(named: "device_nopower_switch_A1")!
            }
            else if (  model == RSD_CIRCLESWITCH_NO_POWER_TYPE_433_A2  )
            {
                image = UIImage.init(named: "device_nopower_switch_A2")!
            }
            else if (  model == RSD_CIRCLESWITCH_NO_POWER_TYPE_433_A3  )
            {
                image = UIImage.init(named: "device_nopower_switch_A3")!
            }
            else if (  model == RSD_CIRCLESWITCH_NO_POWER_TYPE_433_A4  )
            {
                image = UIImage.init(named: "device_nopower_switch_A4")!
            }
        }
        else if(  type == RSD_EQUIPMENT_TYPE_433_EMITTER_NO_POWER  )
        {
            image = UIImage.init(named: "device_nopower_switch_A1")!
        }
        else if (  type == RSD_EQUIPMENT_TYPE_WIFI_ElectromagneticFurnace  )
        {
            image = UIImage.init(named: "device_ElectromagneticFurnace")!
        }
        
        return image;
    }
    
    
    
}
