//
//  BaseViewController.m
//  duosq
//
//  Created by juno on 14-7-15.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductWebViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button:(id)sender {
    ProductWebViewController  *webContentView = [[ProductWebViewController alloc] initWithNibName:@"ProductWebViewController" bundle:nil];    
    [self.navigationController pushViewController:webContentView animated:YES];
}
@end
