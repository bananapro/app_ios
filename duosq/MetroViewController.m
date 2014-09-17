//
//  MetroViewController.m
//  duosq
//
//  Created by juno on 14-7-1.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "MetroViewController.h"
#import "MetroInfoService.h"
#import "MetroView.h"

#define kPeddingValue	4
// key of dic stored in userdefault
#define kMetroKeyOfMetroInfo			@"metroInfo"

// key of api return
#define	kMetroKeyOfSummary				@"summary"
#define kMetroKeyOfCols					@"cols"
#define kMetroKeyOfMinimalHeight		@"minimal_height"

#define kMetroKeyOfEntryList			@"entry_list"
#define kMetroKeyOfID					@"id"
#define	kMetroKeyOfType					@"type"
#define kMetroKeyOfName					@"name"
#define kMetroKeyOfSubTitle				@"sub_title"
#define kMetroKeyOfInfoType				@"info_type"
#define	kMetroKeyOfInfoText				@"info_text"
#define	kMetroKeyOfInfoUrl				@"info_url"
#define	kMetroKeyOfBgPic				@"bg_pic"
#define kMetroKeyOfBgColor				@"bg_color"
#define	kMetroKeyOfPic					@"pic"
#define kMetroKeyOfBgPicMD5				@"bg_pic_md5"
#define kMetroKeyOfPicMD5				@"pic_md5"
#define	kMetroKeyOfFontSize				@"font_size"
#define	kMetroKeyOfFSOfTitle			@"title"
#define	kMetroKeyOfFSOfSubTitle			@"sub_title"
#define	kMetroKeyOfPercentOfHeight		@"percent_of_height"
#define kMetroKeyOfUrl					@"url"
#define	kMetroKeyOfWebViewType			@"web_view_type"
#define	kMetroKeyOfLastVisitTimeType	@"last_visit_time_type"
#define kMetroKeyOfSubEntryList			@"sub_entry_list"

// key of api return
#define kMetroValueOfType_Url			@"url"
#define kMetroValueOfType_Group			@"group"
#define kMetroValueOfType_Separator		@"separator"

// key of default info in bundle
#define kMetroValueOfPicPath			@"pic_default_path"
#define kMetroValueOfBgPicPath			@"bg_pic_default_path"



@interface MetroViewController ()

@end

@implementation MetroViewController

NSMutableDictionary *tagsBtn;

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
     tagsBtn = [[NSMutableDictionary alloc] init];
    [self loadModel];
    
    //后台自动获取消息数的脚本
    self.timer=[NSTimer scheduledTimerWithTimeInterval:60
                                               target:self
                                             selector:@selector(getMessage)
                                             userInfo:nil
                                              repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadModel
{
    MetroInfoService *MetroInfo= [[MetroInfoService alloc] init];
    
    NSDictionary *dic = [[MetroInfo jsonParse] objectForKey:@"data"];
    self.entryList = [dic objectForKey:kMetroKeyOfEntryList];
    self.summary = [dic objectForKey:kMetroKeyOfSummary];
    [self loadMetroView];
    
//    [MetroInfo getMetroInfo:^(int status, id JSON) {
//        self.entryList = [JSON objectForKey:kMetroKeyOfEntryList];
//        self.summary = [JSON objectForKey:kMetroKeyOfSummary];
////        NSLog(@"%@",self.entryList);
//        [self loadMetroView];
//    }failure:^(NSError *error) {
//        //NSLog(@"json:%@",JSON);
//    }];
}

-(void)addMessages:(NSDictionary*)messages{
    
    NSString *readDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"isReadDate"];
    NSString *todaydate = [self getLocalDate];
    int needClear = 0;
    if (![readDate isEqualToString:todaydate]) {
        needClear = 1;
        [[NSUserDefaults standardUserDefaults] setObject:todaydate forKey:@"isReadDate" ];
    }
    
    for (id message in messages) {
        NSString *isReadKey = [NSString stringWithFormat:@"%@isRead",message];
        if (needClear) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:isReadKey];
        }
        
        int hmessages = [[[NSUserDefaults standardUserDefaults] objectForKey:isReadKey] intValue];
        int message_value = [[messages objectForKey:message] intValue];
        if (message_value > hmessages && ![message isEqualToString:@"111"]) {
            NSString *new_message = [NSString stringWithFormat:@"%d",message_value-hmessages];
            [[tagsBtn objectForKey:message] setMessage:new_message];
        }else if([message isEqualToString:@"111"]){
            [[tagsBtn objectForKey:message] setMessage:[NSString stringWithFormat:@"%d",message_value]];
        }else{
            [[tagsBtn objectForKey:message] clearMessage];
        }
    }
}

