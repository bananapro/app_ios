//
//  WebViewController.h
//  duosq
//
//  Created by Juno on 14-10-23.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "RegexKitLite.h"
#import "UntilFunctions.h"

#import "UMFeedbackViewController.h"
#import "UMFeedback.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

#import "SocialService.h"
#import "UIViewPassValueDelegate.h"
//#import "UIViewPassValueDelegate.h"


@interface WebViewController : UIViewController<UIWebViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic)NSString *sharetitle;
@property (strong, nonatomic)NSString *sharesubtitle;
@property (strong, nonatomic)NSString *shareurl;
@property (strong, nonatomic)NSString *shareimg;
@property (strong, nonatomic)NSString *callbackurl;
@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) CGRect rect;

@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) NSString *urlStr;
@property (assign) int webViewHeight;
@property (assign) int isComeback;
@property(nonatomic,strong)id<UIViewPassValueDelegate> maindelegate;
-(void)reload;
-(void)closeLoading;

@end
