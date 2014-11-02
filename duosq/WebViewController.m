//
//  WebViewController.m
//  duosq
//
//  Created by Juno on 14-10-23.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webview.scalesPageToFit=YES;
    self.isComeback = 0;
    [self initUrl];
}

- (void)initUrl{
    NSString *urlRequest;
    NSString *push_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            push_token,@"push_token",
                            nil];
    
    urlRequest = [NSString stringWithFormat:@"%@?%@",self.urlStr,[UntilFunctions encodeURL:[UntilFunctions getUrl:params]]];
    NSLog(@"WebView URL:%@",urlRequest);
    NSURL *url =[NSURL URLWithString:urlRequest];
//    NSURL *url = [NSURL URLWithString:@"http://zeng.duosq.com/test_history.php"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    if (self.rect.size.height == 0) {
        self.webview=[[UIWebView alloc]initWithFrame:self.view.frame];
    }else{
        self.webview=[[UIWebView alloc]initWithFrame:self.rect];
    }
    
//    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
    [self.webview loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSRange range = [self.urlStr rangeOfString:@"duosq"];
    if (range.location != NSNotFound) {
        [self showLoading];
    }
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [HUD hide:YES];
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
                [self.maindelegate openWebContentView:urlArr[1] isHistory:1 noparam:0];
            }else if ([results[1] isEqualToString:@"setting"]){
                [self.maindelegate settingAction];
            }else if ([results[1] isEqualToString:@"back"]){
                
            }else{
                NSArray *urlArr = [str componentsSeparatedByRegex:@"\\jump:"];
                NSLog(@"urlArr:%@",urlArr);
                [self.maindelegate openWebContentView:urlArr[1] isHistory:0 noparam:1];
            }
            return NO;
        }
    }
    return YES;
}

-(void)showLoading{
    HUD = [[MBProgressHUD alloc] initWithView:self.webview.viewForBaselineLayout];
    [self.webview.viewForBaselineLayout addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"加载中";
    
    [HUD show:YES];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                  target:self
                                                selector:@selector(closeLoading)
                                                userInfo:nil
                                                 repeats:NO];
}

-(void)closeLoading{
    NSLog(@"closeLoading");
    [HUD hide:YES];
    [self.timer invalidate];
    self.timer = nil;
}

-(void)reload{
//    [self.webview reload];
    [self.webview stringByEvaluatingJavaScriptFromString:@"doReload()"];
    
}

-(void)openfeedback{
    [UMFeedback showFeedback:self withAppkey:@"53e23d15fd98c539f6008f10"];
}

//-(void)shareSocial{
//    [self.maindelegate shareSocial:shareimg sharetitle:sharetitle sharesubtitle:sharesubtitle shareurl:shareurl];
//}

//微信分享--start
-(void)shareSocial{
    NSLog(@"start share");
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.shareimg]];
    UIImage *shareimage = [UIImage imageWithData:imageData];
    NSLog(@"shareimg:%@",self.shareimg);
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
@end
