//
//  PGCViewController.m
//  PGC
//
//  Created by Shuai Xiao on 10/1/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PGCViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ClubTVC.h"
#import "TopPlayersTVC.h"


@interface PGCViewController ()

@property (nonatomic)  NSInteger currentPage;

@property (weak, nonatomic) IBOutlet UINavigationItem *Navigation;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *SwipeRight;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *SwipeLeft;

//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

@end

@implementation PGCViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        static NSString *CellIdentifier = @"FirstSelect1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSLog(@"Top Player OK");
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"FirstSelect2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSLog(@"Brower OK");
        return cell;
    }
    
    return nil;
}
- (IBAction)MoreAction:(UIBarButtonItem *)sender {
    
    UIActionSheet *styleAlert = [[UIActionSheet alloc] initWithTitle:@"More Action:"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"LogIn",
                                 @"Setting",
                                 nil,
                                 nil];
	
	// use the same style as the nav bar
	styleAlert.actionSheetStyle = (UIActionSheetStyle)self.navigationController.navigationBar.barStyle;
	
	[styleAlert showInView:self.view];
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    self.pageControl.currentPage = currentPage;
    [self loadScrollViewWithPage:currentPage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // load our data from a plist file inside our app bundle
    
    [self startRequest];

    
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.listData.count, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    
    
    self.pageControl.numberOfPages = self.listData.count;
    self.currentPage = 1;
    
    self.SwipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.SwipeRight];
    
    self.SwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.SwipeLeft];
}

static NSString *kNameKey = @"nameKey";
static NSString *kImageKey = @"imageKey";

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.listData.count)
        return;

    NSMutableDictionary* dict = [self.listData objectAtIndex:page];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.02f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.ImageView.layer addAnimation:transition forKey:nil];
    
    self.ImageView.image = [[UIImage alloc] initWithData:[self GetPlayerPhoto:(page+1)]];
    self.ImageTitle.text = [dict objectForKey:@"name"];
}

-(NSData *)GetPlayerPhoto:(NSInteger)playerId
{
    NSString* urlString = [[NSString alloc] initWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/image/android/homepage/medRez/%d.png",playerId];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Data has loaded successfully.");
    }
    
    return data;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SwipeImage:(UISwipeGestureRecognizer *)sender {
    if (sender == self.SwipeRight) {
        NSInteger i = self.currentPage;
        i = i + 1;
        i = i % self.listData.count;
        self.currentPage = i;
        NSLog(@"Right. currentPage = %ld",(long)self.currentPage);
    }
    else
    {
        NSInteger i = self.currentPage;
        i = i - 1;
        i = i % self.listData.count;
        self.currentPage = i;
        NSLog(@"Left. currentPage = %ld",(long)self.currentPage);
    }

}

-(void)startRequest
{
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/services/player/homepage"];
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
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           // need to do
                                           self.pageControl.numberOfPages = self.listData.count;
                                           self.currentPage = 0;
                                       });
                                   }
                               }
                           }];
    
}


@end
