//
//  playerProfileDetailTBC.m
//  PGC
//
//  Created by Shuai Xiao on 10/7/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "playerProfileDetailTBC.h"
#import "PlayerProfileVC.h"
#import "APActivityProvider.h"
#import "APActivityIcon.h"


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

- (IBAction)Share:(id)sender
{
    // code here
    NSLog(@"select a");
    
    APActivityProvider *ActivityProvider = [[APActivityProvider alloc] init];
    UIImage *ImageAtt = [UIImage imageNamed:@"country-placeholder.png"];
    NSArray *Items = @[ActivityProvider, ImageAtt];
    
    APActivityIcon *ca = [[APActivityIcon alloc] init];
    NSArray *Acts = @[ca];
    
    UIActivityViewController *ActivityView = [[UIActivityViewController alloc]
                                               initWithActivityItems:Items
                                               applicationActivities:Acts];
    [ActivityView setExcludedActivityTypes:
     @[UIActivityTypeAssignToContact,
       UIActivityTypeCopyToPasteboard,
       UIActivityTypePrint,
       UIActivityTypeSaveToCameraRoll,
       UIActivityTypePostToWeibo]];
    
    [self presentViewController:ActivityView animated:YES completion:nil];
    [ActivityView setCompletionHandler:^(NSString *act, BOOL done)
     {
         NSString *ServiceMsg = nil;
         if ( [act isEqualToString:UIActivityTypeMail] )           ServiceMsg = @"Mail sended!";
         if ( [act isEqualToString:UIActivityTypePostToTwitter] )  ServiceMsg = @"Post on twitter, ok!";
         if ( [act isEqualToString:UIActivityTypePostToFacebook] ) ServiceMsg = @"Post on facebook, ok!";
         if ( [act isEqualToString:UIActivityTypeMessage] )        ServiceMsg = @"SMS sended!";
         if ( done )
         {
             UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:ServiceMsg message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
             [Alert show];
         }
     }];
    
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
    
    
    UIBarButtonItem *AButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                               target:self
                                                               action:@selector(Share:)];
    UIBarButtonItem *BButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(B:)];
    
    self.navigationItem.rightBarButtonItems = @[AButton,BButton];    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
