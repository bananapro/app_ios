//
//  MetroInfoService.m
//  duosq
//
//  Created by juno on 14-7-1.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "MetroInfoService.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "DataHandle.h"
#import "UntilFunctions.h"


@implementation MetroInfoService

//获取首页信息
- (void)getMetroInfo:(void (^)(int status,id JSON))success
               failure:(void (^)(NSError *error))failure{
    [self jsonParse];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSString *timeString = [self getLocalTime];
    NSLog(@"timeString:%@",timeString);
//    NSString *urlStr = [NSString stringWithFormat:@"http://test.duosq.com/entry.txt"];
    NSString *urlStr = [NSString stringWithFormat:@"http://static.duosq.com/appconfig/entryinfo.conf?%@",timeString];
    NSLog(@"url:%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"getMetroInfo success!");
        int status = [[JSON objectForKey:@"status"]intValue];
        if (!status) {
            NSLog(@"getMetroInfo false!");
        }else{
//            NSLog(@"%@",JSON);
            success(status,[JSON objectForKey:@"data"]);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"getMetroInfo false!");
        NSLog(@"%@",error);
        failure(error);
    }];
    [operation start];
}

//获取首页banner信息
- (void)getBannerInfo:(void (^)(int status,id JSON))success
             failure:(void (^)(NSError *error))failure{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    NSString *timeString = [self getLocalTime];
    NSString *urlStr = [NSString stringWithFormat:@"http://static.duosq.com/appconfig/banner.conf?%@",timeString];
    NSLog(@"url:%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"load banner success!");
        int status = [[JSON objectForKey:@"status"]intValue];
        if (!status) {
            
        }
        success(status,[JSON objectForKey:@"data"]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"false!");
        NSLog(@"%@",error);
        failure(error);
    }];
    [operation start];
}

//获取首页消息信息
- (void)getMessages:(void (^)(int status,id JSON))success
              failure:(void (^)(NSError *error))failure{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSString *timeString = [self getLocalTime];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            timeString,@"time",
                            nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.duosq.com:8080/mobi/notifyNum?%@",[UntilFunctions encodeURL:[UntilFunctions getUrl:params]]];
    //NSString *urlStr = [NSString stringWithFormat:@"http://10.50.180.233/duosq/index.php"];

    NSLog(@"url:%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"getMessages success!");
        int status = [[JSON objectForKey:@"status"]intValue];
        if (!status) {
            NSLog(@"getMessages false!");
            NSLog(@"%@",JSON);
        }else{
            success(status,[JSON objectForKey:@"message"]);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"getMessages false!");
        NSLog(@"%@",error);
        failure(error);
    }];
    [operation start];
}

- (NSString *)getLocalTime{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

- (NSDictionary *)jsonParse{
    //初始化文件路径。
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"entryinfo" ofType:@"conf"];
    //将文件内容读取到字符串中，注意编码NSUTF8StringEncoding 防止乱码，
    NSString* jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //将字符串写到缓冲区。
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //解析json数据，使用系统方法 JSONObjectWithData:  options: error:
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    //接下来一步一步解析。知道得到你想要的东西。
//    NSLog(@"dic:%@",dic);
    return dic;
}
@end
