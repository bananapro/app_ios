//
//  SGFocusImageItem.m
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title =  _title;
@synthesize image =  _image;
@synthesize tag =  _tag;
@synthesize imageUrl =  _imageUrl;
@synthesize link =  _link;
@synthesize itemid =  _itemid;
- (void)dealloc
{
    [_title release];
    [_image release];
    [_imageUrl release];
    [_link release];
    [_itemid release];
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    
    return self;
}
- (id)initWithTitle:(NSString *)title imageUrl:(NSString *)imageUrl link:(NSString *)link itemid:(NSString *)itemid
{
    self = [super init];
    if (self) {
        self.title = title;
        self.imageUrl = imageUrl;
        self.link = link;
        self.itemid=itemid;
    }
    
    return self;
}
@end
