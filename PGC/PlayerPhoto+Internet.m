//
//  PlayerPhoto+Internet.m
//  PGC
//
//  Created by Shuai Xiao on 10/8/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerPhoto+Internet.h"

@implementation PlayerPhoto (Internet)

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

+(void)photoData:(NSInteger)playerId afterDone:(void (^)(UIImage *))myblock
{
    NSData* photoData = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlayerPhoto"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"playerId"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"playerId = %d",playerId];
    NSError *error = nil;
    NSArray *matches = [[self useDocument] executeFetchRequest:request
                                              error:&error];
    
    if (!matches || [matches count] != 1) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/image/android/player/2.0/%d.png",playerId]];
        NSLog(@"new get playerPhoto--%@",url);
        
        dispatch_async(kBgQueue, ^{
            NSData* NewphotoData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([NewphotoData length] > 0) {
                    //write to datebase
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlayerPhoto"];
                    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"playerId"
                                                                              ascending:YES]];
                    request.predicate = [NSPredicate predicateWithFormat:@"playerId = %d",playerId];
                    NSError *error = nil;
                    NSArray *matches = [[self useDocument] executeFetchRequest:request
                                                                         error:&error];
                    if (matches) {
                        for (id d in matches) {
                            [[self useDocument] deleteObject:d];
                        }
                    }
                    
                    PlayerPhoto* playerPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"PlayerPhoto"
                                                                             inManagedObjectContext:[self useDocument]];
                    
                    playerPhoto.photo = NewphotoData;
                    playerPhoto.playerId = [[NSNumber alloc] initWithInt:playerId];
                    
                    UIImage* image = [[UIImage alloc] initWithData:NewphotoData];
                    // reflash view
                    myblock(image);
                }
            });
        
        });
    } else {
        photoData = [[matches lastObject] photo];
        UIImage* image = [[UIImage alloc] initWithData:photoData];
        NSLog(@"reuse playerPhoto--%ld",(long)playerId);
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
            NSLog(@"new NSManagedObjectContext!");
        } else if (document.documentState == UIDocumentStateClosed) {
            [document openWithCompletionHandler:^(BOOL success) {
                managedObjectContext = document.managedObjectContext;
            }];
            NSLog(@"a closed NSManagedObjectContext! reopen");
        } else {
            managedObjectContext = document.managedObjectContext;
            
            NSLog(@"reused NSManagedObjectContext!");
        }
    }
    
    return managedObjectContext;
}



@end
