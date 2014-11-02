//
//  NewMainViewController.h
//  duosq
//
//  Created by Juno on 14-10-21.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "UIViewPassValueDelegate.h"
#import "KeyWordView.h"
#import "ProductWebViewController.h"
#import "BannerViewController.h"
#import "KeyWordView.h"
#import "DataHandle.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface NewMainViewController : UIViewController<UIViewPassValueDelegate,UIGestureRecognizerDelegate>{
    id<UIViewPassValueDelegate> maindelegate;
    KeyWordView *keywordTableView;
}

@property (strong, nonatomic) IBOutlet UIView *topbar;
@property (strong, nonatomic) IBOutlet UIButton *bookBtn;
@property (strong, nonatomic) IBOutlet UIButton *discoverBtn;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIButton *refreshBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingBtn;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UIView *BlackBgView;
@property (strong, nonatomic) IBOutlet UIButton *settingBackBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIImageView *settingBtnUI;
@property (strong, nonatomic) IBOutlet UIImageView *refreshbtnUI;


@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIImageView *searchImage;

@property(nonatomic,strong) WebViewController *discoveryView;
@property(nonatomic,strong) WebViewController *bookingView;
@property(nonatomic,strong) WebViewController *likeView;
@property(nonatomic,strong) WebViewController *settingView;
@property(nonatomic,strong) BannerViewController *bannerView;
@property(nonatomic,strong) KeyWordView *keywordTableView;

- (IBAction)settingback:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)bookAction:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)discoverAction:(id)sender;
- (IBAction)likeAction:(id)sender;
- (IBAction)setting:(id)sender;

- (IBAction)searchExit:(id)sender;
- (IBAction)searchBegin:(id)sender;
- (IBAction)searchEnd:(id)sender;
- (IBAction)searchChange:(id)sender;
- (IBAction)cancelSearch:(id)sender;

//dalegate functions
-(void)openWebContentView:(NSString *)url isHistory:(int)isHistory noparam:(int)noparam;
-(void)changeSearchValue:(NSString *)searchWord;
@end
