//
//  NewMainViewController.m
//  duosq
//
//  Created by Juno on 14-10-21.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "NewMainViewController.h"



@interface NewMainViewController ()

@end

@implementation NewMainViewController

//请求时间
long long int requesttime = 0;

- (void)viewDidLoad {
    self.topbar.backgroundColor = kDefaultBackgroundColor;
    NSLog(@"statusBarHeight>>>>>>>>>>>>:%d",statusBarHeight);
    [self initBookingView];
    [self initDiscoveryView];
    [self initLikeView];
    [self initSettingView];
    [self loadBanner];
    
    self.searchBtn.hidden = YES;
    self.discoveryView.view.hidden = YES;
    self.likeView.view.hidden = YES;
    self.settingView.view.hidden = YES;
    self.BlackBgView.hidden = YES;
    self.bannerView.view.hidden = YES;
    self.settingBackBtn.hidden = YES;
    
    //初始化隐藏
    self.cancelButton.hidden = YES;
    self.searchTextField.hidden = YES;
    self.searchImage.hidden = YES;
    
    [self.view bringSubviewToFront:self.BlackBgView];
    [self.view bringSubviewToFront:self.settingView.view];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self.searchTextField setValue:kSearchPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    self.searchTextField.placeholder = @" ";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)initBookingView{
    self.bookingView = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    self.bookingView.urlStr = @"http://h5.duosq.com:8080/subscribe";
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    self.bookingView.view.frame = CGRectMake(0, kHeightOfNavBar, frame.size.width,frame.size.height-kHeightOfNavBar+(statusBarHeight));
    
    self.bookingView.maindelegate  =self;
    [self.view addSubview:self.bookingView.view];
}

- (void)initDiscoveryView{
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    self.discoveryView = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    self.discoveryView.rect = CGRectMake(0, 0, frame.size.width, frame.size.height-kHeightOfNavBar-kBannerHeight+(statusBarHeight));

    self.discoveryView.urlStr = @"http://h5.duosq.com:8080/promotion";
    self.discoveryView.view.frame = CGRectMake(0, kHeightOfNavBar+kBannerHeight, frame.size.width,frame.size.height-kHeightOfNavBar-kBannerHeight+(statusBarHeight));

    self.discoveryView.maindelegate = self;
    [self.view addSubview:self.discoveryView.view];
}

- (void)initLikeView{
    self.likeView = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    self.likeView.urlStr = @"http://h5.duosq.com:8080/subscribe/cang";
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    self.likeView.view.frame = CGRectMake(0, kHeightOfNavBar, frame.size.width,frame.size.height-kHeightOfNavBar+(statusBarHeight));
    self.likeView.maindelegate  =self;
    [self.view addSubview:self.likeView.view];
}

- (void)initSettingView{
    self.settingView = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    
    CGRect rect;
    rect=frame;
    rect.origin.y = 0;
    rect.size.width = kSettingWidth;
    rect.size.height = frame.size.height+(statusBarHeight);
    self.settingView.rect = rect;
    self.settingView.urlStr = @"http://h5.duosq.com:8080/subscribe/setting";
    
    rect.origin.x = -kSettingWidth;
    self.settingView.view.frame = rect;
    
    self.settingView.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.settingView.view.layer.shadowOffset = CGSizeMake(4, 0);
    self.settingView.view.layer.shadowOpacity = 1;
    self.settingView.view.layer.shadowRadius = 10.0;
    
    [self.view addSubview:self.settingView.view];
}

- (void)loadBanner
{
    self.bannerView = [[BannerViewController alloc]initWithNibName:nil bundle:nil];
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    if(IOS7){
        self.bannerView.view.frame = CGRectMake(0, kHeightOfNavBar, frame.size.width, kBannerHeight);
    }else{
        self.bannerView.view.frame = CGRectMake(0, kHeightOfNavBar-20, frame.size.width, kBannerHeight);
    }
    
    self.bannerView.maindelegate = self;
    [self.view addSubview:self.bannerView.view];
}

- (IBAction)bookAction:(id)sender {
    [self setButtonBackground:1];
}

- (IBAction)search:(id)sender {
    
}

- (IBAction)discoverAction:(id)sender {
    // 设置背景图片
    [self setButtonBackground:2];
}

