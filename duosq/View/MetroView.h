//
//  MetroView.h
//  duosq
//
//  Created by juno on 14-7-2.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetroView : UIControl
@property(strong,nonatomic) NSDictionary *entry;
@property(strong,nonatomic) NSString *messagesNum;

-(void)setMessage:(NSString *)message;
-(NSString *)getMessagesNum;

- (instancetype)initWithFrame:(CGRect)frame dataModel:(NSDictionary*)dataModel;
-(void)clearMessage;
- (void)layout;

@end
