//
//  GlobalBaseDefines.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/6.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import Foundation

public let  KEY_STING = "STRING"

// WiFi 设备类型
let  RSD_EQUIPMENT_TYPE_WIFI_SOCKET =  "W1"
let  RSD_EQUIPMENT_TYPE_WIFI_IR =  "W2"
let  RSD_EQUIPMENT_TYPE_WIFI_SPYHOLE =  "W3"
let  RSD_EQUIPMENT_TYPE_WIFI_CAMERA =  "W4"
let  RSD_EQUIPMENT_TYPE_WIFI_CURTAIN =  "W5"
let  RSD_EQUIPMENT_TYPE_WIFI_PUSH =  "W6"
let  RSD_EQUIPMENT_TYPE_WIFI_COMBUSTIBLEGAS =  "W8"
let  RSD_EQUIPMENT_TYPE_WIFI_PM25 =  "W9"
let  RSD_EQUIPMENT_TYPE_WIFI_SWITCH =  "WP"
let  RSD_EQUIPMENT_TYPE_WIFI_SCENESWITCH =  "WQ"
let  RSD_EQUIPMENT_TYPE_WIFI_MUSICBOARD =  "WA"
let  RSD_EQUIPMENT_TYPE_WIFI_VOICEHOME =  "WB"

let RSD_EQUIPMENT_TYPE_WIFI_ROBOT           = "WE"
let RSD_EQUIPMENT_TYPE_WIFI_TEMPECONTROL    = "WF"
let RSD_EQUIPMENT_TYPE_WIFI_MASSAGECHAIR    = "WG"
let RSD_EQUIPMENT_TYPE_WIFI_VIDEODOOR       = "WI"
let RSD_EQUIPMENT_TYPE_WIFI_GATEWAY433      = "WS"
let RSD_EQUIPMENT_TYPE_WIFI_GATEWAYZAX      = "WT"
let RSD_EQUIPMENT_TYPE_WIFI_GATEWAY         = "WZ"
let RSD_EQUIPMENT_TYPE_WIFI_ElectromagneticFurnace         = "WK"


//门锁
let    RSD_EQUIPMENT_TYPE_NB_DOORLOCK                  = "Na"

// WiFi 红外类型
let RSD_IR_TYPE_WIFI_A1  = "A1" //
let RSD_IR_TYPE_WIFI_A2  = "A2" // 酷控红外
// WiFi 猫眼类型
let RSD_SPYHOLE_TYPE_WIFI_A1     = "A1"//移康猫眼
// WiFi 摄像机类型
let RSD_CAMERA_TYPE_WIFI_A1  = "A1"//普顺达摄像机
let RSD_CAMERA_TYPE_WIFI_A2  = "A2"//萤石摄像机C2
let RSD_CAMERA_TYPE_WIFI_A3  = "A3"//萤石摄像机C6
let RSD_CAMERA_TYPE_WIFI_A4  = "A4"//技威摄像机
// WiFi 开关类型
let RSD_SWITCH_TYPE_WIFI_A1  = "A1"//一键开关
let RSD_SWITCH_TYPE_WIFI_A2  = "A2"//二键开关
let RSD_SWITCH_TYPE_WIFI_A3  = "A3"//三键开关
let RSD_SWITCH_TYPE_WIFI_A4  = "A4"//四键开关
// WiFi 网关类型
let RSD_GATEWAY_TYPE_WIFI_A1   = "A1"//飞比网关


// ZigBee 设备类型
let    RSD_EQUIPMENT_TYPE_ZIGBEE_SOCKET                          = "Z1"
let    RSD_EQUIPMENT_TYPE_ZIGBEE_SWITCH                          = "Z4"
let    RSD_EQUIPMENT_TYPE_ZIGBEE_CURTAIN                         = "Z5"
let    RSD_EQUIPMENT_TYPE_ZIGBEE_MOTION_DETECT_SENSOR            = "Z6"
let    RSD_EQUIPMENT_TYPE_ZIGBEE_DOOR_SENSOR                     = "Z7"
let    RSD_EQUIPMENT_TYPE_ZIGBEE_TEMP_HUMI_SENSOR                = "Z8"
let    RSD_EQUIPMENT_TYPE_ZIGBEE_URGENT_SENSOR                   = "Z9"
let    RSD_EQUIPMENT_TYPE_ZIGBEE_DOORLOCK                        = "Za"
let    RSD_EQUIPMENT_TYPE_ZIGBEE_PUSH                            = "Zb"
let    RSD_EQUIPMENT_TYPE_ZIGBEE_ROLLER_BLIND                    = "Zc"

