//
//  PlayerHdPhoto.h
//  PGC
//
//  Created by Xiao Shuai on 10/13/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlayerHdPhoto : NSManagedObject

@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * playerId;
@property (nonatomic, retain) NSNumber * page;

@end
