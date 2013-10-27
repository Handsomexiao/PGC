//
//  TopPlayersTVC.m
//  PGC
//
//  Created by Shuai Xiao on 10/8/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "TopPlayersTVC.h"
#import "PlayerCell.h"
#import "playerProfileDetailTBC.h"
#import "PlayerPhoto+Internet.h"

@interface TopPlayersTVC ()

//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

@end

@implementation TopPlayersTVC

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

-(NSMutableArray*)listData
{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    
    return _listData;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // a UIRefreshControl inherits from UIControl, so we can use normal target/action
    // this is the first time you’ve seen this done without ctrl-dragging in Xcode
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self startRequest];
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
    if (self.listData) {
        return self.listData.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TopPlayerCell";
    PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PlayerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSMutableDictionary* dict = self.listData[indexPath.row];
    
    // Configure the cell...
    cell.tag = indexPath.row;
    
    
    cell.imageView.image = nil; // or cell.poster.image = [UIImage imageNamed:@"placeholder.png"];
    cell.imageView.image = [UIImage imageNamed:@"player-placeholder2.png"];

    NSInteger playerFmId = [[dict objectForKey:@"fmId"] integerValue];
    [PlayerPhoto photoData:playerFmId afterDone:^(UIImage* image){
        if (cell.tag == indexPath.row) {
            cell.imageView.image = image;
            [cell.imageView updateConstraints];
        }
    }];

    
    NSString* name = nil;
    if ([[[dict objectForKey:@"firstName"] description] compare:@""]) {
        name = [[NSString alloc] initWithFormat:@"%@ %@",[[dict objectForKey:@"firstName"] description] ,[[dict objectForKey:@"lastName"] description]];
    }
    else
    {
        name = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"lastName"]];
    }
    
    //an NSDictionary of NSString => UIColor pairs
    NSRange range = [name rangeOfString:[[dict objectForKey:@"lastName"] description]];
    
    CGFloat fontSize = [UIFont systemFontSize];
    
    NSDictionary *attributes = [cell.textLabel.attributedText attributesAtIndex:0 effectiveRange:NULL];
    UIFont *font = attributes[NSFontAttributeName];
    if (font) fontSize = font.pointSize;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:name];
    //[mat setAttributes:subAttrs range:range];
    [mat addAttribute:NSFontAttributeName value:boldFont range:range];
    
    cell.textLabel.attributedText = mat;
    cell.playerFmId = [[dict objectForKey:@"playerId"] integerValue];
    NSLog(@"%@", name);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"nationOfBirthName"]];
    
    return cell;
}

-(void)startRequest
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/services/playerlist/10"]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSLog(@"%@",url);
    
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


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[PlayerCell class]]) {
        PlayerCell* player = (PlayerCell*)sender;
        if([segue.destinationViewController isKindOfClass:[playerProfileDetailTBC class]])
        {
            playerProfileDetailTBC* plays = (playerProfileDetailTBC*)segue.destinationViewController;
            plays.playerFmId = player.playerFmId;
        }
    }
}


@end
