//
//  ProductWebViewController.m
//  duosq
//
//  Created by juno on 14-7-14.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "ProductWebViewController.h"
#import "RegexKitLite.h"
#import "UntilFunctions.h"

#import "UMFeedbackViewController.h"
#import "UMFeedback.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

#import "SocialService.h"

#define kDefaultBackgroundColor [UIColor colorWithRed:206/255.0 green:31/255.0 blue:118/255.0 alpha:1]
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO
#define kSearchKeyTabHeight iPhone5?330:200
#define statusBarHeight (IOS7?0:20)

@interface ProductWebViewController ()

@end

@implementation ProductWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!iPhone5) {
        CGRect rect;
        rect= self.productWebView.frame;
        rect.size.height = rect.size.height-(88+statusBarHeight);
        self.productWebView.frame=rect;
    }
    
    //跳转事件统计开始
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [mutableDictionary setObject:self.urlStr forKey:@"__ct__"];
    [MobClick event:@"jump" attributes:mutableDictionary];
    //跳转事件统计结束
    
    self.needSetting.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = kDefaultBackgroundColor;
    self.navbarView.backgroundColor = kDefaultBackgroundColor;
   
    NSString *urlRequest;
    if (self.noParam) {
        urlRequest = [NSString stringWithFormat:@"%@",self.urlStr];
        NSLog(@"productWebView URL:%@",urlRequest);
    }else{
        NSString *push_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                push_token,@"push_token",
                                nil];
        
        urlRequest = [NSString stringWithFormat:@"%@?%@",self.urlStr,[UntilFunctions encodeURL:[UntilFunctions getUrl:params]]];
        NSLog(@"productWebView URL:%@",urlRequest);
    }
    NSURL *url =[NSURL URLWithString:urlRequest];
//    NSURL *url = [NSURL URLWithString:@"http://zeng.duosq.com/test_history.php"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.productWebView loadRequest:request];
    self.productWebView.delegate = self;
    
    self.isComeback = 0;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSRange range = [self.urlStr rangeOfString:@"duosq"];
    if (range.location != NSNotFound) {
        [self showLoading];
    }
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [HUD hide:YES];
    self.webviwTitle.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    NSString *value = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('setting_title').value"];
    if (value.length>0) {
        self.needSetting.hidden = NO;
        [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.needSetting setTitle:value forState:UIControlStateNormal];
        self.settingUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('setting_url').value"];
    }

    NSLog(@"value:%@",value);
    
    if (0 == self.isComeback) {
        self.sharetitle  = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('sharetitle').value"];
        self.sharesubtitle = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('sharesubtitle').value"];
        self.shareurl = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('shareurl').value"];
        self.shareimg = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('shareimg').value"];
        self.callbackurl = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('callback').value"];
    }else{
        [webView stringByEvaluatingJavaScriptFromString:self.callbackurl];
        self.isComeback = 0;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        NSString *str=[url absoluteString];
        NSLog(@"str:%@",str);
        if([str isMatchedByRegex:@"\\jump:\\w+"]){
            NSArray *results = [str componentsSeparatedByRegex:@"\\:"];
            NSLog(@"results:%@",results);
            if ([results[1] isEqualToString:@"feedback"]) {
                [self openfeedback];
            }else if ([results[1] isEqualToString:@"sharesocial"]) {
                [self shareSocial];
            }else if ([results[1] isEqualToString:@"history"]){
                NSArray *urlArr = [str componentsSeparatedByRegex:@"\\jump:history:"];
                NSLog(@"urlArr:%@",urlArr);
                [self openWebContentView:urlArr[1] isHistory:1 noparam:0];
            }else if ([results[1] isEqualToString:@"back"]){
                [self backAction];
            }else if ([results[1] isEqualToString:@"setting"]){
                [self.maindelegate settingAction];
            }else{
                NSArray *urlArr = [str componentsSeparatedByRegex:@"\\jump:"];
                NSLog(@"urlArr:%@",urlArr);
                [self openWebContentView:urlArr[1] isHistory:0 noparam:1];
            }
            return NO;
        }
    }
    return YES;
}

-(void)openfeedback{
    [UMFeedback showFeedback:self withAppkey:@"53e23d15fd98c539f6008f10"];
}

//dalegate functions
-(void)openWebContentView:(NSString *)url isHistory:(int)isHistory noparam:(int)noparam
{
    ProductWebViewController  *webContentView = [[ProductWebViewController alloc] initWithNibName:@"ProductWebViewController" bundle:nil];
    webContentView.urlStr = url;
    webContentView.noParam = noparam;
    webContentView.isHistory= isHistory;
    
    [super.navigationController pushViewController:webContentView animated:YES];
}

- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error{
    NSLog(@"webView error:%@",error);
}

- (IBAction)back:(id)sender {
    NSLog(@"webview back");
    [self backAction];
}

-(void)backAction{
    if (self.isHistory == 1 && self.productWebView.canGoBack) {
        [self.productWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)settingBtn:(id)sender {
    if(self.settingUrl.length>0){
        [self openWebContentView:self.settingUrl isHistory:0 noparam:0];
    }
}


-(void)showLoading{
    HUD = [[MBProgressHUD alloc] initWithView:self.productWebView.viewForBaselineLayout];
	[self.productWebView.viewForBaselineLayout addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"加载中";
	
    [HUD show:YES];
    //设置定时器关闭loading
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:3
//                                                  target:self
//                                                selector:@selector(closeLoading)
//                                                userInfo:nil
//                                                 repeats:NO];
}

-(void)closeLoading{
    NSLog(@"closeLoading");
    [HUD hide:YES];
    [self.timer invalidate];
    self.timer = nil;
}

-(void)shareSocial{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.shareimg]];
    UIImage *shareimage = [UIImage imageWithData:imageData];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"53e23d15fd98c539f6008f10"
                                      shareText:self.sharesubtitle
                                     shareImage:shareimage
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                       delegate:self];
    [UMSocialData defaultData].extConfig.title = self.sharetitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareurl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareurl;
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        self.isComeback = 1;
        [self reload];
    }
}

-(void)reload{
    [self.productWebView reload];
}
@end
