//
//  BannerViewController.m
//  duosq
//
//  Created by juno on 14-7-6.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "BannerViewController.h"
#import "MetroInfoService.h"
#define kBannerViewTag 111

@interface BannerViewController ()

@end

@implementation BannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadDefaultBanner];
        [self loadBannerData];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadBannerData{
    MetroInfoService *MetroInfo= [[MetroInfoService alloc] init];
    [MetroInfo getBannerInfo:^(int status, id JSON) {
        [self getBannerDataSuccess:JSON];
    }failure:^(NSError *error) {
        //NSLog(@"json:%@",JSON);
    }];
}

- (void)loadDefaultBanner{
    CGRect frame = CGRectMake(0, 0, 320, 80);
    self.defaultBanner = [[UIImageView alloc] init];
    self.defaultBanner.frame = frame;
    
    UIImage *image = [UIImage imageNamed:@"iphone5_banner_default_v1"];
    self.defaultBanner.image = image;
    [self.view addSubview:self.defaultBanner];
}

- (void)loadBanner:(NSArray *)array
{
    NSMutableArray *items=[NSMutableArray arrayWithCapacity:5];
    for (NSDictionary *dic in array) {
//        NSLog(@"banner=%@",[dic objectForKey:@"file"]);
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:[NSString stringWithFormat:@"banner"] imageUrl:[dic objectForKey:@"file"]  link:[dic objectForKey:@"link"] itemid:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
        [items addObject:item];
    }
	
	UIView *preBannerView = [self.view viewWithTag:kBannerViewTag];
	if(preBannerView != nil && [preBannerView isKindOfClass:[SGFocusImageFrame class]])
	{
		SGFocusImageFrame *preImageFrame = (SGFocusImageFrame*)preBannerView;
		[preImageFrame updateWithDataArray:items];
	}
	else
	{
		CGRect frame = CGRectMake(0, 0, 320, 80);
		
		SGFocusImageFrame *imageFrame = [[SGFocusImageFrame alloc] initWithFrame:frame delegate:self  focusImageArray:items];
		imageFrame.tag = kBannerViewTag;
        self.defaultBanner.hidden = YES;
		[self.view addSubview:imageFrame];
	}
}

//接收完毕,显示结果
- (void)getBannerDataSuccess:(NSArray*)data{
        [self loadBanner:data];
}

#pragma mark -

-(void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item{
    NSString *url = item.link;
    if (0 != url.length) {
        NSLog(@"maindelegate");
        [self.maindelegate openWebContentView:url isHistory:0 noparam:0];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
