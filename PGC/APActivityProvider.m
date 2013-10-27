//
//  APActivityProvider.m
//  PGC
//
//  Created by Shuai Xiao on 10/27/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "APActivityProvider.h"

@implementation APActivityProvider

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
        return @"This is a #twitter post!";
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return @"This is a facebook post!";
    if ( [activityType isEqualToString:UIActivityTypeMessage] )
        return @"SMS message text";
    if ( [activityType isEqualToString:UIActivityTypeMail] )
        return @"Email text here!";
    if ( [activityType isEqualToString:@"it.albertopasca.myApp"] )
        return @"OpenMyapp custom text";
    return nil;
}
- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController { return @""; }

@end
