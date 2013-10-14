//
//  PlayerProfileVC.m
//  PGC
//
//  Created by Shuai Xiao on 10/1/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileVC.h"
#import "PlayerPhoto+Internet.h"

@interface PlayerProfileVC ()

@property (weak, nonatomic) IBOutlet UIImageView *Photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *country;
@property (weak, nonatomic) IBOutlet UILabel *clubName;

@end

@implementation PlayerProfileVC

- (NSMutableArray *)listData
{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)reflish
{
	// Do any additional setup after loading the view.
    NSMutableDictionary* dict = (NSMutableDictionary*)self.listData;
    
    if (dict == nil) {
        return;
    }
    
    // Configure the cell...

    NSInteger playerFmId = [[dict objectForKey:@"fmId"] integerValue];
    [PlayerPhoto photoData:playerFmId afterDone:^(UIImage* image){
        self.Photo.image = image;
    }];
    
    self.name.text = [dict objectForKey:@"fullName"];
    self.country.text = [dict objectForKey:@"nationOfBirthName"];
    self.clubName.text = [dict objectForKey:@"currentClubName"];
    
    [self moreInfo];
}

-(void)moreInfo
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startRequest
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/services/player/%d",self.PlayerFmId]];
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
                                   [self reflish];
                               });
                           }];
    
}


@end
