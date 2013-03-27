//
//  HMFeedStreamViewController.m
//  homemade
//
//  Created by Guan Guan on 3/16/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMFeedStreamViewController.h"
#import "HMFeedAPIClient.h"
#import "HMFeedStreamViewCell.h"
#import "HMFeedItem.h"
#import "UIImageView+AFNetworking.h"
#import "SVPullToRefresh.h"
#import "HMRecipeViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

@interface HMFeedStreamViewController ()

@property (strong, nonatomic) NSMutableArray *feeds;

@end

@implementation HMFeedStreamViewController
{
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL hidden;

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Navbar is not hidden
    hidden = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleRightPanel:)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    self.title = @"Homemade";


    NSLog(@"FeedView Load");

//    [self reload:nil];
    
    
    //SVPullToRefresh
    // insert either the first or last feed for testing, change later
    
    __weak HMFeedStreamViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.tableView beginUpdates];
            [weakSelf.feeds insertObject:[weakSelf.feeds objectAtIndex:0] atIndex:0];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];

            [weakSelf.tableView endUpdates];
            
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            
            [weakSelf contract];
        });
    }];
    
    [self.tableView.pullToRefreshView setTitle:@"" forState:SVPullToRefreshStateAll];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.tableView beginUpdates];
            [weakSelf.feeds addObject:weakSelf.feeds.lastObject];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.feeds.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [weakSelf.tableView endUpdates];
            
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    }];
    
    // trigger the refresh manually at the end of viewDidLoad
    [self.tableView triggerPullToRefresh];

    [self reload:nil];

    
    
    //Add refreshControl
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.tintColor = [UIColor lightGrayColor];
//    [refreshControl addTarget:self action:@selector(updateTableView) forControlEvents:UIControlEventValueChanged];
//    self.refreshControl = refreshControl;

    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)reload:(id)sender {
    [[HMFeedAPIClient sharedClient] latestFeedsWithBlock:^(NSArray *feeds, NSError *error) {
        if (error) {
            NSLog(@"Error");
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            self.feeds = [NSMutableArray arrayWithArray:feeds];
            NSLog(@"Feeds size: %d", self.feeds.count);
            [self.tableView reloadData];
        }
    }];
}

- (void)toggleRightPanel:(id)sender {
    [self.sidePanelController toggleRightPanel:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HMFeedStreamCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[HMFeedStreamViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    HMFeedItem *feed = [self.feeds objectAtIndex:[indexPath row]];
    HMFeedStreamViewCell * feedCell = (HMFeedStreamViewCell *)cell;
    [feedCell.photo setImageWithURL:[[NSURL alloc] initWithString:feed.photo_url]];
    feedCell.nameLabel.text = feed.title;
    feedCell.dateLabel.text = [self daysDistanceFromDate:feed.date];
    feedCell.descLabel.text = feed.desc;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 390.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //For testing, point to the same HMRecipeViewController,add properties later
    HMRecipeViewController *recipeViewController = [[HMRecipeViewController alloc] init];
    [[self navigationController] pushViewController:recipeViewController animated:YES];
    
}

//#pragma mark - View Optimization
//
//-(void)updateTableView
//{
//    //Do something
//    
//    
//    //Add some delay to optimize user experience
//    [self performSelector:@selector(stopRefresh) withObject:self afterDelay:0.2];
//}
//
//-(void)stopRefresh
//{
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"loading"];//Optional. Only supported in iOS6
//    [self.refreshControl endRefreshing];
//}
//

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

// After pullToRefresh, need to set the offset to top
-(void)contract
{
    startContentOffset = 0.0f;
    hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.tableView setContentOffset:CGPointZero];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    startContentOffset = scrollView.contentOffset.y;
//    NSLog(@"scrollViewWillBeginDragging: %f", scrollView.contentOffset.y);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromStart = startContentOffset - currentOffset;
    
    if(differenceFromStart < 0) {
        // scroll up
        if(scrollView.isTracking) {
            if(hidden) return;
            
            hidden = YES;
            
            [self.navigationController setNavigationBarHidden:YES animated:YES]; 
        }
    } else {
        if(scrollView.isTracking) {
            if(!hidden) return;
            
            hidden = NO;
            
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}


#pragma mark - Controller methods

-(NSString*)daysDistanceFromDate:(NSDate*)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    
    NSTimeInterval lastDiff = [date timeIntervalSinceNow];
    NSTimeInterval todaysDiff = [[NSDate date] timeIntervalSinceNow];
    NSTimeInterval dateDiff = abs(lastDiff - todaysDiff);
    
    NSTimeInterval todaySeconds = abs([today timeIntervalSinceNow] - todaysDiff);
    
    if(dateDiff <= todaySeconds) {
        return NSLocalizedString(@"Today", @"photos uploaded in today");
    }
    else {
        int n = 1;
        n += abs(dateDiff-todaySeconds)/(24*60*60);
        if (n == 1){
            return NSLocalizedString(@"Yesterday", @"Photos uploaded in yesterday");
        }
        else if(n < 7){
            return [NSString stringWithFormat:NSLocalizedString(@"%d days ago", @""), n];
        }
        else if (n < 30) {
            int weeks = n/7;
            if(weeks == 1)
                return [NSString stringWithFormat:NSLocalizedString(@"%d week ago", @""), weeks];
            else
                return [NSString stringWithFormat:NSLocalizedString(@"%d weeks ago", @""), weeks];
        }
        else if (n < 360) {
            int months = n/30;
            if(months == 1)
                return [NSString stringWithFormat:NSLocalizedString(@"%d month ago", @""), months];
            else
                return [NSString stringWithFormat:NSLocalizedString(@"%d months ago",@""), months];
        }
        else{
            int years = n/360;
            if(years == 1)
                return [NSString stringWithFormat:NSLocalizedString(@"%d year ago",@""), years];
            else
                return [NSString stringWithFormat:NSLocalizedString(@"%d years ago",@""), years];
        }
    }
}




@end
