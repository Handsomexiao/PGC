//
//  PlayerProfileDetailVC_tab4.m
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileDetailVC_tab4.h"
@interface PlayerProfileDetailVC_tab4 ()
@property (strong, nonatomic) IBOutlet UIView *commitView;
@end

@implementation PlayerProfileDetailVC_tab4

#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
}



#pragma mark - View lifecycle
- (UIView *)commitView
{
    if(!_commitView) _commitView = [[UIView alloc] init];
    
    return _commitView;
}

- (UIView*)getCommitView
{
    return self.commitView;
}

- (NSMutableArray*)commitMessages
{
    if(!_commitMessages) _commitMessages = [[NSMutableArray alloc] init];
    
    return _commitMessages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"Messages";
    
//    self.messages = [[NSMutableArray alloc] initWithObjects:
//                     @"Testing some messages here.",
//                     @"Options for avatars: none, circles, or squares",
//                     @"This is a complete re-write and refactoring.",
//                     @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!",
//                     nil];

    
    self.timestamps = [[NSMutableArray alloc] initWithObjects:
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate date],
                       nil];
    
    [self getCommit];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
    //                                                                                       target:self
    //                                                                                       action:@selector(buttonPressed:)];
}

- (void)buttonPressed:(UIButton*)sender
{
    // Testing pushing/popping messages view
    //DemoViewController *vc = [[DemoViewController alloc] initWithNibName:nil bundle:nil];
    //[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.commitMessages isKindOfClass:[NSMutableArray class]]) {
        if (self.commitMessages) {
            return self.commitMessages.count;
        }
    }
    return 0;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    NSArray *keys = [NSArray arrayWithObjects:@"playerId", @"userName", @"comment",nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (long)self.PlayerFmId], @"Handsome", text ,nil];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
    [mutaArray addObjectsFromArray:self.commitMessages];
    [mutaArray addObject:jsonDictionary];
    self.commitMessages = mutaArray;
    
    //[self.timestamps addObject:[NSDate date]];
    
    if((self.commitMessages.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self finishSend];
    
    // add commit
    [self addCommit:text];
    
    [self.inputToolBarView removeFromSuperview];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageTypeIncoming;//(indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleSquare;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyNone;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleNone;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dict = self.commitMessages[indexPath.row];
    
    
    return [NSString stringWithFormat:@"%@: \n %@ \n %@" ,[dict objectForKey:@"userName"],[dict objectForKey:@"comment"],[dict objectForKey:@"post_date"]];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dict = self.commitMessages[indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[dict objectForKey:@"post_date"]];
    
    return date;
}

- (UIImage *)avatarImageForIncomingMessage
{
    return nil;
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return nil;
}

-(void)getCommit
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/services/playerComment/%ld",(long)self.PlayerFmId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    
    NSLog(@"%@",url);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([data length] > 0 && connectionError == nil)
                               {
                                   NSLog(@"request finished");
                                   
                                   NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                   NSNumber *resultCodeObj = [resDic objectForKey:@"ResultCode"];
                                   
                                   NSLog(@"%@", resDic);
                                   
                                   if ([resultCodeObj integerValue] >=0)
                                   {
                                       self.commitMessages = [resDic objectForKey:@"result"];

                                       NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self.commitMessages count]];
                                       NSEnumerator *enumerator = [self.commitMessages reverseObjectEnumerator];
                                       for (id element in enumerator) {
                                           [array addObject:element];
                                       }
                                       
                                       self.commitMessages = array;
                                       
                                       if (![self.commitMessages isKindOfClass:[NSMutableArray class]])
                                       {
                                           self.commitMessages = nil;
                                       }

                                   }
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView reloadData];
                               });
                           }];
    
    
}


-(void)addCommit:(NSString *)text
{
    NSArray *keys = [NSArray arrayWithObjects:@"playerId", @"userName", @"comment",nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (long)self.PlayerFmId], @"Handsome", text ,nil];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSData *jsonData ;
    NSString *jsonString;
    if([NSJSONSerialization isValidJSONObject:jsonDictionary])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *requestString = [NSString stringWithFormat:
                               @"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/services/playerComment"];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    NSLog(@"request is %@", request);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([data length] > 0 && connectionError == nil)
                               {
                                   NSLog(@"request finished");
                                   
                                   NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                   NSNumber *resultCodeObj = [resDic objectForKey:@"ResultCode"];
                                   
                                   NSLog(@"%@", resDic);
                                   
                                   if ([resultCodeObj integerValue] >=0)
                                   {
                                       //self.commitMessages = [resDic objectForKey:@"result"];
                                   }
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView reloadData];
                               });
                           }];
    
    
}

@end
