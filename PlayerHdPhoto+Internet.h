//
//  PlayerHdPhoto+Internet.h
//  PGC
//
//  Created by Xiao Shuai on 10/13/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerHdPhoto.h"

@interface PlayerHdPhoto (Internet)

+(void)GetPlayerHdPhotoData:(NSInteger)page playerId:(NSInteger)playId afterDone:(void (^)(UIImage *))myblock;

+(NSManagedObjectContext *)useDocument;

@end
