//
//  KeyWordView.m
//  duosq
//
//  Created by juno on 14-7-13.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "KeyWordView.h"
#import "SearchInfoService.h"

@implementation KeyWordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"initWithNib");
        // Initialization code
    }
    return self;
}

- (id)initWithNib
{
    NSLog(@"initWithNib");
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"KeyView" owner:nil options:nil];
    self = (KeyWordView *)[views objectAtIndex:0];
    if (self) {
        self.listData=[NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if(!self.listData.count){
        return 1;
    }
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    NSLog(@"indexPath:%d",indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.listData.count) {
        cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = @"";
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.listData.count){
        NSString *searchWord = [self.listData objectAtIndex:indexPath.row];
        [self.maindelegate changeSearchValue:searchWord];
    }
}

-(void)reloadData:(NSString *)keyword{
    SearchInfoService *SearchInfo= [[SearchInfoService alloc] init];
    self.listData = nil;
    [SearchInfo getSearchListByKeyword:keyword success:^(int status, id JSON) {
        self.listData = [JSON objectForKey:@"content"];
//        NSLog(@"count:%d",self.listData.count);
//        NSLog(@"listdata:%@",self.listData);
        
        [keywordTableView reloadData];
    } failure:^(NSError *error) {
        [keywordTableView reloadData];
    }];
}

-(void)clearTableView{
    self.listData = nil;
    [keywordTableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
