//
//  playerProfileDetailTBC.m
//  PGC
//
//  Created by Shuai Xiao on 10/7/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "playerProfileDetailTBC.h"
#import "PlayerProfileVC.h"

@interface playerProfileDetailTBC ()

@end

@implementation playerProfileDetailTBC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)A:(id)sender
{
    // code here
    NSLog(@"select a");
}

- (IBAction)B:(id)sender
{
    // code here
    NSLog(@"select b");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    for (UIViewController* Vc in self.childViewControllers) {
        if([Vc isKindOfClass:[PlayerProfileVC class]])
        {
            PlayerProfileVC* plays = (PlayerProfileVC*)Vc;
            plays.playerFmId = self.playerFmId;
        }
    }
    
    UIBarButtonItem *AButton = [[UIBarButtonItem alloc] initWithTitle:@"A" style:UIBarButtonItemStyleBordered target:self action:@selector(A:)];
    UIBarButtonItem *BButton = [[UIBarButtonItem alloc] initWithTitle:@"B" style:UIBarButtonItemStyleBordered target:self action:@selector(B:)];
    
    self.navigationItem.rightBarButtonItems = @[AButton, BButton];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
