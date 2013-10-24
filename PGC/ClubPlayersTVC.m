//
//  TopPlayerTVC.m
//  TVTest
//
//  Created by Shuai Xiao on 9/30/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "ClubPlayersTVC.h"
#import "ClubCell.h"
#import "PlayerCell.h"
#import "PlayerProfileVC.h"
#import "PlayerPhoto+Internet.h"
#import "playerProfileDetailTBC.h"

@interface ClubPlayersTVC ()
//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

@property (strong,nonatomic) NSMutableArray *filteredArray;
@property IBOutlet UISearchBar *SearchBar;

@end

@implementation ClubPlayersTVC

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

-(NSMutableArray*)listData
{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    
    return _listData;
}

-(NSMutableArray*)filteredArray
{
    if(!_filteredArray){
        _filteredArray = [[NSMutableArray alloc] init];
    }
    return _filteredArray;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // a UIRefreshControl inherits from UIControl, so we can use normal target/action
    // this is the first time you’ve seen this done without ctrl-dragging in Xcode
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self startRequest];
    
    // 将搜索栏藏起来（搜索栏只有在用户滚动到列表视图顶端时才会出现）
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.SearchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
}


-(IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.listData) {
        // 检查现在应该显示普通列表还是过滤后的列表
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [self.filteredArray count];
        } else {
            return [self.listData count];
        }
    }
    else{
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClubPlayer";
    PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSMutableDictionary* dict;
    
    // 检查现在应该显示普通列表还是过滤后的列表
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        dict = [self.filteredArray objectAtIndex:indexPath.row];
    } else {
        dict = [self.listData objectAtIndex:indexPath.row];
    }
    
    // Configure the cell...
    cell.tag = indexPath.row;
    
    cell.imageView.image = nil; // or cell.poster.image = [UIImage imageNamed:@"placeholder.png"];
    
    NSInteger playerFmId = [[dict objectForKey:@"fmId"] integerValue];

    [PlayerPhoto photoData:playerFmId afterDone:^(UIImage* image){
        if (cell.tag == indexPath.row) {
            cell.imageView.image = image;
            [cell setNeedsLayout];
            [cell.imageView updateConstraints];
        }
    }];

    NSString* name = nil;
    if ([[[dict objectForKey:@"firstName"] description] compare:@""]) {
        name = [[NSString alloc] initWithFormat:@"%@ %@",[[dict objectForKey:@"firstName"] description] ,[[dict objectForKey:@"lastName"] description]];
    }
    else
    {
        name = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"lastName"]];
    }
    
    //an NSDictionary of NSString => UIColor pairs
    NSRange range = [name rangeOfString:[[dict objectForKey:@"lastName"] description]];
    
    CGFloat fontSize = [UIFont systemFontSize];
    
    NSDictionary *attributes = [cell.textLabel.attributedText attributesAtIndex:0 effectiveRange:NULL];
    UIFont *font = attributes[NSFontAttributeName];
    if (font) fontSize = font.pointSize;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:name];
    //[mat setAttributes:subAttrs range:range];
    [mat addAttribute:NSFontAttributeName value:boldFont range:range];
    
    cell.imageView.image = [UIImage imageNamed:@"player-placeholder2.png"];
    cell.textLabel.attributedText = mat;
    cell.playerFmId = [[dict objectForKey:@"playerId"] integerValue];
    NSLog(@"%@", name);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"nickName"],[dict objectForKey:@"nationOfBirthName"]];
    
    return cell;
}

-(void)startRequest
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-215-136-21.us-west-1.compute.amazonaws.com:8080/vizoal/services/playerlistByClub/%d",self.cludId]];
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
                                       self.filteredArray = [NSMutableArray arrayWithCapacity:[self.listData count]];
                                   }
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView reloadData];
                               });
                           }];
    
    
    
}


#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // 根据搜索栏的内容和范围更新过滤后的数组。
    // 先将过滤后的数组清空。
    [self.filteredArray removeAllObjects];
    // 用NSPredicate来过滤数组。
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fullName contains[c] %@",searchText];
    self.filteredArray = [NSMutableArray arrayWithArray:[self.listData filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // 当用户改变搜索字符串时，让列表的数据来源重新加载数据
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // 返回YES，让table view重新加载。
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // 当用户改变搜索范围时，让列表的数据来源重新加载数据
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // 返回YES，让table view重新加载。
    return YES;
}

-(IBAction)goToSearch:(id)sender {
    // 如果你担心用户无法发现藏在列表顶端的搜索栏，那我们在导航栏加一个搜索图标。
    // 如果你不隐藏搜索栏，那就别加入这个搜索图标，否则就重复了。
    [self.SearchBar becomeFirstResponder];
}


#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 切入详细视图
    [self performSegueWithIdentifier:@"CellPlayerSelect" sender:tableView];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CellPlayerSelect"]) {
        // 我们需要知道哪个是现在正显示的列表视图，这样才能从相应的数组中提取正确的信息，显示在详细视图中。
        if(sender == self.searchDisplayController.searchResultsTableView) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSDictionary* dict = [self.filteredArray objectAtIndex:[indexPath row]];
            playerProfileDetailTBC* plays = (playerProfileDetailTBC*)segue.destinationViewController;
            plays.playerFmId = [[dict objectForKey:@"playerId"] integerValue];
        }
        else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSDictionary* dict = [self.listData objectAtIndex:[indexPath row]];
            playerProfileDetailTBC* plays = (playerProfileDetailTBC*)segue.destinationViewController;
            plays.playerFmId = [[dict objectForKey:@"playerId"] integerValue];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
