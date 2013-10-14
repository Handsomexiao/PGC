//
//  PlayerHdPhoto+Internet.m
//  PGC
//
//  Created by Xiao Shuai on 10/13/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerHdPhoto+Internet.h"

@implementation PlayerHdPhoto (Internet)

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

+(void)GetPlayerHdPhotoData:(NSInteger)page playerId:(NSInteger)playId afterDone:(void (^)(UIImage *))myblock
{
    NSData* photoData = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlayerHdPhoto"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"playerId"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"page = %d",page];
    NSError *error = nil;
    NSArray *matches = [[self useDocument] executeFetchRequest:request
                                                         error:&error];
    
    if (matches || ([matches count] > 1)) {
        // handle error
    } else if (!matches || ![matches count]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/image/android/homepage/hdRez/%d.png",page]];
        NSLog(@"new get playerHdPhoto--%@",url);
        
        dispatch_async(kBgQueue, ^{
            NSData* NewphotoData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([NewphotoData length] > 0) {
                    //write to datebase
                    PlayerHdPhoto* playerPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"PlayerHdPhoto"
                                                                             inManagedObjectContext:[self useDocument]];
                    
                    playerPhoto.photo = NewphotoData;
                    playerPhoto.page = [[NSNumber alloc] initWithInt:page];
                    playerPhoto.playerId = [[NSNumber alloc] initWithInt:playId];
                    UIImage* image = [[UIImage alloc] initWithData:NewphotoData];
                    // reflash view
                    myblock(image);
                }
            });
            
        });
    } else {
        photoData = [[matches lastObject] photo];
        UIImage* image = [[UIImage alloc] initWithData:photoData];
        NSLog(@"reuse playerHdPhoto--%ld",(long)page);
        dispatch_async(dispatch_get_main_queue(), ^{
            // reflash view
            myblock(image);
        });
    }
    
    return;
}

+ (NSManagedObjectContext *)useDocument
{
    static NSManagedObjectContext *managedObjectContext = nil;
    if (!managedObjectContext) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Demo Document"];
        
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [document saveToURL:url
               forSaveOperation:UIDocumentSaveForCreating
              completionHandler:^(BOOL success) {
                  managedObjectContext = document.managedObjectContext;
              }];
        } else if (document.documentState == UIDocumentStateClosed) {
            [document openWithCompletionHandler:^(BOOL success) {
                managedObjectContext = document.managedObjectContext;
            }];
        } else {
            managedObjectContext = document.managedObjectContext;
        }
    }
    
    return managedObjectContext;
}
@end
