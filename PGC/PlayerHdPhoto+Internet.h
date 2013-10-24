//
//  PlayerHdPhoto+Internet.h
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerHdPhoto.h"

@interface PlayerHdPhoto (Internet)

+(void)photoHdData:(NSInteger)page afterDone:(void (^)(UIImage* image))myblock;
+(NSManagedObjectContext *)useDocument;
+(void)GetAllPlayerHdPhoto:(NSArray *)lastData afterDone:(void (^)(void))myblock;

@end
