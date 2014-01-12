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

- (NSDictionary *)listData
{
    if (!_listData) {
        _listData = [[NSDictionary alloc] init];
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

    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"player-placeholder2" ofType:@"png"];
    self.Photo.image = [[UIImage alloc] initWithContentsOfFile:thePath];
    
    NSInteger playerFmId = [[dict objectForKey:@"fmId"] integerValue];
    [PlayerPhoto photoData:playerFmId afterDone:^(UIImage* image){
        self.Photo.image = image;
        [self.Photo updateConstraints];
    }];
    
    NSString* name = nil;
    if ([[[dict objectForKey:@"firstName"] description] compare:@""]) {
        name = [[NSString alloc] initWithFormat:@"%@ %@",[[dict objectForKey:@"firstName"] description] ,[[dict objectForKey:@"lastName"] description]];
    }
    else
    {
        name = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"lastName"]];
    }
    
    self.title = name;
    
    self.name.text = name;
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
    
    UISwipeGestureRecognizer *SwipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NextView)];
    SwipGesture.numberOfTouchesRequired = 1;
    SwipGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:SwipGesture];
    
}

-(void)NextView
{
    NSUInteger controllerIndex = self.tabBarController.selectedIndex + 1;
    if (controllerIndex >= 4) {
        controllerIndex = 0;
    }
    
    // Get views. controllerIndex is passed in as the controller we want to go to.
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:controllerIndex] view];

    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(controllerIndex > self.tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCrossDissolve : UIViewAnimationOptionTransitionFlipFromRight)
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.tabBarController.selectedIndex = controllerIndex;
                        }
                    }];
    
    NSLog(@"NextView! %d",controllerIndex);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startRequest
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.vizoal.com/vizoal/services/player/%ld",(long)self.PlayerFmId]];
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
