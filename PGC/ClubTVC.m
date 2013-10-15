//
//  BrowserTVC.m
//  TVTest
//
//  Created by Shuai Xiao on 9/30/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "ClubTVC.h"
#import "ClubCell.h"
#import "ClubPlayersTVC.h"

@interface ClubTVC ()
//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

@property NSInteger photoNum;
@end

@implementation ClubTVC

- (NSMutableArray *)listData
{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
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
    [self startRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClubCell";
    ClubCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSMutableDictionary* dict = self.listData[indexPath.row];
    
    // Configure the cell...
    cell.tag = indexPath.row;
    dispatch_queue_t queue = dispatch_queue_create("ImageDownloader", NULL);
    
    dispatch_async(queue, ^{
        NSInteger club_fm_id = [[dict objectForKey:@"fmId"] integerValue];
        NSString* urlString = [[NSString alloc] initWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/image/android/club_logo/3.0/%d.png",club_fm_id];
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] options:NSDataReadingMappedIfSafe error:nil];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cell.tag == indexPath.row) {
                    cell.imageView.image = image;
                    [cell setNeedsLayout];
                }
            });
        }
    });
    
    cell.textLabel.text = [dict objectForKey:@"name"];

    cell.clubId = [[dict objectForKey:@"clubId"] integerValue];
    NSLog(@"%@", [dict objectForKey:@"name"]);
    cell.detailTextLabel.text = [dict objectForKey:@"homeField"];

    
    return cell;
}

-(void)startRequest
{
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/services/clublistByLeague/11"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([data length] > 0 && connectionError == nil)
                               {
                                   NSLog(@"request finished");
                                   
                                   NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                   NSNumber *resultCodeObj = [resDic objectForKey:@"ResultCode"];
                                   
                                   NSLog(@"%@", resDic);
                                   
                                   if ([resultCodeObj integerValue] >=0)
                                   {
                                       self.listData = [resDic objectForKey:@"result"];
                                   }
                               }

                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView reloadData];
                               });
                           }];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[ClubCell class]]) {
        ClubCell* club = (ClubCell*)sender;
        if([segue.destinationViewController isKindOfClass:[ClubPlayersTVC class]])
        {
            ClubPlayersTVC* plays = (ClubPlayersTVC*)segue.destinationViewController;
            plays.cludId = club.clubId;
        }
    }
}

@end
