//
//  PlayerProfileDetailVC_tab2.m
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileDetailVC_tab2.h"

@interface PlayerProfileDetailVC_tab2 ()

//@property (strong, nonatomic) IBOutlet UITextView *DetailTextView;

@property (strong, nonatomic) IBOutlet UIView *positionView;
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
        
        [self SetPositionImage:[rec objectForKey:@"name"]];
    }
    
    
    //self.DetailTextView.attributedText = allText;
}

-(void)SetPositionImage:(NSString*)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    
    CGRect aRect = CGRectMake(0, 0, 21, 21);
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:aRect];
    UIImage* image = [UIImage imageNamed:@"Player-position-icon-5.png"];
    ImageView.image = image;
    
    //[self setLocationForView:label position:text];
    //[self.positionView addSubview:label];
    
    [self setLocationForView:text LabelView:label imageView:ImageView];
    [self.positionView addSubview:label];
    [self.positionView addSubview:ImageView];
    
    [self updateViewConstraints];
    
}

- (void)setLocationForView:(NSString*)Position LabelView:(UIView *)Label imageView:(UIView*)image
{
    CGRect sinkBounds = CGRectInset(self.positionView.bounds, Label.frame.size.width/2, Label.frame.size.height/2);
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat positionLayer = (int)sinkBounds.size.width/7;
    
    CGFloat leftPosition = sinkBounds.size.height/5;
    CGFloat rightPosition = sinkBounds.size.height - sinkBounds.size.height/5;

    if ([Position compare:@"ST"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width;
        y = (int)sinkBounds.size.height/2;
    }
    else if ([Position compare:@"AMC"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 1);
        y = (int)sinkBounds.size.height/2;
    }
    else if ([Position compare:@"MC"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 2);
        y = (int)sinkBounds.size.height/2;
    }
    else if ([Position compare:@"DMC"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 3);
        y = (int)sinkBounds.size.height/2;
    }
    else if ([Position compare:@"DC"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 4);
        y = (int)sinkBounds.size.height/2;
    }
    else if ([Position compare:@"SW"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 5);
        y = (int)sinkBounds.size.height/2;
    }
    else if ([Position compare:@"GK"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 6);
        y = (int)sinkBounds.size.height/2;
    }
    else if ([Position compare:@"AML"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 1);
        y = leftPosition;
    }
    else if ([Position compare:@"AMR"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 1);
        y = rightPosition;
    }
    else if ([Position compare:@"ML"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 2);
        y = leftPosition;
    }
    else if ([Position compare:@"MR"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 2);
        y = rightPosition;
    }
    else if ([Position compare:@"WBL"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 3);
        y = leftPosition;
    }
    else if ([Position compare:@"WBR"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 3);
        y = rightPosition;
    }
    else if ([Position compare:@"DL"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 4);
        y = leftPosition;
    }
    else if ([Position compare:@"DR"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width - (positionLayer * 4);
        y = rightPosition;
    }
    
    Label.center = CGPointMake(x, y+21);
    image.center = CGPointMake(x, y);
    NSLog(@"sinkBounds = %f, %@ :x = %d,y = %d",sinkBounds.size.width ,Position,(int)x,(int)y);
}

@end
