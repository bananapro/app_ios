//
//  BannerViewController.h
//  duosq
//
//  Created by juno on 14-7-6.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "BaseViewController.h"
#import "UIViewPassValueDelegate.h"

@interface BannerViewController : BaseViewController<SGFocusImageFrameDelegate>{
    id <UIViewPassValueDelegate> maindelegate;
}

@property(nonatomic,strong) id<UIViewPassValueDelegate> maindelegate;
@property(nonatomic,strong) UIImageView *defaultBanner;
@end
