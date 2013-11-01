//
//  PlayerProfileDetailVC_tab2.m
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileDetailVC_tab2.h"

@interface PlayerProfileDetailVC_tab2 ()

@property (strong, nonatomic) IBOutlet UITextView *DetailTextView;
@end

@implementation PlayerProfileDetailVC_tab2

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
    NSArray* clubRecord = [[NSArray alloc] init];
    clubRecord = [dict objectForKey:@"playerPositionList"];
    
    NSMutableAttributedString* allText = [[NSMutableAttributedString alloc] init];
    
    for (NSDictionary* rec in clubRecord) {
        NSString* name = nil;
        name = [[NSString alloc] initWithFormat:@"%@ : %@ \n", [[rec objectForKey:@"name"] description],[[rec objectForKey:@"efficiency"] description]];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:name];
        
        //an NSDictionary of NSString => UIColor pairs
        NSRange range = [name rangeOfString:[rec objectForKey:@"name"]];
        CGFloat fontSize = 18.0;
        UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
        //[mat setAttributes:subAttrs range:range];
        [mat addAttribute:NSFontAttributeName value:boldFont range:range];
        
        [allText appendAttributedString:mat];
    }
    
    
    self.DetailTextView.attributedText = allText;
}

@end
