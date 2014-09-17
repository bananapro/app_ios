//
//  MainViewController.m
//  duosq
//
//  Created by juno on 14-6-30.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "ProductWebViewController.h"
#import "MainViewController.h"
#import "MYCustomPanel.h"
#import "MYCustonPanel_ip4.h"
#import "UntilFunctions.h"

#define kSearchKeywordUrl @"http://h5.duosq.com:8080/promotion/search"

#define kPeddingValue 4
#define kBannerTag 101

#define kBannerHeight 82
#define kBannerHeightiphone4 0
#define kHeightOfNavBar	60
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO
#define kSearchKeyTabHeight iPhone5?330:200
#define statusBarHeight (IOS7?0:20)

#define kGeryBackgroundColor [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1]
#define kDefaultBackgroundColor [UIColor colorWithRed:206/255.0 green:31/255.0 blue:118/255.0 alpha:1]
#define kSearchBackgroundColor [UIColor colorWithRed:159/255.0 green:14/255.0 blue:88/255.0 alpha:1]
#define kSmallUIBackgroundColor [UIColor colorWithRed:155/255.0 green:20/255.0 blue:88/255.0 alpha:1]
#define kSearchPlaceholderColor [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1]
@interface MainViewController ()

@end

@implementation MainViewController

//请求时间
long long int requesttime = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"isIOS7:%d",statusBarHeight);
        NSLog(@"[[UIScreen mainScreen] currentMode].size.height>>>>>%f",[[UIScreen mainScreen] currentMode].size.height);
        self.view.hidden = YES;
        self.view.backgroundColor = kGeryBackgroundColor;
        self.smallUI.backgroundColor = kSmallUIBackgroundColor;
        if(iPhone5){
            [self loadBanner];
        }
        
        [self loadMainView];
        // Custom initialization
    }
    return self;
}

- (void)loadBanner
{
    BannerViewController *myController = [[BannerViewController alloc]initWithNibName:nil bundle:nil];
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    //    myController.view.frame = CGRectMake(kPeddingValue, kHeightOfNavBar+kPeddingValue, frame.size.width, kBannerHeight);
    myController.view.frame = CGRectMake(kPeddingValue, 0, frame.size.width, kBannerHeight);
    myController.view.tag = kBannerTag;
    myController.maindelegate = self;
    
    [self.mainScroll addSubview:myController.view];
}

