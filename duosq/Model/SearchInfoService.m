//
//  SearchInfoService.m
//  duosq
//
//  Created by juno on 14-7-13.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "SearchInfoService.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "DataHandle.h"
#import "UntilFunctions.h"

@implementation SearchInfoService

- (void)getSearchListByKeyword:(NSString *)keyword success:(void (^)(int status,id JSON))success
                       failure:(void (^)(NSError *error))failure{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSString *push_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
//    NSString *keywordencode  = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            keyword,@"k",
                            push_token,@"push_token",
                            nil];

    NSString *urlStr = [NSString stringWithFormat:@"http://api.duosq.com:8080/mobi/suggest?%@",[UntilFunctions encodeURL:[UntilFunctions getUrl:params]]];
    
    NSLog(@"url:%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"success!");
        int status = [[JSON objectForKey:@"status"]intValue];
        if (status) {
            success(status,[JSON objectForKey:@"message"]);
        }else{
            failure([JSON objectForKey:@"message"]);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"false!");
        NSLog(@"%@",error);
        failure(error);
    }];
    [operation start];
}
@end
