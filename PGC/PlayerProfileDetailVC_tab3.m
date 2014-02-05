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

@property (strong, nonatomic) IBOutlet UIImageView *CountryImage;
@property (strong, nonatomic) IBOutlet UIImageView *ClubImage;

@end

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


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
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Vizoal-background.png"]];
    [tempImageView setFrame:self.view.frame];
    [self.view insertSubview:tempImageView belowSubview:self.view.subviews[0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)participationlistData
{
    if (!_participationlistData) {
        _participationlistData = [[NSDictionary alloc] init];
    }
    return _participationlistData;
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

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.vizoal.com/vizoal/services/player/participation/%ld",(long)self.PlayerFmId]];
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
                                       self.participationlistData = [resDic objectForKey:@"result"];
                                   }
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self SetParticipationText:self.participationlistData];
                               });
                           }];
    
    dispatch_async(kBgQueue, ^{
        NSInteger club_fm_id = [[self.listData objectForKey:@"club_fm_id"] integerValue];
        NSString* urlString = [[NSString alloc] initWithFormat:@"http://api.vizoal.com/vizoal/image/android/club_logo/3.0/%ld.png",(long)club_fm_id];
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] options:NSDataReadingMappedIfSafe error:nil];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ClubImage.image = image;
                [self.ClubImage updateConstraints];
            });
        }
    });
    
    dispatch_async(kBgQueue, ^{
        NSInteger nationDisplay = [[self.listData objectForKey:@"nationality_fmid"] integerValue];
        NSString* urlString = [[NSString alloc] initWithFormat:@"http://api.vizoal.com/vizoal/image/android/country_logo_profile/2.0/%ld.png",(long)nationDisplay];
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] options:NSDataReadingMappedIfSafe error:nil];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.CountryImage.image = image;
                [self.CountryImage updateConstraints];
            });
        }
    });
    
}


-(void)SetParticipationText:(NSDictionary*)dict
{
    NSDictionary* table = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"Appearances",@"gameStarted",
                           @"Goals",@"goals",
                           @"Assists",@"assists",
                           @"Rate",@"rating",
                           @"Yellow Cards",@"yellow",
                           @"Red Cards",@"red",
                           @"Total Shots",@"totalShots",
                           @"Target Shots",@"shotsOnTarget",
                           @"Total Passes",@"totalPasses",
                           @"Accurate Passes",@"accuratePasses",
                           @"Fouls",@"fouls",nil];
    
    NSArray* myindex = [[NSArray alloc] initWithObjects:
                        @"gameStarted",
                        @"goals",
                        @"assists",
                        @"rating",
                        @"yellow",
                        @"red",
                        @"totalShots",
                        @"shotsOnTarget",
                        @"totalPasses",
                        @"accuratePasses",
                        @"fouls",
                        nil];
    
    CGFloat fontSize = 16.0;
    
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    UIFont *normalFont = [UIFont systemFontOfSize:fontSize];
    
    for (NSString* index in myindex)
    {
        NSString* name = nil;
        name = [[NSString alloc] initWithFormat:@"%@", [[table objectForKey:index] description]];
        NSMutableAttributedString *matName = [[NSMutableAttributedString alloc] initWithString:name];
        NSRange range = [name rangeOfString:name];
        [matName addAttribute:NSFontAttributeName value:boldFont range:range];
        [self.msgListName addObject:matName];
        
        NSString* info = nil;
        info = [[NSString alloc] initWithFormat:@"%@", [[dict objectForKey:index] description]];
        NSMutableAttributedString *matInfo = [[NSMutableAttributedString alloc] initWithString:info];
        NSRange allrange;
        allrange.location = 0;
        allrange.length = [info length];
        [matInfo addAttribute:NSFontAttributeName value:normalFont range:allrange];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell3"];
    cell.textLabel.attributedText = self.msgListName[indexPath.row];
    cell.detailTextLabel.attributedText = self.msgListInfo[indexPath.row];
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
