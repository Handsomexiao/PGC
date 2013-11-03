//
//  PlayerProfileDetailVC.m
//  PGC
//
//  Created by Shuai Xiao on 10/7/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileDetailVC_tab1.h"

@interface PlayerProfileDetailVC_tab1 () <UITableViewDataSource>
@property (strong,nonatomic) NSMutableArray* msgListName;
@property (strong,nonatomic) NSMutableArray* msgListInfo;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PlayerProfileDetailVC_tab1

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
    NSDictionary* table = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"fullName",@"Full Name",
                           @"cityOfBirth",@"Place of Birth",
                           @"dateOfBirth",@"Date of Birth",
                           @"nationOfBirthName",@"Nationality",
                           @"height",@"Height",
                           @"weight",@"Weight",
                           @"preferFoot",@"Prefer Foot",nil];
    NSMutableAttributedString* allName = [[NSMutableAttributedString alloc] init];

    
    NSArray* allkey = [table allKeys];
    for (NSString* key in allkey) {
        NSString* name = nil;
        NSString* info = nil;

 
        name = [[NSString alloc] initWithFormat:@"%@", key];
        info = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:[[table objectForKey:key] description]]];
        NSMutableAttributedString *matName = [[NSMutableAttributedString alloc] initWithString:name];
        NSMutableAttributedString *matInfo = [[NSMutableAttributedString alloc] initWithString:info];

        //an NSDictionary of NSString => UIColor pairs
        NSRange range = [name rangeOfString:key];
        CGFloat fontSize = 16.0;
        UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
        UIFont *normalFont = [UIFont systemFontOfSize:fontSize];

        NSRange allrange;
        allrange.location = 0;
        allrange.length = [info length];
        [matName addAttribute:NSFontAttributeName value:boldFont range:range];
        
        [matInfo addAttribute:NSFontAttributeName value:normalFont range:allrange];

        [self.msgListName addObject:matName];
        [self.msgListInfo addObject:matInfo];
    }

    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.msgListName count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    cell.textLabel.attributedText = self.msgListName[indexPath.row];
    cell.detailTextLabel.attributedText = self.msgListInfo[indexPath.row];
    return cell;
}
@end
