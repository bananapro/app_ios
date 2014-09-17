//
//  UntilFunctions.m
//  duosq
//
//  Created by juno on 14-8-4.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "UntilFunctions.h"
#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/types.h>
#include <sys/sysctl.h>

#define _SERVICE_UKEY @"34957554883"

@implementation UntilFunctions

// Decode a percent escape encoded string.

+ (NSString*)encodeURL:(NSString *)string
{
	NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)string,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}

+(NSString*)getStringMD5:(NSString*)str
{
	const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *md5Str= [NSString stringWithFormat:
					   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
					   result[0], result[1], result[2], result[3],
					   result[4], result[5], result[6], result[7],
					   result[8], result[9], result[10], result[11],
					   result[12], result[13], result[14], result[15]
					   ];
    return [md5Str lowercaseString];
}

+ (NSString*)generateUUID
{
	CFUUIDRef uuid = CFUUIDCreate(nil);
    CFUUIDCreateString(nil, uuid);
	NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
	CFRelease(uuid);
	return uuidString;
}

// 是否wifi
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
// 是否3G
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

+ (BOOL)isNetworkReachableViaWIFI
{
	return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi);
}

+ (NSString *)platform{
    
    size_t size;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *machine = malloc(size);
    
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    free(machine);
    
    return platform;
    
}

+ (NSString *)getSn:(NSDictionary *)params{
    NSMutableString *value = [NSMutableString stringWithFormat:_SERVICE_UKEY];
    NSArray *keys = [params allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
//        NSLog(@"[dict objectForKey:categoryId] %@ === %@",categoryId,[params objectForKey:categoryId]);
        value = [NSMutableString stringWithFormat:@"%@%@%@",value,categoryId,[params objectForKey:categoryId]];
    }
    
    NSString *sn = [self getStringMD5:value];
//    NSLog(@"value:%@",value);
//    NSLog(@"sn:%@",sn);
    value = nil;
    return sn;
}

+ (NSString *)getUrl:(NSDictionary *)new_params{
    NSString *device_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_id"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"1.0",@"app_ver",
                                   @"v1",@"ver",
                                   @"ios",@"platform",
                                   device_id,@"device_id",
                                   [NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion],@"os",
                                   [UntilFunctions platform],@"device",
                                   [UIDevice currentDevice].model,@"device_type",
                                   [[NSUserDefaults standardUserDefaults] objectForKey:@"umid"],@"umkey",
                                   nil];
    [params addEntriesFromDictionary: new_params];
    NSString *sn = [self getSn:params];
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"sn=%@",sn];
    for(NSString *key in params){
        url = [NSMutableString stringWithFormat:@"%@&%@=%@",url,key,[params objectForKey:key]];
    }
//    NSLog(@"getUrl:%@",url);
    return url;
}
@end
