//
//  UntilFunctions.h
//  duosq
//
//  Created by juno on 14-8-4.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UntilFunctions : NSObject

+ (NSString*)getStringMD5:(NSString*)str;

+ (NSString*)generateUUID;

// 是否wifi
+ (BOOL) IsEnableWIFI;

// 是否3G
+ (BOOL) IsEnable3G;

+ (NSString *)platform;

+ (NSString *)getUrl:(NSDictionary *)new_params;

+ (NSString*)encodeURL:(NSString *)string;
@end
