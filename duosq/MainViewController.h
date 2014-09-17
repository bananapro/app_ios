//
//  MainViewController.h
//  duosq
//
//  Created by juno on 14-6-30.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetroViewController.h"
#import "BannerViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "KeyWordView.h"
#import "UIViewPassValueDelegate.h"
#import "MYBlurIntroductionView.h"
#import "EGORefreshTableHeaderView.h"

@interface MainViewController : UIViewController<SGFocusImageFrameDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIViewPassValueDelegate,MYIntroductionDelegate,EGORefreshTableHeaderDelegate>{
    KeyWordView *keywordTableView;
    EGORefreshTableHeaderView *_refreshHeaderView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIImageView *searchImage;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property(nonatomic,strong) MetroViewController *metroVC;
@property(nonatomic,strong) KeyWordView *keywordTableView;
@property (strong, nonatomic) IBOutlet UIView *navBg;
@property (strong, nonatomic) IBOutlet UIView *smallUI;
- (IBAction)searchExit:(id)sender;
- (IBAction)searchBegin:(id)sender;
- (IBAction)searchEnd:(id)sender;
- (IBAction)searchChange:(id)sender;
- (IBAction)cancelSearch:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

//dalegate functions
-(void)openWebContentView:(NSString *)url;

-(void)changeSearchValue:(NSString *)searchWord;


@end
