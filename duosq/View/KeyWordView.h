//
//  KeyWordView.h
//  duosq
//
//  Created by juno on 14-7-13.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"

@interface KeyWordView : UIView{
    IBOutlet UITableView *keywordTableView;
    id<UIViewPassValueDelegate> maindelegate;
}

- (id)initWithNib;
- (void)reloadData:(NSString *)keyword;
- (void)clearTableView;
@property(nonatomic,strong) NSMutableArray *listData;
@property(nonatomic,strong)id<UIViewPassValueDelegate> maindelegate;
@end
