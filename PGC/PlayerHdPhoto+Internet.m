//
//  PlayerHdPhoto+Internet.m
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerHdPhoto+Internet.h"

@implementation PlayerHdPhoto (Internet)


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

+(void)photoHdData:(NSInteger)page afterDone:(void (^)(UIImage *))myblock
{
    NSData* photoData = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlayerHdPhoto"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"page"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"page = %d",page];
    NSError *error = nil;
    NSArray *matches = [[self useDocument] executeFetchRequest:request
                                                         error:&error];
    
    if (!matches || ([matches count] > 1) || [matches count] == 0) {
        // handle error
        NSLog(@"not in database--%ld",(long)page);
    } else if([matches count] == 1){
        photoData = [[matches lastObject] photo];
        UIImage* image = [[UIImage alloc] initWithData:photoData];
        NSLog(@"reuse playerHdPhoto--%ld",(long)page);
        // reflash view
        myblock(image);
    }
    
    return;
}

+(void)GetAllPlayerHdPhoto:(NSArray *)lastData afterDone:(void (^)(void))myblock
{
    NSInteger page = 0;
    for (NSDictionary *dict in lastData) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/image/android/homepage/medRez/%@",[dict objectForKey:@"image"]]];
        NSLog(@"new get playerHdPhoto--%@",url);
        dispatch_async(kBgQueue, ^{
            NSData* NewphotoData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([NewphotoData length] > 0) {
                    //write to datebase
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlayerHdPhoto"];
                    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"page"
                                                                              ascending:YES]];
                    request.predicate = [NSPredicate predicateWithFormat:@"page = %d",page];
                    NSError *error = nil;
                    NSArray *matches = [[self useDocument] executeFetchRequest:request
                                                                         error:&error];
                    if ([matches count] >= 1) {
                        for (id d in matches) {
                            [[self useDocument] deleteObject:d];
                        }
                    }
                    
                    PlayerHdPhoto* playerPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"PlayerHdPhoto"
                                                                               inManagedObjectContext:[self useDocument]];
                    
                    playerPhoto.photo = NewphotoData;
                    playerPhoto.page = [[NSNumber alloc] initWithInt:page];
                    
                    NSLog(@"get playerHdPhoto ok--%d",page);
                    
                    [[self useDocument] save:nil];
                    myblock();
                }
            });
        });
        
        page++;
    }

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
