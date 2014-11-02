//
//  UIViewPassValueDelegate.h
//  duosq
//
//  Created by juno on 14-7-16.
//  Copyright (c) 2014年 juno. All rights reserved.
//

@protocol UIViewPassValueDelegate
-(void)openWebContentView:(NSString *)url isHistory:(int)isHistory noparam:(int)noparam;
-(void)changeSearchValue:(NSString *)searchWord;
-(void)shareSocial:(NSString *)shareimg sharetitle:(NSString *)sharetitle sharesubtitle:(NSString *)sharesubtitle shareurl:(NSString *)shareurl;
- (void)gotoPage:(int)p;
-(void)settingAction;
@end
