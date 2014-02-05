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
@property (strong, nonatomic) IBOutlet UILabel *OptimalPosition;

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
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Vizoal-background.png"]];
    [tempImageView setFrame:self.view.frame];
    [self.view insertSubview:tempImageView belowSubview:self.view.subviews[0]];
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
        
        [self SetPositionImage:[rec objectForKey:@"name"] efficiency:[rec objectForKey:@"efficiency"]];
        
        if ([[[rec objectForKey:@"efficiency"] description] compare:@"100%"] == NSOrderedSame) {
            self.OptimalPosition.text = [NSString stringWithFormat:@"Optimal Position: %@", [rec objectForKey:@"name"]];
        }
    }
    
    //self.DetailTextView.attributedText = allText;
}

-(void)SetPositionImage:(NSString*)text efficiency:(NSString*)efficiency
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    
    CGRect aRect = CGRectMake(0, 0, 21, 21);
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:aRect];

    if ([efficiency compare:@"100%"] == NSOrderedSame) {
        ImageView.image = [UIImage imageNamed:@"Player-position-icon-1.png"];
    }
    else if ([efficiency compare:@"90%"] == NSOrderedSame) {
        ImageView.image = [UIImage imageNamed:@"Player-position-icon-2.png"];
    }
    else if ([efficiency compare:@"80%"] == NSOrderedSame) {
        ImageView.image = [UIImage imageNamed:@"Player-position-icon-3.png"];
    }
    else if ([efficiency compare:@"70%"] == NSOrderedSame) {
        ImageView.image = [UIImage imageNamed:@"Player-position-icon-4.png"];
    }
    else if ([efficiency compare:@"60%"] == NSOrderedSame) {
        ImageView.image = [UIImage imageNamed:@"Player-position-icon-5.png"];
    }
    
    [self setLocationForView:text LabelView:label imageView:ImageView];
    [self.positionView addSubview:label];
    [self.positionView addSubview:ImageView];
    
    [self updateViewConstraints];
    
}

- (void)setLocationForView:(NSString*)Position LabelView:(UIView *)Label imageView:(UIView*)image
{
    CGRect sinkBounds = CGRectInset(self.positionView.bounds, 0, 0);
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat positionLayer = (int)sinkBounds.size.height/7;
    
    CGFloat leftPosition = sinkBounds.size.width/7;
    CGFloat rightPosition = sinkBounds.size.width - sinkBounds.size.width/7;

    if ([Position compare:@"ST"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width/2;
        y = positionLayer;
    }
    else if ([Position compare:@"AMC"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width/2;
        y = (positionLayer * 2);
    }
    else if ([Position compare:@"MC"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width/2;
        y = (positionLayer * 3);
    }
    else if ([Position compare:@"DMC"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width/2;
        y = (positionLayer * 4);
    }
    else if ([Position compare:@"DC"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width/2;
        y = (positionLayer * 5);
    }
    else if ([Position compare:@"GK"] == NSOrderedSame) {
        x = (int)sinkBounds.size.width/2;
        y = (int)sinkBounds.size.height * 9/10 + 5;
    }
    else if ([Position compare:@"AML"] == NSOrderedSame) {
        x = leftPosition;
        y = (positionLayer * 2);
    }
    else if ([Position compare:@"ML"] == NSOrderedSame) {
        x = leftPosition;
        y = (positionLayer * 3);
    }
    else if ([Position compare:@"WBL"] == NSOrderedSame) {
        x = leftPosition;
        y = (positionLayer * 4);
    }
    else if ([Position compare:@"DL"] == NSOrderedSame) {
        x = leftPosition;
        y = (positionLayer * 5);
    }
    
    else if ([Position compare:@"AMR"] == NSOrderedSame) {
        x = rightPosition;
        y = (positionLayer * 2);
    }
    else if ([Position compare:@"MR"] == NSOrderedSame) {
        x = rightPosition;
        y = (positionLayer * 3);
    }
    else if ([Position compare:@"WBR"] == NSOrderedSame) {
        x = rightPosition;
        y = (positionLayer * 4);
    }
    else if ([Position compare:@"DR"] == NSOrderedSame) {
        x = rightPosition;
        y = (positionLayer * 5);
    }
    else
    {
        Label.hidden = true;
        image.hidden = true;
    }
    
    Label.center = CGPointMake(x, y+21);
    image.center = CGPointMake(x, y);
    NSLog(@"sinkBounds = %f, %@ :x = %d,y = %d",sinkBounds.size.width ,Position,(int)x,(int)y);
}


@end
