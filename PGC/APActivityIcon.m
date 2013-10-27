//
//  APActivityIcon.m
//  PGC
//
//  Created by Shuai Xiao on 10/27/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "APActivityIcon.h"

@implementation APActivityIcon
- (NSString *)activityType { return @"it.albertopasca.myApp"; }
- (NSString *)activityTitle { return @"Open Maps"; }
- (UIImage *) activityImage { return [UIImage imageNamed:@"country-placeholder.png"]; }
- (BOOL) canPerformWithActivityItems:(NSArray *)activityItems { return YES; }
- (void) prepareWithActivityItems:(NSArray *)activityItems { }
- (UIViewController *) activityViewController { return nil; }
- (void) performActivity {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"maps://"]];
}
@end
