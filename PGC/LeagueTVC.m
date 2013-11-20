//
//  LeagueTVC.m
//  PGC
//
//  Created by Xiao Shuai on 11/10/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "LeagueTVC.h"
#import "LeagueCell.h"
#import "ClubTVC.h"

@interface LeagueTVC ()
//保存数据列表
@property (nonatomic,strong) NSArray* listLeagueNumber;
@property (nonatomic,strong) NSArray* listLeagueName;
@property (nonatomic,strong) NSArray* listLeagueCountry;
@end

@implementation LeagueTVC


- (NSArray *)listLeagueNumber
{
    if (!_listLeagueNumber) {
        _listLeagueNumber = [[NSArray alloc] initWithObjects:
           @"11",@"17",@"21",@"19",@"15",nil];
    };

    return _listLeagueNumber;
}

-(NSArray *)listLeagueName
{
    if (!_listLeagueName) {
        _listLeagueName = [[NSArray alloc] initWithObjects:@"Barclays Premier League",@"Bundesliga",@"Ligue 1",@"Liga BBVA",@"Serie A", nil];
    }
    
    return _listLeagueName;
}


-(NSArray *)listLeagueCountry
{
    if (!_listLeagueCountry) {
        _listLeagueCountry = [[NSArray alloc] initWithObjects:@"England",@"Germany",@"France",@"Spain",@"Italy", nil];
    }
    
    return _listLeagueCountry;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.listLeagueNumber.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeagueCell";
    LeagueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = nil;
    NSString* path = [NSString stringWithFormat:@"%@.png", self.listLeagueNumber[indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:path];
    cell.textLabel.text = self.listLeagueName[indexPath.row];
    cell.detailTextLabel.text = self.listLeagueCountry[indexPath.row];
    // Configure the cell...
    cell.leagueId = [self.listLeagueNumber[indexPath.row] integerValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[LeagueCell class]]) {
        LeagueCell* cell = (LeagueCell*)sender;
        if([segue.destinationViewController isKindOfClass:[ClubTVC class]])
        {
            ClubTVC* clubs = (ClubTVC*)segue.destinationViewController;
            clubs.leagueId = cell.leagueId;
        }
    }
}


@end
