//
//  UMFeedbackViewController.m
//  duosq
//
//  Created by juno on 14-8-7.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "UMFeedbackViewController.h"
#import "UMFeedback.h"

@interface UMFeedbackViewController ()

@end

@implementation UMFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    //UMfeedback start
    [UMFeedback showFeedback:self withAppkey:@"53e23d15fd98c539f6008f10"];
    //UMfeedback end
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
