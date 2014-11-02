//
//  Data.h
//  duosq
//
//  Created by Juno on 14-10-23.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#ifndef duosq_Data_h
#define duosq_Data_h

#define kSearchKeywordUrl @"http://h5.duosq.com:8080/promotion/search"

#define kDefaultBackgroundColor [UIColor colorWithRed:206/255.0 green:31/255.0 blue:118/255.0 alpha:1]
#define kGeryBackgroundColor [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1]
#define kSearchPlaceholderColor [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1]
#define kPeddingValue 4
#define kBannerTag 101
#define kBannerHeight 80
#define kBannerHeightiphone4 0
#define kHeightOfNavBar	60
#define kSettingWidth 265

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO
#define kSearchKeyTabHeight iPhone5?330:200

#define statusBarHeight (IOS7)?20:0
#endif
