//
//  PlayerHdPhoto.h
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlayerHdPhoto : NSManagedObject

@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSData * photo;

@end
