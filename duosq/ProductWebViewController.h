//
//  ProductWebViewController.h
//  duosq
//
//  Created by juno on 14-7-14.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIViewPassValueDelegate.h"

@interface ProductWebViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    UIView *navbarView;
}
@property (strong, nonatomic) IBOutlet UIButton *needSetting;
@property (strong, nonatomic) IBOutlet UIView *navbarView;
@property (strong, nonatomic) IBOutlet UIWebView *productWebView;
@property (strong, nonatomic) NSString *urlStr;
@property (assign) int noParam;
@property (assign) int isHistory;
@property (strong, nonatomic) NSString *settingUrl;
- (IBAction)settingBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *webviwTitle;
- (IBAction)back:(id)sender;

@property (strong, nonatomic)NSString *sharetitle;
@property (strong, nonatomic)NSString *sharesubtitle;
@property (strong, nonatomic)NSString *shareurl;
@property (strong, nonatomic)NSString *shareimg;
@property (strong, nonatomic)NSString *callbackurl;

@property (strong, nonatomic) NSTimer *timer;

@property (assign) int isComeback;

@property(nonatomic,strong) id<UIViewPassValueDelegate> maindelegate;

@end
