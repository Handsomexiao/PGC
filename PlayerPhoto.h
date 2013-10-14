//
//  PlayerPhoto.h
//  PGC
//
//  Created by Shuai Xiao on 10/8/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlayerPhoto : NSManagedObject

@property (nonatomic, retain) NSNumber * playerId;
@property (nonatomic, retain) NSData * photo;


@end
