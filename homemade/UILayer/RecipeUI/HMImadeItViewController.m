//
//  HMImadeItViewController.m
//  homemade
//
//  Created by Xiaodi Xing on 4/30/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMImadeItViewController.h"
#import "HMRecipeViewController.h"
#import "HMIMadeItCell.h"
#import "TTTTimeIntervalFormatter.h"

#define HeaderHeight 60

@interface HMImadeItViewController ()
@property (nonatomic, strong) PFObject *recipeObject;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;

@end

@implementation HMImadeItViewController

- (id)initWithRecipe:(PFObject*)recipeObject{
    self = [super init];
    if (self) {
        self.recipeObject = recipeObject;
        
        // The className to query on
        self.parseClassName = kHMDrinkPhotoClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Custom initialization
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];

    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HeaderHeight)];
    self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-CameraButtonWidth)/2, 10, CameraButtonWidth, CameraButtonHeight)];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"buttonCamera"] forState:UIControlStateNormal];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"buttonCameraSelected"] forState:UIControlStateHighlighted];
    [self.cameraButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.cameraButton];
    
    self.tableView.tableHeaderView = headerView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPublishPhoto:) name:HMCameraControllerDidFinishEditingPhotoNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HMCameraControllerDidFinishEditingPhotoNotification object:nil];
}

- (void)takePicture {
    HMCameraViewController *photoPicker = self.recipeViewController.photoPicker;
    if (photoPicker.delegate && [photoPicker.delegate respondsToSelector:@selector(cameraViewControllerShowPicker:)]) {
            NSLog(@"camera button has delegate");
            [photoPicker.delegate cameraViewControllerShowPicker:photoPicker];
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *photoObject = [self.objects objectAtIndex:indexPath.row];
    NSString *note = [photoObject objectForKey:kHMDrinkPhotoNoteKey];
    return [HMIMadeItCell cellInitialHeight] + [HMIMadeItCell heightForText:note];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    if (!self.recipeObject) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
    }
    
    [query whereKey:kHMDrinkPhotoRecipeKey equalTo:self.recipeObject];
    [query includeKey:kHMDrinkPhotoUserKey];
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    // overridden, since we want to implement sections
    if (indexPath.row < self.objects.count) {
        return [self.objects objectAtIndex:indexPath.row];
    }
    
    return nil;
}


- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)photoObject {
    static NSString *CellIdentifier = @"IMadeItCell";
    
    HMIMadeItCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HMIMadeItCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (photoObject) {
        [cell.photo setFile:[photoObject objectForKey:kHMDrinkPhotoPictureKey]];
        NSTimeInterval timeInterval = [[photoObject createdAt] timeIntervalSinceNow];
        NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
        [cell.timestampLabel setText:timestamp];
        NSString *note = [photoObject objectForKey:kHMDrinkPhotoNoteKey];
        [cell.noteLabel setText:note];
        [cell adjustSize];
        
        // If photo is in memory, load it right away
        if (cell.photo.file.isDataAvailable) {
            [cell.photo loadInBackground:^(UIImage *image, NSError *error){
                if (error) {
                    NSLog(@"Error when load from memory!");
                }
            }];
        } else {
            // Manually download images from parse and set animation
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *data = [cell.photo.file getData];
                if(data) {
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async( dispatch_get_main_queue(), ^{
                        
                        // fade in fetched photo
                        [UIView animateWithDuration:0.0
                                         animations:^{
                                             cell.photo.alpha = 0.0f;
                                         }
                                         completion:^(BOOL finished) {
                                             [UIView animateWithDuration:0.3
                                                              animations:^{
                                                                  [cell.photo setImage: image];
                                                                  cell.photo.alpha = 1.0f;
                                                              }
                                                              completion:^(BOOL finished) { }];
                                         }];
                    });
                    
                } else {
                    NSLog(@"Error! Failed to download data from parse!");
                }
                
            });
        } // if isDataAvailable end
        
        // load comments
        // TODO
    } else {
        NSLog(@"Bad object");
        return cell;
    }
 
    PFUser *user = [photoObject objectForKey:kHMDrinkPhotoUserKey];
    [cell.avatar setFile: [user objectForKey:kHMUserProfilePicSmallKey]];
    [cell.avatar loadInBackground];
    return cell;
}

#pragma mark - Notification
- (void)userDidPublishPhoto:(NSNotification *)note {
    if (self.objects.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [self loadObjects];
}

@end
