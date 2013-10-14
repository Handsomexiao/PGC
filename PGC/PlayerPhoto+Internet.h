//
//  PlayerPhoto+Internet.h
//  PGC
//
//  Created by Shuai Xiao on 10/8/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerPhoto.h"

@interface PlayerPhoto (Internet)


+(void)photoData:(NSInteger)playerId afterDone:(void (^)(UIImage* image))myblock;
+(NSManagedObjectContext *)useDocument;
@end
