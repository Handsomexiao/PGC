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
#define TABLE_CELL_H 60


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_H;
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
            CGSize size = CGSizeMake(TABLE_CELL_H*0.8,TABLE_CELL_H*0.8);
            cell.imageView.image = [self imageScaledToSizeWithImage:image andsizeee:size];
            
            [cell.imageView sizeToFit];
//            
//            CGRect frame = cell.imageView.frame;
//            frame.size.height = TABLE_CELL_H*0.9;
//            frame.size.width = TABLE_CELL_H*0.9;
//            cell.imageView.frame = frame;
            
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
    UIFont *boldFont = [UIFont boldSystemFontOfSize:([UIFont systemFontSize] + 3)];//[UIFont systemFontSize];

    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:name];
    [mat addAttribute:NSFontAttributeName  value:boldFont range:range];
    
    cell.textLabel.attributedText = mat;
    cell.playerFmId = [[dict objectForKey:@"playerId"] integerValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@",[dict objectForKey:@"nationOfBirthName"],[dict objectForKey:@"currentClubName"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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

- (UIImage *)imageScaledToSizeWithImage:(UIImage *)imagewww andsizeee:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(imagewww.size, size))
    {
        return imagewww;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [imagewww drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
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
