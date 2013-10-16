//
//  PlayerProfileDetailVC.m
//  PGC
//
//  Created by Shuai Xiao on 10/7/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileDetailVC_tab1.h"

@interface PlayerProfileDetailVC_tab1 ()
@property (weak, nonatomic) IBOutlet UITextView *DetailTextView;

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

-(void)moreInfo
{
    self.DetailTextView.text = [NSString stringWithFormat:@"%@",self.listData];
}

@end
