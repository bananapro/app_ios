//
//  MYCustonPanel_ip4.m
//  duosq
//
//  Created by juno on 14-8-7.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "MYCustonPanel_ip4.h"
#import "MYBlurIntroductionView.h"

@implementation MYCustonPanel_ip4

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)passGuide:(id)sender {
    [self.parentIntroductionView skipIntroduction];
}
@end