- (void)addMetroViewWith:(NSArray*)array inRect:(CGRect)rect
{
	UIScrollView *rootView = (UIScrollView*)self.view;

	NSInteger col = 0;
	NSInteger cols = 2;
	CGRect viewRect = CGRectMake(rect.origin.x, rect.origin.y, 0, 0);
	CGFloat sumHeightPercent = 0;
	CGFloat heightPercent = 0;
    CGFloat width = 0;
	
	for (NSDictionary* entry in array) {
		heightPercent = [[entry objectForKey:@"percent_of_height"] floatValue];
        
        viewRect.size.width = [[entry objectForKey:@"width"] floatValue]/2;
		viewRect.origin.y = rect.origin.y + sumHeightPercent * (rootView.contentSize.height-kPeddingValue*2); // y
		viewRect.size.height = heightPercent * (rootView.contentSize.height-kPeddingValue*2); // height
        
		sumHeightPercent += heightPercent; // update sum
		
        
		if ([[entry objectForKey:@"type"] isEqualToString:kMetroValueOfType_Separator]) {
			if (++col < cols) {
				// reset
                NSLog(@"width:%f",width);
				viewRect.origin.x += width+kPeddingValue;
				viewRect = CGRectMake(viewRect.origin.x, viewRect.origin.y, 0, 0);
				sumHeightPercent = 0;
				continue;
			}
			else {
				break;
			}
		}
		else if ([[entry objectForKey:@"type"] isEqualToString:kMetroValueOfType_Group]) {
			[self addMetroViewWith:[entry objectForKey:@"sub_entry_list"] inRect:viewRect];
		}
		else {
//            NSLog(@"viewRect:%@",NSStringFromCGRect(viewRect));
            
            width = [[entry objectForKey:@"width"] floatValue]/2;
			MetroView *view = [[MetroView alloc] initWithFrame:viewRect dataModel:entry];
			[view layout];
			[view addTarget:self action:@selector(viewTapped:) forControlEvents:UIControlEventTouchUpInside];
//			view.exclusiveTouch = YES;
            [tagsBtn setObject:view forKey:[NSString stringWithFormat:@"%@",[entry objectForKey:@"id"]]];
//            [tagsBtn setValue:view forKey:[entry objectForKey:@"id"]];
			[rootView addSubview:view];
		}
	}
    //加载完按钮取一次消息
    [self getMessage];
}


-(void) getMessage{
    MetroInfoService *MetroInfo= [[MetroInfoService alloc] init];
    [MetroInfo getMessages:^(int status, id JSON) {
        NSDictionary *messages = [JSON objectForKey:@"content"];
        [self addMessages:messages];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

- (void)loadMetroView
{
		UIScrollView *rootView = (UIScrollView*)self.view;

		for (UIView *subView in rootView.subviews) {
			[subView removeFromSuperview];
		}
		
		CGSize size = self.frame.size;
		CGFloat minHeight = [[self.summary objectForKey:kMetroKeyOfMinimalHeight] floatValue];
		if (self.frame.size.height < minHeight) {
			size.height = minHeight;
			rootView.showsVerticalScrollIndicator = YES;
		}
		else {
			rootView.showsVerticalScrollIndicator = NO;
		}

		rootView.contentSize = size;

		CGRect rect = CGRectMake(kPeddingValue, kPeddingValue, rootView.contentSize.width-2*kPeddingValue, rootView.contentSize.height-2*kPeddingValue);
    
		[self addMetroViewWith:self.entryList inRect:rect];
}

- (void)loadView
{
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
	scrollView.showsHorizontalScrollIndicator = NO;
	
	self.view = scrollView;
}

#pragma mark - tap method
- (void)viewTapped:(MetroView*)view
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	NSString *url = [view.entry objectForKey:@"url"];
    
	if (0 != url.length) {
        NSString *messagesnum = [view getMessagesNum];
        [self clearMessages:[NSString stringWithFormat:@"%@",[view.entry objectForKey:@"id"]] messages:messagesnum];
        [view clearMessage];
//        [view setMessage:@"0"];
        [self.maindelegate openWebContentView:url];
	}
}

- (void)clearMessages:(NSString *)key messages:(NSString *)messages_num{
    NSLog(@"clear key:%@ >>>>>>num:%@",key,messages_num);
    NSString *isReadKey = [NSString stringWithFormat:@"%@isRead",key];
    int hmessages = [[[NSUserDefaults standardUserDefaults] objectForKey:isReadKey] intValue];
    hmessages = hmessages + [messages_num intValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",hmessages] forKey:isReadKey];
}

-(NSString *)getLocalDate{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMdd"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
//    NSLog(@"locationString:%@",locationString);
    
    return locationString;
}

@end