- (IBAction)likeAction:(id)sender {
    // 设置背景图片
    [self setButtonBackground:3];
}

- (IBAction)setting:(id)sender {
    [self settingAction];
}


- (void)settingAction{
    self.settingView.view.hidden = NO;
    self.BlackBgView.hidden = NO;
    self.settingBackBtn.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect;
        rect=self.settingView.view.frame;
        rect.origin.x=0;
        self.settingView.view.frame = rect;
    }];
}



- (IBAction)settingback:(id)sender {
    self.settingBackBtn.hidden = YES;
    self.BlackBgView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect;
        rect=self.settingView.view.frame;
        rect.origin.x=-kSettingWidth;
        self.settingView.view.frame = rect;
        
    }completion:^(BOOL finished) {
        self.settingView.view.hidden = YES;
    }];
    [self.bookingView reload];
}

- (IBAction)refresh:(id)sender {
    [self.bookingView reload];
    [self startAnimations];
}

-(void) startAnimations{
}

// 设置背景图片
- (void)setButtonBackground:(int)type{
    UIImage *buttonimg;
    switch (type) {
        case 1:
            buttonimg = [UIImage imageNamed:@"booking_heightlight"];
            [self.bookBtn setBackgroundImage:buttonimg forState:UIControlStateNormal];
            buttonimg = [UIImage imageNamed:@"discovery_normal"];
            [self.discoverBtn setBackgroundImage:buttonimg forState:UIControlStateNormal];
            buttonimg = [UIImage imageNamed:@"like_normal"];
            [self.likeBtn setBackgroundImage:buttonimg forState:UIControlStateNormal];
            self.bookingView.view.hidden=NO;
            self.discoveryView.view.hidden=YES;
            self.likeView.view.hidden = YES;
            self.bannerView.view.hidden = YES;
            self.searchTextField.hidden = YES;
            self.searchBtn.hidden = YES;
            self.settingBtn.hidden = NO;
            self.refreshBtn.hidden = NO;
            self.refreshbtnUI.hidden = NO;
            self.settingBtnUI.hidden = NO;
            break;
        case 2:
            buttonimg = [UIImage imageNamed:@"discovery_heightlight"];
            [self.discoverBtn setBackgroundImage:buttonimg forState:UIControlStateNormal];
            buttonimg = [UIImage imageNamed:@"booking_normal"];
            [self.bookBtn setBackgroundImage:buttonimg forState:UIControlStateNormal];
            buttonimg = [UIImage imageNamed:@"like_normal"];
            [self.likeBtn setBackgroundImage:buttonimg forState:UIControlStateNormal];
            self.bookingView.view.hidden=YES;
            self.discoveryView.view.hidden=NO;
            self.bannerView.view.hidden = NO;
            self.searchTextField.hidden = NO;
            self.likeView.view.hidden = YES;
            self.searchBtn.hidden = NO;
            self.settingBtn.hidden = YES;
            self.refreshBtn.hidden = YES;
            self.refreshbtnUI.hidden = YES;
            self.settingBtnUI.hidden = YES;
            break;
        case 3:
            buttonimg = [UIImage imageNamed:@"like_heightlight"];
            [self.likeBtn setBackgroundImage:buttonimg forState:UIControlStateNormal];
            buttonimg = [UIImage imageNamed:@"booking_normal"];
            [self.bookBtn setBackgroundImage:buttonimg forState:UIControlStateNormal];
            buttonimg = [UIImage imageNamed:@"discovery_normal"];
            [self.discoverBtn setBackgroundImage:buttonimg forState:UIControlStateNormal];
            self.bookingView.view.hidden=YES;
            self.discoveryView.view.hidden=YES;
            self.likeView.view.hidden = NO;
            self.bannerView.view.hidden = YES;
            self.searchTextField.hidden = YES;
            self.searchBtn.hidden = YES;
            self.settingBtn.hidden = YES;
            self.refreshBtn.hidden = YES;
            self.refreshbtnUI.hidden = YES;
            self.settingBtnUI.hidden = YES;
            break;
        default:
            break;
    }
}

//old code

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1){
        return NO;
    }else{
        return YES;
    }
}

