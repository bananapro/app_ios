//
//  MYCustomPanel.h
//  duosq
//
//  Created by juno on 14-8-3.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYIntroductionPanel.h"

@interface MYCustomPanel : MYIntroductionPanel
- (IBAction)passGuide:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property (strong, nonatomic) IBOutlet UIButton *passBtn;

@end