- (void)loadMainView
{
	if (nil == self.metroVC) {
		self.metroVC = [[MetroViewController alloc] initWithNibName:nil bundle:nil];
        self.metroVC.maindelegate = self;
		CGRect frame = [UIScreen mainScreen].applicationFrame;
        
        if(iPhone5){
            //            frame.origin.y = kHeightOfNavBar+kBannerHeight;
            frame.origin.y = kBannerHeight-4;
            frame.size.height = 446;
        }else{
            //            frame.origin.y = kHeightOfNavBar+kBannerHeightiphone4;
            frame.origin.y = kBannerHeightiphone4-4;
            frame.size.height = 446;
        }
        
        NSLog(@"frame:%@",NSStringFromCGRect(frame));
		self.metroVC.frame = frame;
        
		[self.mainScroll addSubview:self.metroVC.view];
	}
	else if (nil == self.metroVC.view.superview) {
		[self.mainScroll addSubview:self.metroVC.view];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    self.navBg.backgroundColor = kDefaultBackgroundColor;
    self.cancelButton.hidden = YES;
    self.smallUI.hidden = YES;
    [self.searchTextField setValue:kSearchPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    self.searchTextField.placeholder = @" ";
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.mainScroll.delegate = self;
    self.mainScroll.contentSize = CGSizeMake(frame.size.width, frame.size.height-40);
}

- (void)viewDidAppear:(BOOL)animated{
    self.view.hidden = NO;
    //读取沙盒数据
    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat:@"is_first"];
    NSString *value = [settings1 objectForKey:key1];
    if (!value)  //如果没有数据
    {
        NSString *iphone_name = [[NSString alloc] init];
        NSString *xib_name = [[NSString alloc] init];
        if (iPhone5) {
            iphone_name = [NSString stringWithFormat:@"iphone5"];
            xib_name = @"MYCustomPanel";
            
        }else{
            iphone_name = [NSString stringWithFormat:@"iphone4"];
            xib_name = @"MYCustomPanel_ip4";
        }
    
        //start guide
        
        MYCustomPanel *panel1 = [[MYCustomPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:xib_name];
        panel1.passBtn.hidden = YES;
        panel1.ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_guide1.png",iphone_name]];
        
        MYCustomPanel *panel2 = [[MYCustomPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:xib_name];
        panel2.passBtn.hidden = YES;
        panel2.ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_guide2.png",iphone_name]];
        
        MYCustomPanel *panel3 = [[MYCustomPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:xib_name];
        
        MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        introductionView.delegate = self;
        
        NSArray *panels = @[panel1,panel2,panel3];
        
        [introductionView buildIntroductionWithPanels:panels];
        
        //Add the introduction to your view
        [self.view addSubview:introductionView];
        
        //写入数据
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString * key = [NSString stringWithFormat:@"is_first"];
        [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
        [setting synchronize];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1){
        return NO;
    }else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadKeywordTableView
{
    if (nil == self.keywordTableView || nil == self.keywordTableView.superview)
	{
        
        self.keywordTableView = [[KeyWordView alloc] initWithNib];
        self.keywordTableView.maindelegate = self;
        self.keywordTableView.frame=CGRectMake(0, kHeightOfNavBar+2-statusBarHeight, 320, kSearchKeyTabHeight);
        [self.view addSubview:self.keywordTableView];
        self.keywordTableView.hidden=YES;
        
    }
}

- (IBAction)searchBegin:(id)sender {
    self.searchImage.image = [UIImage imageNamed:@"search_bar_new.png"];
    [self loadKeywordTableView];
    self.keywordTableView.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.cancelButton.hidden = NO;
        CGRect rect;
        
        rect=self.searchTextField.frame;
        rect.origin.x=10;
        rect.origin.y=20-statusBarHeight;
        rect.size.width=260;
        rect.size.height=37;
        self.searchImage.frame=rect;
        
        rect=self.searchTextField.frame;
        rect.origin.x=40;
        rect.size.width=230;
        self.searchTextField.frame=rect;
        [self.searchTextField setValue:kSearchPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
        self.searchTextField.placeholder = @" 请输入商品名称，找找哪里有特卖";
//        self.searchTextField.tintColor = [UIColor whiteColor];
        
    }completion:^(BOOL finished){
        //tourPreferenceView.alpha = 0;
    }];
    //
	[self.metroVC viewWillDisappear:NO];
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


//dalegate functions
-(void)openWebContentView:(NSString *)url
{
    ProductWebViewController  *webContentView = [[ProductWebViewController alloc] initWithNibName:@"ProductWebViewController" bundle:nil];
    webContentView.urlStr = url;
    
    [super.navigationController pushViewController:webContentView animated:YES];
}

//dalegate functions
-(void)openWebContentViewNoparam:(NSString *)url
{
    ProductWebViewController  *webContentView = [[ProductWebViewController alloc] initWithNibName:@"ProductWebViewController" bundle:nil];
    webContentView.urlStr = url;
    webContentView.noParam = 1;
    
    [super.navigationController pushViewController:webContentView animated:YES];
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
    [self openWebContentViewNoparam:url];
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
    [self openWebContentViewNoparam:url];
}

- (void)searchBarReturn{
    self.searchImage.image = [UIImage imageNamed:@"main_nav.png"];
    [self.searchTextField resignFirstResponder];
    [self.keywordTableView reloadData:@""];
    self.keywordTableView.hidden=YES;
    self.cancelButton.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect;
        
        rect=self.searchImage.frame;
        rect.origin.x=0;
        rect.origin.y=21-statusBarHeight;
        
        rect.size.width=320;
        rect.size.height=40;
        self.searchImage.frame=rect;
        
        rect=self.searchTextField.frame;
        rect.origin.x=110;
        rect.size.width=199;
        self.searchTextField.frame=rect;
        self.searchTextField.placeholder = @"";
        self.searchTextField.text = @"";
    }completion:^(BOOL finished){
        if (finished) {
            [self.searchTextField resignFirstResponder];
        }
    }];
}

- (NSString *)getLocalTime{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    //NSLog(@"timeString:%@",timeString);
    return timeString;
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	NSLog(@"scrollViewDidEndDragging");
    //    scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
@end
