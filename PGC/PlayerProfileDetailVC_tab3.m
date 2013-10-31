//
//  PlayerProfileDetailVC_tab3.m
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileDetailVC_tab3.h"

@interface PlayerProfileDetailVC_tab3 ()
@property (weak, nonatomic) IBOutlet UITextView *DetailTextView;

@end

@implementation PlayerProfileDetailVC_tab3

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
    clubRecord = [dict objectForKey:@"playerClubRecordList"];
    
    NSMutableAttributedString* allText = [[NSMutableAttributedString alloc] init];

    for (NSDictionary* rec in clubRecord) {
        NSString* name = nil;
        name = [[NSString alloc] initWithFormat:@"%@ : %@  -> %@\n", [[rec objectForKey:@"clubName"] description],[[rec objectForKey:@"seasonFrom"] description],[[rec objectForKey:@"seasonEnd"] description]];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:name];
        
        //an NSDictionary of NSString => UIColor pairs
        NSRange range = [name rangeOfString:[rec objectForKey:@"clubName"]];
        CGFloat fontSize = 18.0;
        UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
        //[mat setAttributes:subAttrs range:range];
        [mat addAttribute:NSFontAttributeName value:boldFont range:range];
        
        [allText appendAttributedString:mat];
    }

    
    self.DetailTextView.attributedText = allText;
}
@end
