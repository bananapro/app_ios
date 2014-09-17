//
//  SGFocusImageFrame.m
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import <objc/runtime.h>
#import "SDImageView+SDWebCache.h"
#define kTimerTime 8
#define kNeedDeleteViewTag 151
@interface SGFocusImageFrame () {
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSTimer *timer;
}
@property(nonatomic,retain)NSTimer *timer;
- (void)setupViews;
- (void)switchFocusImageItems;
- (void)checkInvalidItem:(NSArray*)newImageItems;
@end

static NSString *SG_FOCUS_ITEM_ASS_KEY = @"com.52f1fanli.app";

//static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 10.0; //switch interval time

@implementation SGFocusImageFrame
@synthesize delegate = _delegate;
@synthesize timer;
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];  
        SGFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem)
        {                                  
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);       
            while((eachItem = va_arg(argumentList, SGFocusImageItem *)))
            {
                [imageItems addObject: eachItem];            
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self setupViews];
        
        [self setDelegate:delegate]; 
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}

- (void)dealloc
{
    objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [_scrollView release];
    [_pageControl release];
    [timer release];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)updateWithDataArray:(NSArray*)newImageItems
{
	/**for test 延迟更新
	static int a = 0;
	if (a++==1) {
		[self performSelector:@selector(updateWithDataArray:) withObject:newImageItems afterDelay:5];
		return;
	}*/
	
	if (!newImageItems || [newImageItems count] <= 0) {
		return;
	}
	
	//用户是否正在操作
	if (_scrollView.isDecelerating || _scrollView.isDragging || _scrollView.isTracking) {
		[self performSelector:@selector(updateWithDataArray:) withObject:newImageItems afterDelay:kTimerTime/5.0];
		return;
	}
	
	//正在动画
	if ([_scrollView.layer.animationKeys count] > 0) {
		[self performSelector:@selector(updateWithDataArray:) withObject:newImageItems afterDelay:0.5];
		return;
	}
	
	//定时停止,禁止拖拉
	[timer setFireDate:[NSDate distantFuture]];
	_scrollView.scrollEnabled = NO;
		
	//获取当前显示的item，判断其是否在新的items中
	//如果不在新的item中，则删除其他的item，将所有的新item添加到当前显示item之后，当前item划出屏幕后remove掉
	//如果在新的item中，则以其为中心，根据在新items中得位置，将在其前的item添加到当前页面前，后的添加到后边
	NSArray *currentImageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
	SGFocusImageItem *currentItem = nil;
	if (currentImageItems) {
		int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
		if (page > -1 && page < currentImageItems.count) {
			currentItem = [currentImageItems objectAtIndex:page];
		}
	}
    
	if (!currentItem) {
		//当前没有数据显示或者页面显示与数据不匹配
		//这种情况暴力更新，直接替换
		objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, newImageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		
		for (UIView *subview in self.subviews) {
			[subview removeFromSuperview];
		}
		SAFE_RELEASE(_scrollView);
		SAFE_RELEASE(_pageControl);
		[self setupViews];
      
	}else{
		//当前页面是否在新的数据中
		int currentIndexInNewArray = -1;
		for (int i = 0; i < newImageItems.count; i++) {
			SGFocusImageItem *item = (SGFocusImageItem *)[newImageItems objectAtIndex:i];
		
			if ([currentItem.title isEqualToString:item.title]
				&& [currentItem.link isEqualToString:item.link]
				&& [currentItem.imageUrl isEqualToString:item.imageUrl]
				&& [currentItem.itemid isEqualToString:item.itemid]) {
				currentIndexInNewArray = i;
				break;
			}
		}
		
		for (UIView *subview in _scrollView.subviews) {
			[subview removeFromSuperview];
		}
		
		NSArray *newImageItems_ = nil;
		BOOL currentInNewArray = (currentIndexInNewArray != -1);
		if (currentInNewArray) {
			//当前显示的在新的数据中存在
			newImageItems_ = newImageItems;
		}else{
			//在新数据中不存在，将其添加到新数据的最前
			NSMutableArray *tempArray = [NSMutableArray arrayWithObject:currentItem];
		    [tempArray addObjectsFromArray:newImageItems];
			newImageItems_ = tempArray;
			currentIndexInNewArray = 0;
		}
		
		_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * newImageItems_.count, _scrollView.frame.size.height);
		for (int i = 0; i < newImageItems_.count; i++) {
			SGFocusImageItem *item = [newImageItems_ objectAtIndex:i];
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
			NSString *urlString=[item.imageUrl stringByReplacingOccurrencesOfString:@" " withString:@""];//100*100 120*120
			NSURL *url=nil;
			if ((NSNull *)urlString!=[NSNull null]) {
				url=[NSURL URLWithString:urlString];
			}
			
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			if(url) {
				[imageView setImageWithURL:url];
			}else{
				imageView.image=[UIImage imageNamed:@"nopic.png"];
			}
			//当前页面在新的数据中不存在，做标记待删除
			if (!currentInNewArray && i == currentIndexInNewArray) {
				imageView.tag = kNeedDeleteViewTag;
			}
			[_scrollView addSubview:imageView];
			[imageView release];
		}
		
		_pageControl.numberOfPages = newImageItems_.count;
		_pageControl.currentPage = currentIndexInNewArray;
		[_scrollView setContentOffset:CGPointMake(currentIndexInNewArray * _scrollView.frame.size.width, 0) animated:NO] ;
		
		if (!currentInNewArray) {
			//当前页面在新数据中不存在，需要在其离开页面后删除
			//注意，由于在这个方法中会暂停切换page的timer，所以，如果这个值比timer的值小，则会导致timer的方法永久不会调用
			//设置不合理的话有可能每次需要删除的页面都在显示，导致永远删不掉
			[self performSelector:@selector(checkInvalidItem:) withObject:newImageItems afterDelay:kTimerTime * 1.15];

		}
	    objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, newImageItems_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
		
	//定时恢复,恢复拖拉
	[timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimerTime]];
	_scrollView.scrollEnabled = YES;

}


