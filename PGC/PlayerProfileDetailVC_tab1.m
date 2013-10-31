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
    //self.DetailTextView.text = [NSString stringWithFormat:@"%@",self.listData];
    [self SetDatilText:self.listData];
}

-(void)SetDatilText:(NSDictionary*)dict
{
    NSDictionary* table = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"fullName",@"Full Name",
                           @"cityOfBirth",@"Place of Birth",
                           @"dateOfBirth",@"Date of Birth",
                           @"nationOfBirthName",@"Nationality",
                           @"height",@"Height",
                           @"weight",@"Weight",
                           @"preferFoot",@"Prefer Foot",nil];
    NSMutableAttributedString* allText = [[NSMutableAttributedString alloc] init];
    
    NSArray* allkey = [table allKeys];
    for (NSString* key in allkey) {
        NSString* name = nil;

        name = [[NSString alloc] initWithFormat:@"%@ : %@ \n", key ,[dict objectForKey:[[table objectForKey:key] description]]];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:name];

        //an NSDictionary of NSString => UIColor pairs
        NSRange range = [name rangeOfString:key];
        CGFloat fontSize = 18.0;
        UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
        //[mat setAttributes:subAttrs range:range];
        [mat addAttribute:NSFontAttributeName value:boldFont range:range];
        
        [allText appendAttributedString:mat];
    }
    
    self.DetailTextView.attributedText = allText;

    
}

@end
