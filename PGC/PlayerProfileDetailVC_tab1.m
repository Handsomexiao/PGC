//
//  PlayerProfileDetailVC.m
//  PGC
//
//  Created by Shuai Xiao on 10/7/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileDetailVC_tab1.h"

@interface PlayerProfileDetailVC_tab1 () <UITableViewDataSource, UIGestureRecognizerDelegate>
@property (strong,nonatomic) NSMutableArray* msgListName;
@property (strong,nonatomic) NSMutableArray* msgListInfo;

@property (strong, nonatomic) IBOutlet UIImageView *CountryImage;
@property (strong, nonatomic) IBOutlet UIImageView *ClubImage;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

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
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Vizoal-background.png"]];
    [tempImageView setFrame:self.view.frame];
    [self.view insertSubview:tempImageView belowSubview:self.view.subviews[0]];
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


-(void)SetDatilText:(NSDictionary*)dict
{
    NSDictionary* table = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      @"Full Name",@"fullName",
                                                      @"Hometown",@"cityOfBirth",
                                                      @"Age",@"Age",
                                                      @"Birthday",@"dateOfBirth",
                                                      @"Nationality",@"nationOfBirthName",
                                                      @"Height",@"height",
                                                      @"Weight",@"weight",
                                                      @"Strong Foot",@"preferFoot",
                                                      @"Number",@"clubNumber",nil];

    NSArray* myindex = [[NSArray alloc] initWithObjects:
                               @"fullName",
                               @"cityOfBirth",
                               @"Age",
                               @"dateOfBirth",
                               @"nationOfBirthName",
                               @"height",
                               @"weight",
                               @"preferFoot",
                               @"clubNumber",
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
        
        if ([index  compare:@"Age"]  != NSOrderedSame)
        {
            NSString* info = nil;
            info = [[NSString alloc] initWithFormat:@"%@", [[dict objectForKey:index] description]];
            NSMutableAttributedString *matInfo = [[NSMutableAttributedString alloc] initWithString:info];
            NSRange allrange;
            allrange.location = 0;
            allrange.length = [info length];
            [matInfo addAttribute:NSFontAttributeName value:normalFont range:allrange];
            [self.msgListInfo addObject:matInfo];
        }
        else
        {
            NSString* info = nil;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *birthday = [dateFormatter dateFromString:[dict objectForKey:@"dateOfBirth"]];
            NSDate *now = [[NSDate alloc] init];
            NSLog(@"cur: %@, birth: %@",now,birthday);
            
            NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                               components:NSYearCalendarUnit
                                               fromDate:birthday
                                               toDate:now
                                               options:0];
            NSInteger age = [ageComponents year];
            
            info = [[NSString alloc] initWithFormat:@"%ld", (long)age ];
            NSMutableAttributedString *matInfo = [[NSMutableAttributedString alloc] initWithString:info];
            NSRange allrange;
            allrange.location = 0;
            allrange.length = [info length];
            [matInfo addAttribute:NSFontAttributeName value:normalFont range:allrange];
            [self.msgListInfo addObject:matInfo];
        }

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
