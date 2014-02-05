//
//  PlayerProfileDetailVC_tab4.m
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileDetailVC_tab4.h"
#import "PlayerPhoto+Internet.h"
@interface PlayerProfileDetailVC_tab4 ()
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *OptimalPosition;
@property (weak, nonatomic) IBOutlet UIImageView *Photo;
@end

@implementation PlayerProfileDetailVC_tab4



#pragma mark - View lifecycle

- (NSMutableArray*)commitMessages
{
    if(!_commitMessages) _commitMessages = [[NSMutableArray alloc] init];
    
    return _commitMessages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Vizoal-background.png"]];
    [tempImageView setFrame:self.view.frame];
    [self.view insertSubview:tempImageView belowSubview:self.view.subviews[0]];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"Messages";

    
    self.timestamps = [[NSMutableArray alloc] initWithObjects:
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate date],
                       nil];
    
    [self getCommit];
    
    [self startRequest];
    
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
    NSArray *keys = [NSArray arrayWithObjects:@"playerId", @"userName", @"comment",@"playerCommentId",@"post_date",nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (long)self.PlayerFmId], @"Handsome", text ,@"0",[[[NSDate alloc ] init] description], nil];
    
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
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageTypeIncoming;//(indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JSBubbleMediaTypeText;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyAll;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyNone;
}
- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleCircle;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
    return JSInputBarStyleFlat;
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

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(void)getCommit
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.vizoal.com/vizoal/services/playerComment/%ld",(long)self.PlayerFmId]];
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
                                       self.commitMessages = [[resDic objectForKey:@"result"] objectForKey:@"playerCommentList"];

                                       if (![self.commitMessages isKindOfClass:[NSMutableArray class]])
                                       {
                                           self.commitMessages = nil;
                                       }
                                       else
                                       {
                                           NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self.commitMessages count]];
                                           NSEnumerator *enumerator = [self.commitMessages reverseObjectEnumerator];
                                           for (id element in enumerator) {
                                               [array addObject:element];
                                           }
                                           
                                           self.commitMessages = array;
                                       }
                                   }
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView reloadData];
                               });
                           }];
    
    
}

-(void)getMoreCommit
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.vizoal.com/vizoal/services/playerComment/old/%ld/%ld",(long)self.PlayerFmId,(long)self.lastCommitId]];
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
                                       
                                       if (![self.commitMessages isKindOfClass:[NSMutableArray class]])
                                       {
                                           self.commitMessages = nil;
                                       }
                                       else
                                       {
                                           NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self.commitMessages count]];
                                           NSEnumerator *enumerator = [self.commitMessages reverseObjectEnumerator];
                                           for (id element in enumerator) {
                                               [array addObject:element];
                                           }
                                           
                                           self.commitMessages = array;
                                       }
                                   }
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView reloadData];
                               });
                           }];
    
    
}

- (void)cameraPressed:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
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
                               @"http://api.vizoal.com/vizoal/services/playerComment"];
    
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


#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}

- (NSDictionary *)listData
{
    if (!_listData) {
        _listData = [[NSDictionary alloc] init];
    }
    return _listData;
}

-(void)startRequest
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.vizoal.com/vizoal/services/player/%ld",(long)self.PlayerFmId]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
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
                                       self.listData = [resDic objectForKey:@"result"];
                                   }
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self reflish];
                               });
                           }];
    
}

- (void)reflish
{
	// Do any additional setup after loading the view.
    NSMutableDictionary* dict = (NSMutableDictionary*)self.listData;
    
    if (dict == nil) {
        return;
    }
    
    // Configure the cell...
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"player-placeholder2" ofType:@"png"];
    self.Photo.image = [[UIImage alloc] initWithContentsOfFile:thePath];
    
    NSInteger playerFmId = [[dict objectForKey:@"fmId"] integerValue];
    [PlayerPhoto photoData:playerFmId afterDone:^(UIImage* image){
        self.Photo.image = image;
        [self.Photo updateConstraints];
    }];
    
    NSString* name = nil;
    if ([[[dict objectForKey:@"firstName"] description] compare:@""]) {
        name = [[NSString alloc] initWithFormat:@"%@ %@",[[dict objectForKey:@"firstName"] description] ,[[dict objectForKey:@"lastName"] description]];
    }
    else
    {
        name = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"lastName"]];
    }
    
    self.title = name;
    
    self.name.text = name;
    
    [self SetDatilText:self.listData];
}

-(void)SetDatilText:(NSDictionary*)dict
{
    NSArray* clubRecord = [[NSArray alloc] init];
    clubRecord = [dict objectForKey:@"playerPositionList"];
    
    for (NSDictionary* rec in clubRecord) {
        if ([[[rec objectForKey:@"efficiency"] description] compare:@"100%"] == NSOrderedSame) {
            self.OptimalPosition.text = [NSString stringWithFormat:@"Optimal Position: %@", [rec objectForKey:@"name"]];
            return;
        }
    }
    
    //self.DetailTextView.attributedText = allText;
}

@end
