//
//  PlayerProfileDetailVC_tab3.m
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileDetailVC_tab3.h"

@interface PlayerProfileDetailVC_tab3 () <UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray* msgListName;
@property (strong,nonatomic) NSMutableArray* msgListInfo;
@end

@implementation PlayerProfileDetailVC_tab3

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSMutableArray *)msgListName
{
    if (!_msgListName) {
        _msgListName = [[NSMutableArray alloc] init];
    }
    
    return _msgListName;
}

-(NSMutableArray *)msgListInfo
{
    if (!_msgListInfo) {
        _msgListInfo = [[NSMutableArray alloc] init];
    }
    
    return _msgListInfo;
}

-(void)moreInfo
{
    //self.DetailTextView.text = [NSString stringWithFormat:@"%@",self.listData];
    [self SetDatilText:self.listData];
}

-(void)SetDatilText:(NSDictionary*)dict
{
    NSArray* clubRecord = [[NSArray alloc] init];
    clubRecord = [dict objectForKey:@"playerClubRecordList"];
    
    for (NSDictionary* rec in clubRecord) {
        NSString* name = nil;
        NSString* info = nil;

        name = [[NSString alloc] initWithFormat:@"%@", [[rec objectForKey:@"clubName"] description]];
        info = [[NSString alloc] initWithFormat:@"%@  -> %@",[[rec objectForKey:@"seasonFrom"] description],[[rec objectForKey:@"seasonEnd"] description]];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:name];
        
        //an NSDictionary of NSString => UIColor pairs
        NSRange range = [name rangeOfString:[rec objectForKey:@"clubName"]];
        CGFloat fontSize = 12.0;
        UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
        //[mat setAttributes:subAttrs range:range];
        [mat addAttribute:NSFontAttributeName value:boldFont range:range];
        
        [self.msgListName addObject:mat];
        [self.msgListInfo addObject:info];
    }
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.msgListName count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell3"];
    cell.textLabel.attributedText = self.msgListName[indexPath.row];
    cell.detailTextLabel.text = self.msgListInfo[indexPath.row];
    return cell;
}

-(void)NextView
{
    
    NSUInteger number = self.tabBarController.selectedIndex + 1;
    if (number >= 4) {
        return;
    }
    
    self.tabBarController.selectedViewController
    = [self.tabBarController.viewControllers objectAtIndex:number];
    
    NSLog(@"NextView! %d",number);
    
}
@end
