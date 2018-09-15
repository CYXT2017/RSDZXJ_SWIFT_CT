//
//  DES3Util.h
//  CC
//
//  Created by 张军 on 15/10/22.
//  Copyright © 2015年 张军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject


+(NSString *)AES128Encrypt:(NSString *)plainText withKey:(NSString *)key withGiv:(NSString *)ggIv;//加密
+(NSString *)AES128Decrypt:(NSString *)encryptText withKey:(NSString *)key withGiv:(NSString *)ggIv;//解密

@end