// ZigBee 开关类型
let    RSD_SWITCH_TYPE_ZIGBEE_A1                           = "A1"
let    RSD_SWITCH_TYPE_ZIGBEE_A2                           = "A2"
let    RSD_SWITCH_TYPE_ZIGBEE_A3                           = "A3"

// 小达类型
let    RSD_VoiceHome_TYPE_A1                           = "A1"
let    RSD_VoiceHome_TYPE_A2                           = "A2"
let    RSD_VoiceHome_TYPE_B5                           = "B5"
let    RSD_VoiceHome_TYPE_B1                           = "B1"
let    RSD_VoiceHome_TYPE_B2                           = "B2"
let    RSD_VoiceHome_TYPE_B3                           = "B3"
let    RSD_VoiceHome_TYPE_B4                           = "B4"
let    RSD_VoiceHome_TYPE_B6                           = "B6"
let    RSD_VoiceHome_TYPE_D1                           = "D1"

// ZigBee 窗帘电机型号
let    RSD_CURTAIN_TYPE_ZIGBEE_A1        = "A1"
let    RSD_CURTAIN_TYPE_ZIGBEE_A2        = "A2"

////433 设备类型
//无源开关
let    RSD_EQUIPMENT_TYPE_433_SWITCH_NO_POWER              = "S1"
//无源圆形开关（翻转型开关）
let    RSD_EQUIPMENT_TYPE_433_CIRCLESWITCH_NO_POWER        = "S2"
//无源发射器
let    RSD_EQUIPMENT_TYPE_433_EMITTER_NO_POWER             = "S3"
// 单火线开关
let    RSD_EQUIPMENT_TYPE_SWITCH_SINGER_FIRE               = "S1"
//有源接收器
let    RSD_EQUIPMENT_TYPE_433_RECEIVER_POWER               = "s1"
//有回收感应有源墙壁开关
let    RSD_EQUIPMENT_TYPE_433_WALLSWITCH_POWER             = "s2"
//无挥手感应通道墙壁开关
let    RSD_EQUIPMENT_TYPE_433_CHANNELWALLSWITCH_POWER      = "s3"
//可调光设备
let    RSD_EQUIPMENT_TYPE_433_LIGHTCONTROL_POWER           = "s4"

///433 设备子类型
//433 无源 开关     S1
let    RSD_SWITCH_NO_POWER_TYPE_433_A1                     = "A1"
let    RSD_SWITCH_NO_POWER_TYPE_433_A2                     = "A2"
let    RSD_SWITCH_NO_POWER_TYPE_433_A3                     = "A3"
let    RSD_SWITCH_NO_POWER_TYPE_433_A4                     = "A4"

//433 无源圆形开关   S2
let    RSD_CIRCLESWITCH_NO_POWER_TYPE_433_A1               = "A1"
let    RSD_CIRCLESWITCH_NO_POWER_TYPE_433_A2               = "A2"
let    RSD_CIRCLESWITCH_NO_POWER_TYPE_433_A3               = "A3"
let    RSD_CIRCLESWITCH_NO_POWER_TYPE_433_A4               = "A4"

//无源发射器         S3
let    RSD_EMITTER_NO_POWER_TYPE_433_A1                    = "A1"


let    RSD_EQUIPMENT_TYPE_SINGER_FIRE                       = "S1"


// 单火线开关  S1
let    RSD_SWITCH_NO_POWER_TYPE_SINGER_FIRE_Ac             = "Ac"
let    RSD_SWITCH_NO_POWER_TYPE_SINGER_FIRE_Ab             = "Ab"
let    RSD_SWITCH_NO_POWER_TYPE_SINGER_FIRE_Aa             = "Aa"

//433 有源单通接收器  s1
let    RSD_RECEIVER_POWER_TYPE_433_A1                      = "A1"

//433 有源墙壁单开   s2
let    RSD_WALLSWITCH_POWER_TYPE_433_A1                    = "A1"
let    RSD_WALLSWITCH_POWER_TYPE_433_A2                    = "A2"
let    RSD_WALLSWITCH_POWER_TYPE_433_A3                    = "A3"
let    RSD_WALLSWITCH_POWER_TYPE_433_A4                    = "A4"

