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
#import "PlayerHdPhoto+Internet.h"


@interface PGCViewController ()

@property (nonatomic)  NSInteger currentPage;

@property (weak, nonatomic) IBOutlet UINavigationItem *Navigation;


//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

@end

@implementation PGCViewController

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // load our data from a plist file inside our app bundle
    
    [self startHomepageRequest];

    
    // a page is the width of the scroll view
    self.scrollView.contentSize = CGSizeMake(INT32_MAX, SCREEN_HEIGHT);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    
    self.visiblePages = [[NSMutableDictionary alloc] init];
    self.recyledPages = [[NSMutableSet alloc] init];
    
    self.pageControl.numberOfPages = self.listData.count;
    self.currentPage = 0;
    
    lastPage = 0;

    [self tilesPage];
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    self.pageControl.currentPage = currentPage;
    [self loadScrollViewWithPage:currentPage];
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.listData.count)
        return;

    NSMutableDictionary* dict = [self.listData objectAtIndex:page];
    
    NSInteger playId = [[dict objectForKey:@"playId"] integerValue];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFade;
    [self.ImageView.layer addAnimation:transition forKey:nil];
    
    [PlayerHdPhoto GetPlayerHdPhotoData:page playerId:playId afterDone:^(UIImage* image){
        UIImageView* view = [[UIImageView alloc] initWithImage:image];
        [self.ImageView removeFromSuperview];
        [self.ImageView addSubview:view];
        [self.ImageView setNeedsLayout];
    }];
    
    self.ImageTitle.text = [dict objectForKey:@"name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startHomepageRequest
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
                                           
                                           [self loadAllImage];
                                       });
                                   }
                               }
                           }];
    
}
-(void)loadAllImage
{
    self.imageArray = [[NSMutableArray alloc] init];
    for (int page=1; page<= self.listData.count; page++) {
        NSMutableDictionary* dict = [self.listData objectAtIndex:(page-1)];
        NSInteger playerId = [[dict objectForKey:@"playerId"] integerValue];
        
        [PlayerHdPhoto GetPlayerHdPhotoData:page playerId:playerId afterDone:^(UIImage* image){
            if (nil != image) {
                [self.imageArray addObject:image];
            }
            else {
                NSLog(@"image is nil");
            }
        }];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self tilesPage];
}



-(void)tilesPage {
    int currentPage = floor(self.scrollView.contentOffset.x / SCREEN_WIDTH);
    if (currentPage == 0 && lastPage == 0) {
        if([self.imageArray objectAtIndex:0] != nil)
        {
            UIImageView *firstImageView = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:0]];
            firstImageView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
            [self.scrollView addSubview:firstImageView];
            [self.visiblePages setValue:firstImageView forKey:[NSString stringWithFormat:@"%i", 0]];
        
            UIImageView *secondImageView = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:1]];
            secondImageView.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
            [self.scrollView addSubview:secondImageView];
            [self.visiblePages setValue:secondImageView forKey:[NSString stringWithFormat:@"%i", 1]];
        }
    }
    else {
        if (currentPage == lastPage) {
            return;
        }
        if (currentPage > lastPage) {
            //forward
            if (currentPage * SCREEN_WIDTH < INT32_MAX) {
                UIImage *image = [self.imageArray objectAtIndex:(currentPage + 1)% self.listData.count];
                UIImageView *imageView = [self getRecyledImageView:image];
                if (nil == imageView) {
                    imageView = [[UIImageView alloc] initWithImage:image];
                }
                imageView.frame = CGRectMake((currentPage + 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                [self.scrollView addSubview:imageView];
                [self.visiblePages setValue:imageView forKey:[NSString stringWithFormat:@"%i", currentPage + 1]];
            }
            
            NSString *key = [NSString stringWithFormat:@"%i", currentPage - 2];
            UIImageView *recyledImageView = [self.visiblePages objectForKey:key];
            if (nil != recyledImageView) {
                [self.recyledPages addObject:recyledImageView];
                [recyledImageView removeFromSuperview];
                [self.visiblePages removeObjectForKey:key];
            }
        }
        else {
            //backward
            if (currentPage > 0) {
                UIImage *image = [self.imageArray objectAtIndex:(currentPage - 1) % self.listData.count];
                UIImageView *imageView = [self getRecyledImageView:image];
                if (nil == imageView) {
                    imageView = [[UIImageView alloc] initWithImage:image];
                }
                imageView.frame = CGRectMake((currentPage - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                [self.scrollView addSubview:imageView];
                [self.visiblePages setValue:imageView forKey:[NSString stringWithFormat:@"%i", currentPage - 1]];
            }
            
            NSString *key = [NSString stringWithFormat:@"%i", currentPage + 2];
            UIImageView *recyledImageView = [self.visiblePages objectForKey:key];
            if (nil != recyledImageView) {
                [self.recyledPages addObject:recyledImageView];
                [recyledImageView removeFromSuperview];
                [self.visiblePages removeObjectForKey:key];
            }
        }
    }
    
    lastPage = currentPage;
    NSLog(@"visible count is %i and recyle count is %i", self.visiblePages.count, self.recyledPages.count);
    if (self.listData) {
        [self.pageControl setCurrentPage:currentPage % self.listData.count];
    }
    else
    {
        [self.pageControl setCurrentPage:0];
    }
    
}

-(UIImageView*)getRecyledImageView:(UIImage*)image {
    UIImageView *imageView = [self.recyledPages anyObject];
    if (nil != imageView) {
        imageView.image = image;
        [self.recyledPages removeObject:imageView];
    }
    return imageView;
}

@end
