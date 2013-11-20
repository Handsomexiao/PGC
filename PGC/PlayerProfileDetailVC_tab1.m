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

@property (strong, nonatomic) IBOutlet UIImageView *CountryImage;
@property (strong, nonatomic) IBOutlet UIImageView *ClubImage;
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
    
    dispatch_queue_t queue = dispatch_queue_create("ImageDownloader", NULL);
    dispatch_async(queue, ^{
        NSInteger club_fm_id = [[self.listData objectForKey:@"club_fm_id"] integerValue];
        NSString* urlString = [[NSString alloc] initWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/image/android/club_logo/3.0/%d.png",club_fm_id];
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] options:NSDataReadingMappedIfSafe error:nil];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                    self.ClubImage.image = image;
                    [self.ClubImage updateConstraints];
            });
        }
    });}

-(void)SetDatilText:(NSDictionary*)dict
{
    NSDictionary* table = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      @"Full Name",@"fullName",
                                                      @"Hometown",@"cityOfBirth",
                                                      @"Birthday",@"dateOfBirth",
                                                      @"Nationality",@"nationOfBirthName",
                                                      @"Height",@"height",
                                                      @"Weight",@"weight",
                                                      @"Prefer Foot",@"preferFoot",nil];

    NSArray* myindex = [[NSArray alloc] initWithObjects:
                               @"fullName",
                               @"cityOfBirth",
                               @"dateOfBirth",
                               @"nationOfBirthName",
                               @"height",
                               @"weight",
                               @"preferFoot",
                      nil];
    
    for (NSString* index in myindex) {
        
        NSString* name = nil;
        NSString* info = nil;
        name = [[NSString alloc] initWithFormat:@"%@", [[table objectForKey:index] description]];
        info = [[NSString alloc] initWithFormat:@"%@", [[dict objectForKey:index] description]];
        NSMutableAttributedString *matName = [[NSMutableAttributedString alloc] initWithString:name];
        NSMutableAttributedString *matInfo = [[NSMutableAttributedString alloc] initWithString:info];
        
        //an NSDictionary of NSString => UIColor pairs
        NSRange range = [name rangeOfString:name];
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