//433 有源通道墙壁单开 s3
let    RSD_CHANNELWALLSWITCH_POWER_TYPE_433_A1             = "A1"
let    RSD_CHANNELWALLSWITCH_POWER_TYPE_433_A2             = "A2"
let    RSD_CHANNELWALLSWITCH_POWER_TYPE_433_A3             = "A3"
let    RSD_CHANNELWALLSWITCH_POWER_TYPE_433_A4             = "A4"

//433 可调光设备     s4
let    RSD_LIGHTCONTRO_POWER_TYPE_433_A3                   = "A1"

///中安消子设备类型
//无线门磁
let    RSD_EQUIPMENT_TYPE_ZAX_WIRELESS_DOOR_SENSOR         = "T1"
//无线红外探测器
let    RSD_EQUIPMENT_TYPE_ZAX_WIRELESS_IR                  = "T2"
//可燃气体
let    RSD_EQUIPMENT_TYPE_ZAX_COMBUSTIBLEGAS               = "T3"
//烟感
let    RSD_EQUIPMENT_TYPE_ZAX_MIST_SENSOR                  = "T4"
//水浸传感
let    RSD_EQUIPMENT_TYPE_ZAX_WATERLOG_SENSOR              = "T5"



///中安消子类型下的小类型
//无线门磁A1
let    RSD_WIRELESS_DOOR_SENSOR_TYPE_ZAX_A1                = "A1"
//无线红外探测器A1
let    RSD_WIRELESS_IR_TYPE_ZAX_A1                         = "A1"
//可燃气体A1
let    RSD_COMBUSTIBLEGAS_TYPE_ZAX_A1                      = "A1"
//烟感A1
let    RSD__MIST_SENSOR_TYPE_ZAX_A1                        = "A1"
//水浸传感A1
let    RSD__WATERLOG_SENSOR_TYPE_ZAX_A1                    = "A1"

//NB设备类型
//可燃气体
let    RSD_EQUIPMENT_TYPE_NB_COMBUSTIBLEGAS               = "T3"
//烟感
let    RSD_EQUIPMENT_TYPE_NB_MIST_SENSOR                  = "T4"

//NB设备类型下的小类型
//NB中安消
let    RSD_SENSOR_TYPE_NB_ZHONG_AN_XIAO_A2                        = "A2"  //中安消版本模块
//可燃气体A2
let    RSD_COMBUSTIBLEGAS_TYPE_NB_A2                      = "A2"  //内含中安消版本模块
//烟感A2
let    RSD__MIST_SENSOR_TYPE_NB_A2                        = "A2"  //内含中安消版本模块
// 烟感A4
let    RSD_EQUIPMENT_TYPE__NB_004_A4                      = "A4"

//NB汉威
let    RSD_SENSOR_TYPE_NB_HAN_WEI_A3                        = "A3"  //汉威版本模块
//可燃气体A3
let    RSD_COMBUSTIBLEGAS_TYPE_NB_A3                      = "A3"  //内含汉威版本模块
//烟感A3
let    RSD__MIST_SENSOR_TYPE_NB_A3                        = "A3"  //内含汉威版本模块

//门锁A1
let    RSD__DOOR_LOCK_TYPE_NB_A1                        = "A1"



//摄像头权限
let CAMERA_PTZ_CONTROL             = "ptz_control_enable"
let CAMERA_MONITOR_CONTROL         = "monitor_control_enable"
let CAMERA_SNAP_CONTROL            = "snap_control_enable"
let CAMERA_RECORD_CONTROL          = "record_control_enable"
let CAMERA_TALK_CONTROL            = "talk_control_enable"
let CAMERA_PASSWD_CONTROL          = "passwd_control_enable"
let CAMERA_WIFI_CONTROL            = "wifi_control_enable"
let CAMERA_VIDEOQUALITY_CONTROL    = "videoquality_control_enable"
let CAMERA_VIDEOMODEL_CONTROL      = "videomodel_control_enable"
let CAMERA_ENVMODEL_CONTROL        = "envmodel_control_enable"
let CAMERA_MOTIONDETECT_CONTROL    = "motiondetect_control_enable"
let CAMERA_RECORDMODEL_CONTROL     = "recordmodel_control_enable"
let CAMERA_FORMATSDCORD_CONTROL    = "formatsdcord_control_enable"
let CAMERA_DEVICEINFO_CONTROL      = "deviceinfo_control_enable"
let CAMERA_PLAYBACK_CONTROL        = "playback_control_enable"
let CAMERA_VIDEOBLIND_CONTROL      = "videoblind_control_enable"
let CAMERA_ALARM_CONTROL           = "alarm_control_enable"
let CAMERA_SETTING_CONTROL         = "setting_control_enable"


