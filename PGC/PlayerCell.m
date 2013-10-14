//
//  PlayerCell.m
//  TVTest
//
//  Created by Shuai Xiao on 9/30/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerCell.h"

@implementation PlayerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)getPlayerPhoto
{
    dispatch_queue_t queue = dispatch_queue_create("ImageDownloader", NULL);
    
    dispatch_async(queue, ^{
        NSInteger player_fm_id = self.playerFmId;
        NSString* urlString = [[NSString alloc] initWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/image/android/player/2.0/%d.png",player_fm_id];
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] options:NSDataReadingMappedIfSafe error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:[[UIImage alloc] initWithData:imageData]];
        });
    });
}

@end
