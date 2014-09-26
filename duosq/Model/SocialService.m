//
//  SocialService.m
//  duosq
//
//  Created by juno on 14-9-25.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "SocialService.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "DataHandle.h"
#import "UntilFunctions.h"

@implementation SocialService

//获取首页消息信息
- (void)setShareMessages:(NSString *)shareurl success:(void (^)(int status,id JSON))success
            failure:(void (^)(NSError *error))failure{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",shareurl,[UntilFunctions encodeURL:[UntilFunctions getUrl:params]]];
    
    NSLog(@"url:%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        int status = [[JSON objectForKey:@"status"]intValue];
        if (!status) {
            NSLog(@"callback false!");
        }else{
            NSLog(@"callback success!");

        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"callback false!");
        NSLog(@"%@",error);
    }];
    [operation start];
}
@end
