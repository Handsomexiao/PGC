//
//  PlayerProfileDetailVC_tab4.m
//  PGC
//
//  Created by Xiao Shuai on 10/15/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PlayerProfileDetailVC_tab4.h"
#import "Message.h"
#import "HRChatCell.h"

@interface PlayerProfileDetailVC_tab4 () <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *_msgList;
}
@end

static NSString * const RCellIdentifier = @"HRChatCell";
@implementation PlayerProfileDetailVC_tab4

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
	// Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *chatNib = [UINib nibWithNibName:@"HRChatCell" bundle:[NSBundle bundleForClass:[HRChatCell class]]];
    [self.tableView registerNib:chatNib forCellReuseIdentifier:RCellIdentifier];
}

- (void)loadData
{
    const NSString *RMsgKey = @"msg";
    const NSString *RMineKey = @"ismine";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
    
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:path];
    if (!dataArray)
    {
        NSLog(@"读取文件失败");
        return;
    }
    
    _msgList = [NSMutableArray arrayWithCapacity:dataArray.count];
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        Message *message = [[Message alloc] init];
        message.msg = dict[RMsgKey];
        message.mine = [dict[RMineKey] boolValue];
        [_msgList addObject:message];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _msgList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *msg = _msgList[indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:RChatFontSize];
    //CGFloat height = [msg.msg boundingRectWithSize:CGSizeMake(150, 10000) options:NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height;
    CGFloat height = [msg.msg sizeWithFont:font constrainedToSize:CGSizeMake(150, 10000)].height;
    CGFloat lineHeight = [font lineHeight];
    
    return RCellHeight + height - lineHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRChatCell *cell = [tableView dequeueReusableCellWithIdentifier:RCellIdentifier];
    [cell bindMessage:_msgList[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (IBAction)SendCommit:(UIBarButtonItem *)sender {
    Message *message = [[Message alloc] init];
    message.msg = [self.CommitText.text description];
    message.mine = true;
    [_msgList addObject:message];
    self.CommitText.text = nil;
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
    [_msgList writeToFile:path atomically:YES];
    
    [self.tableView reloadData];
    
    
}

@end
