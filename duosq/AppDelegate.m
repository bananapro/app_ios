//
//  AppDelegate.m
//  duosq
//
//  Created by juno on 14-6-30.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "AppDelegate.h"

#import "BaseViewController.h"
#import "MLNavigationController.h"
#import "UntilFunctions.h"
#import "SSKeychain.h"
#import <SenTestingKit/SenTestingKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:2.0];
    [MobClick startWithAppkey:@"53e23d15fd98c539f6008f10" reportPolicy:BATCH   channelId:@"web"];
    NSLog(@"generateUUID:%@",[self checkuuid]);
    
    //测试代码开始
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    
//    [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:@"umid"];
//    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    //测试代码结束
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.mainViewcontr = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    MLNavigationController *navmainViewcontr = [[MLNavigationController alloc]initWithRootViewController:self.mainViewcontr];

    navmainViewcontr.navigationBarHidden = YES;
    
     self.window.rootViewController = navmainViewcontr;
//    [self.window addSubview:navmainViewcontr.view];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    Byte *bytes = (Byte *)[deviceToken bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[deviceToken length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    [[NSUserDefaults standardUserDefaults] setObject:hexStr forKey:@"push_token"];
    NSLog(@"My token is:%@", hexStr);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo

{
    NSLog(@"\napns -> didReceiveRemoteNotification,Receive Data:\n%@", userInfo);
    //把icon上的标记数字设置为0,
    application.applicationIconBadgeNumber = 0;
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"url"]!=nil) {
        [self.mainViewcontr openWebContentView:[[userInfo objectForKey:@"aps"] objectForKey:@"url"]];
    }
}

- (NSString *)checkuuid{
    
    NSString *uuid = [SSKeychain passwordForService:@"com.app.duosq" account:@"uuid"];
    if (uuid) {
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"device_id"];
        return uuid;
    }else{
        uuid = [UntilFunctions generateUUID];
        [SSKeychain setPassword:uuid forService:@"com.app.duosq" account:@"uuid"];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"device_id"];
        return uuid;
    }
}

@end