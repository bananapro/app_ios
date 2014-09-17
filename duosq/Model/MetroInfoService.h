//
//  MetroInfoService.h
//  duosq
//
//  Created by juno on 14-7-1.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetroInfoService : NSObject

- (void)getMetroInfo:(void (^)(int status,id JSON))success failure:(void (^)(NSError *error))failure;
- (void)getBannerInfo:(void (^)(int status,id JSON))success failure:(void (^)(NSError *error))failur;
- (void)getMessages:(void (^)(int status,id JSON))success failure:(void (^)(NSError *error))failure;
- (NSDictionary *)jsonParse;
@end