#pragma mark - private methods

- (void)checkInvalidItem:(NSArray*)newImageItems{
	//正在拖拉或者在动画
	if (_scrollView.isDecelerating || _scrollView.isDragging || _scrollView.isTracking || [_scrollView.layer.animationKeys count] > 0) {
		[self performSelector:@selector(checkInvalidItem:) withObject:newImageItems afterDelay:kTimerTime * 1.15];
		return;
	}
	
	//需要删除的子项不存在
	if (![_scrollView viewWithTag:kNeedDeleteViewTag]) {
		return;
	}
		
	//定时停止,禁止拖拉
	[timer setFireDate:[NSDate distantFuture]];
	_scrollView.scrollEnabled = NO;
		
	//当前页面
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
	UIView *viewToDelete = [_scrollView viewWithTag:kNeedDeleteViewTag];
    int toDeleteIndex = (int)(viewToDelete.frame.origin.x / _scrollView.frame.size.width);
	
    if (page ==  toDeleteIndex) {
		//需要删除的页面仍然在显示，延迟一定时间后再检测
		[self performSelector:@selector(checkInvalidItem:) withObject:newImageItems afterDelay:kTimerTime * 1.15];
	}else
	{
		//在被删除页面之后的子页面全部向左移动一位
		for (UIView *subview in _scrollView.subviews) {
			if (subview.frame.origin.x > viewToDelete.frame.origin.x) {
				subview.frame = CGRectMake(subview.frame.origin.x - _scrollView.frame.size.width, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height);
			}
		}
		
		[viewToDelete removeFromSuperview];
		
		objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, newImageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * newImageItems.count, _scrollView.frame.size.height);
		_pageControl.numberOfPages = newImageItems.count;

		if (page > toDeleteIndex) {
			_scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x - _scrollView.frame.size.width, _scrollView.contentOffset.y);
			_pageControl.currentPage = _pageControl.currentPage - 1;
		}

	}
	
	//定时恢复,恢复拖拉
	[timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimerTime]];
	_scrollView.scrollEnabled = YES;
	
}

- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    NSLog(@"%f=%f=%f=%f=",_scrollView.frame.origin.x,_scrollView.frame.origin.x,_scrollView.frame.size.height,_scrollView.frame.size.width);
    CGSize size = CGSizeMake(100, 18);
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width *.5 - size.width *.5, self.bounds.size.height - size.height, size.width, size.height)];
    
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    /*
    _scrollView.layer.cornerRadius = 10;
    _scrollView.layer.borderWidth = 1 ;
    _scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
    */
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    _pageControl.numberOfPages = imageItems.count;
    _pageControl.currentPage = 0;
    
    _scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * imageItems.count, _scrollView.frame.size.height);
    for (int i = 0; i < imageItems.count; i++) {
        SGFocusImageItem *item = [imageItems objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        //imageView.image = item.image;
        //mxy modify
        NSString *urlString=[item.imageUrl stringByReplacingOccurrencesOfString:@" " withString:@""];//100*100 120*120
        NSURL *url=nil;
        if ((NSNull *)urlString!=[NSNull null]) {
            url=[NSURL URLWithString:urlString];
        }
        //NSLog(@"banner=urlString=%@",urlString);
		imageView.contentMode = UIViewContentModeScaleAspectFit;
        if(url) {
            [imageView setImageWithURL:url];
        }else{
            imageView.image=[UIImage imageNamed:@"nopic.png"];
        }
        //
        [_scrollView addSubview:imageView];
        [imageView release];
    }
    [tapGestureRecognize release];
    
   
    self.timer=[NSTimer scheduledTimerWithTimeInterval:kTimerTime target:self selector:@selector(switchFocusImageItems) userInfo:nil  repeats:YES] ;
    //[self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    //objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
	
    //[self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s", __FUNCTION__);
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < imageItems.count) {
        SGFocusImageItem *item = [imageItems objectAtIndex:page];
        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)]) {
            [self.delegate foucusImageFrame:self didSelectItem:item];
        }
    }
    //objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    //NSLog(@"moveToTargetPosition : %f" , targetX);
    if (targetX >= _scrollView.contentSize.width) {
        targetX = 0.0;
    }
    [UIView animateWithDuration:0.4 animations:^{
        [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO] ;
    }completion:^(BOOL finished){
        _pageControl.currentPage = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    }];

    //[_scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
   // _pageControl.currentPage = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //定时停止
    [timer setFireDate:[NSDate distantFuture]];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x<0) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
    }else if (scrollView.contentOffset.x>scrollView.contentSize.width-scrollView.frame.size.width) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width-scrollView.frame.size.width, scrollView.contentOffset.y) animated:NO];
    }
    CGFloat pageWidth = self.frame.size.width;
    _pageControl.currentPage  = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
     //NSLog(@"_pageControl.currentPage==%i",_pageControl.currentPage);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        //定时开始
         [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimerTime]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //定时开始
    [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimerTime]];
}


@end