//dalegate functions
-(void)openWebContentView:(NSString *)url isHistory:(int)isHistory noparam:(int)noparam
{
    NSLog(@"NewMainViewController:%@",url);
    ProductWebViewController  *webContentView = [[ProductWebViewController alloc] initWithNibName:@"ProductWebViewController" bundle:nil];
    webContentView.urlStr = url;
    webContentView.noParam = noparam;
    webContentView.isHistory = isHistory;
    webContentView.maindelegate = self;
    
    [super.navigationController pushViewController:webContentView animated:YES];
}


//search相关

- (void)loadKeywordTableView
{
    if (nil == self.keywordTableView || nil == self.keywordTableView.superview)
    {
        self.keywordTableView = [[KeyWordView alloc] initWithNib];
        self.keywordTableView.maindelegate = self;
        self.keywordTableView.frame=CGRectMake(0, kHeightOfNavBar, 320, kSearchKeyTabHeight);
        [self.view addSubview:self.keywordTableView];
        self.keywordTableView.hidden=YES;
        
    }
}

- (IBAction)searchBegin:(id)sender {
    [self loadKeywordTableView];
    
    self.keywordTableView.hidden = NO;
    self.searchImage.image = [UIImage imageNamed:@"search_bar_new.png"];
    self.searchImage.hidden = NO;
    self.cancelButton.hidden = NO;
    self.searchTextField.hidden = NO;
    
    CGRect rect=self.searchTextField.frame;
    rect.origin.x=40;
    rect.size.width=230;
    self.searchTextField.frame=rect;
    
    [self.searchTextField setValue:kSearchPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    self.searchTextField.placeholder = @" 请输入商品名称，找找哪里有特卖";
    
    //防止打开search页面crash
    [self.discoveryView closeLoading];
}

- (IBAction)searchEnd:(id)sender {
    
}

- (IBAction)searchChange:(id)sender {
    //两次输入间隔超过300毫秒才去请求
    if([[self getLocalTime] longLongValue] - requesttime >300){
        requesttime = [[self getLocalTime] longLongValue];
        [self.keywordTableView reloadData:self.searchTextField.text];
    }else{
        [self.keywordTableView clearTableView];
    }
}

- (IBAction)cancelSearch:(id)sender {
    [self searchBarReturn];
}

-(void)changeSearchValue:(NSString *)searchWord{
    NSLog(@"changeSearchValue searchword:%@",searchWord);
    //    self.searchTextField.text = searchWord;
    [self.searchTextField resignFirstResponder];
    NSString *searchword = searchWord;
    NSString *push_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            push_token,@"push_token",
                            nil];
    NSString *keywordencode  = [searchword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@?k=%@&%@",kSearchKeywordUrl,keywordencode,[UntilFunctions encodeURL:[UntilFunctions getUrl:params]]];
    
    NSLog(@"url:%@",url);
    [self searchBarReturn];
    [self openWebContentView:url isHistory:0 noparam:1];
}

- (IBAction)searchExit:(id)sender {
    [self.searchTextField resignFirstResponder];
    NSString *searchword = self.searchTextField.text;
    NSString *keywordencode  = [searchword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *push_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            push_token,@"push_token",
                            nil];
    NSString *url = [NSString stringWithFormat:@"%@?k=%@&%@",kSearchKeywordUrl,keywordencode,[UntilFunctions encodeURL:[UntilFunctions getUrl:params]]];
    NSLog(@"url:%@",url);
    [self searchBarReturn];
    [self openWebContentView:url isHistory:0 noparam:1];
}

- (void)searchBarReturn{
    [self.searchTextField resignFirstResponder];
    [self.keywordTableView reloadData:@""];
    self.searchTextField.placeholder = @"";
    self.searchTextField.text = @"";
    
    self.keywordTableView.hidden=YES;
    self.cancelButton.hidden = YES;
    self.searchImage.hidden = YES;
    
    CGRect rect=self.searchTextField.frame;
    rect.origin.x=280;
    rect.size.width=33;
    self.searchTextField.frame=rect;
}

- (NSString *)getLocalTime{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    //NSLog(@"timeString:%@",timeString);
    return timeString;
}

- (void)gotoPage:(int)p{
    [self setButtonBackground:p];
}

@end
