//
//  MetroViewController.h
//  duosq
//
//  Created by juno on 14-7-1.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"

@interface MetroViewController : UIViewController{
    id<UIViewPassValueDelegate> maindelegate;
}
@property (nonatomic,readwrite,assign) CGRect frame;
@property (nonatomic,readwrite,strong) NSMutableArray *entryList;
@property (nonatomic,readwrite,strong) NSMutableDictionary *summary;
@property (nonatomic,readwrite,strong) NSString *time;
@property(nonatomic,strong)id<UIViewPassValueDelegate> maindelegate;
@property (strong, nonatomic) NSTimer *timer;
-(void) getMessage;
@end
