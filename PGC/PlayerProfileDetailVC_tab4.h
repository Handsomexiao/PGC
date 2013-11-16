//
//  PlayerProfileDetailVC_tab4.h
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileVC.h"
#import "JSMessagesViewController.h"

@interface PlayerProfileDetailVC_tab4 : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;

@end
