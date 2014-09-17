//
//  MetroView.m
//  duosq
//
//  Created by juno on 14-7-2.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "MetroView.h"
#import "ADTickerLabel.h"
#define kPeddingValue 4
@implementation MetroView

- (instancetype)initWithFrame:(CGRect)frame dataModel:(NSDictionary*)dataModel
{
	if (self = [self initWithFrame:frame]) {
//        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//        NSLog(@"rect:%@",NSStringFromCGRect(frame));
//        NSLog(@"datamodel:%@",dataModel);
		self.entry = dataModel;
        
		// touch events
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchCancle) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(touchCancle) forControlEvents:UIControlEventTouchCancel];
        [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return self;
}

- (void)layout
{
    self.bounds = CGRectMake(0, kPeddingValue, self.bounds.size.width, self.bounds.size.height-kPeddingValue);
//    NSLog(@"viewRect:%@",NSStringFromCGRect(self.bounds));
	
    //background image
	UIImageView *imageView = nil;

	self.backgroundColor = [UIColor colorWithRed:(232.0/255.0) green:(232.0 / 255.0) blue:(232.0 / 255.0) alpha:1];
    imageView = [self getImageViewWithTag:1];
    imageView.frame = self.bounds;
    
//    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"v_%@",[self.entry objectForKey:@"bg_pic_default_path"]]];
    UIImage *image = [UIImage imageNamed:[self.entry objectForKey:@"bg_pic_default_path"]];
    imageView.image = image;
}

#pragma mark - private methods
//- (UILabel*)getLabelWithTag:(NSUInteger)tag
//{
//	UILabel *label = (UILabel*)[self viewWithTag:tag];
//	
//	if (nil == label) {
//		label = [[UILabel alloc] init];
//		label.backgroundColor = [UIColor clearColor];
//		label.tag = tag;
//		label.textColor = [UIColor whiteColor];
//		
//		[self addSubview:label];
//	}
//	
//	return label;
//}

- (ADTickerLabel*)getLabelWithTag:(NSUInteger)tag
{
	ADTickerLabel *label = (ADTickerLabel*)[self viewWithTag:tag];
	
	if (nil == label) {
		label = [[ADTickerLabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-19, 21, 8)];
		label.tag = tag;
		[self addSubview:label];
	}
    label.hidden = NO;
	return label;
}

- (UIImageView*)getImageViewWithTag:(NSUInteger)tag
{
	UIImageView *imageView = (UIImageView*)[self viewWithTag:tag];
	
	if (nil == imageView) {
		imageView = [[UIImageView alloc] init];
		imageView.tag = tag;
		[self addSubview:imageView];
	}
	imageView.hidden = NO;
	return imageView;
}

#pragma mark - touch handler methods
- (void)touchDown
{
	self.alpha = 0.5;
}

- (void)touchCancle
{
	self.alpha = 1.0;
}

- (void)touchUp
{
	self.alpha = 1.0;
}

-(void)setMessage:(NSString *)message{
    
    NSString *viewId = [NSString stringWithFormat:@"%@",[self.entry objectForKey:@"id"]];
    
    //message background image
    if (![viewId isEqual:@"111"]) {
        UIImageView *mimageView = nil;
        self.backgroundColor = [UIColor colorWithRed:(232.0/255.0) green:(232.0 / 255.0) blue:(232.0 / 255.0) alpha:1];
        mimageView = [self getImageViewWithTag:2];
        mimageView.frame = CGRectMake(4, self.bounds.size.height-21, 19, 19);
        
        UIImage *mimage = [UIImage imageNamed:@"news_purple"];
        mimageView.image = mimage;
    }

    ADTickerLabel *label = nil;
    CGRect rect = CGRectZero;
 
    self.messagesNum = [NSString stringWithFormat:@"%@",message];
    label = [self getLabelWithTag:3];
    label.contentMode = UIViewContentModeTopLeft;

    CGRect frame;
    
    if ([self.messagesNum intValue]>99) {
        frame = CGRectMake(6, self.bounds.size.height-19, 21, 8);
        label.text = @"99";
    }else{
        if ([self.messagesNum intValue]>=10) {
            frame = CGRectMake(6, self.bounds.size.height-19, 21, 8);
        }else{
            frame = CGRectMake(10, self.bounds.size.height-19, 21, 8);
        }
        label.text = self.messagesNum;
    }
    
    label.frame = frame;
    
    if([viewId isEqual:@"111"]){
        label.textColor = [UIColor colorWithRed:(173.0/255.0) green:(35.0 / 255.0) blue:(50.0 / 255.0) alpha:1];
    }else{
        label.textColor = [UIColor whiteColor];
    }
    
    [label sizeToFit];
    rect = label.frame;
}

-(void)clearMessage{
    ADTickerLabel *label = (ADTickerLabel*)[self viewWithTag:3];
    UIImageView *mimageView = (UIImageView*)[self viewWithTag:2];
    NSString *viewId = [NSString stringWithFormat:@"%@",[self.entry objectForKey:@"id"]];
    if(![viewId isEqual:@"111"]){
        label.hidden = YES;
        mimageView.hidden = YES;
    }
}

-(NSString *)getMessagesNum{
    return self.messagesNum;
}
@end
