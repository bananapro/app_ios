//
//  ProductWebViewController.h
//  duosq
//
//  Created by juno on 14-7-14.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ProductWebViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    UIView *navbarView;
}
@property (strong, nonatomic) IBOutlet UIButton *needSetting;
@property (strong, nonatomic) IBOutlet UIView *navbarView;
@property (strong, nonatomic) IBOutlet UIWebView *productWebView;
@property (strong, nonatomic) NSString *urlStr;
@property (assign) int noParam;
@property (strong, nonatomic) NSString *settingUrl;
- (IBAction)settingBtn:(id)sender;
- (IBAction)test:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *webviwTitle;
- (IBAction)back:(id)sender;

@end
