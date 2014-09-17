//
//  SearchInfoService.h
//  duosq
//
//  Created by juno on 14-7-13.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchInfoService : NSObject
- (void)getSearchListByKeyword:(NSString *)keyword success:(void (^)(int status,id JSON))success failure:(void (^)(NSError *error))failure;
@end
