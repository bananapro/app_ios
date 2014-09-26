//
//  SocialService.h
//  duosq
//
//  Created by juno on 14-9-25.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialService : NSObject
- (void)setShareMessages:(NSString *)shareurl success:(void (^)(int status,id JSON))success
                 failure:(void (^)(NSError *error))failure;
@end
