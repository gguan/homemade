//
//  HMAccountViewController.m
//  homemade
//
//  Created by Guan Guan on 6/14/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMAccountViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HMSettingViewController.h"
#import "UIImage+ResizeAdditions.h"
#import <QuartzCore/QuartzCore.h>
#import "SVPullToRefresh.h"
#import "HMUserRecipeCell.h"
#import "TTTTimeIntervalFormatter.h"

const CGFloat AvatarSize = 80.0f;
const CGFloat WindowHeight = 200.0f;
const CGFloat CoverHeight = 320.0f;

const NSInteger QueryLimit = 5;

const NSInteger UploadAvatar = 1;
const NSInteger UploadCover  = 2;

@interface HMAccountViewController () {
    BOOL isLoading;
    BOOL isFollowing;
    NSInteger currentPage;
}

@property (nonatomic, strong) HMCameraViewController *photoPicker;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PFImageView *coverView;
@property (nonatomic, strong) PFImageView *avatar;

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;

@property (nonatomic, assign) NSInteger uploadPhoto;

@end

@implementation HMAccountViewController

- (id)initWithUser:(PFUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
        self.objects = [[NSMutableArray alloc] init];
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
        // photo picker
        self.photoPicker = [[HMCameraViewController alloc] init];
        self.photoPicker.delegate = self;
        self.photoPicker.container = self;        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    NSString *title = [self.user objectForKey:kHMUserDisplayNameKey];
    [self.navigationItem setTitle:title];
    
    int n = [self.navigationController.viewControllers count] - 2;
    if ( n >= 0 ) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    } else {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-list.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonClicked)];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
    
    
    if ([PFUser currentUser] == self.user) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightDrawerButtonClicked)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    } else {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn20-add.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
   
    isFollowing = NO;
    isLoading = NO;
    currentPage = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([UIDevice isBelowiOS7]) {
        self.coverView = [[PFImageView alloc] initWithFrame:CGRectMake(0, WindowHeight - CoverHeight + 64, 320, CoverHeight - 64)];
    } else {
        self.coverView = [[PFImageView alloc] initWithFrame:CGRectMake(0, WindowHeight - CoverHeight, 320, CoverHeight)];
    }
    [self.view addSubview:self.coverView];
    self.coverView.backgroundColor = [UIColor whiteColor];
    self.coverView.clipsToBounds = YES;
    self.coverView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Cover Photo
    [self.coverView setFile: [self.user objectForKey:kHMUserCoverPhotoKey]];
    [self.coverView loadInBackground];
    
    
    // table view
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.backgroundColor              = [UIColor clearColor];
    _tableView.dataSource                   = self;
    _tableView.delegate                     = self;
    _tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;

    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, WindowHeight + AvatarSize)];
    headerView.backgroundColor = [UIColor clearColor];
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, WindowHeight, self.view.frame.size.width, AvatarSize)];
    whiteView.backgroundColor = [UIColor whiteColor];
    // avatar
    _avatar = [[PFImageView alloc] initWithFrame:CGRectMake(220.0f, WindowHeight-AvatarSize/3, AvatarSize, AvatarSize)];
    _avatar.layer.borderWidth = 2.0f;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatar.clipsToBounds = NO;
    _avatar.layer.shadowOpacity = 0.5f;
    _avatar.layer.shadowColor = [UIColor blackColor].CGColor;
    _avatar.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
    [self.avatar setFile:[self.user objectForKey:kHMUserProfilePicMediumKey]];
    [self.avatar loadInBackground];
    // name label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, WindowHeight-30, 200, 30)];
    nameLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.45f];
    nameLabel.shadowOffset = CGSizeMake(0,0.3);
    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
    NSAttributedString *nameText = [[NSAttributedString alloc] initWithString:[self.user objectForKey:kHMUserDisplayNameKey] attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],UITextAttributeTextColor,
                                    [UIColor colorWithWhite:0.0f alpha:0.850f],
                                    UITextAttributeTextShadowColor,
                                    [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)],
                                    UITextAttributeTextShadowOffset,
                                                                                                                                         nil]];
    [nameLabel setAttributedText:nameText];
    
    nameLabel.textAlignment = NSTextAlignmentRight;
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    

    [headerView addSubview:whiteView];
    [headerView addSubview:_avatar];
    [headerView addSubview:nameLabel];
    
    
    
    // add upload cover button
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton setBackgroundColor:[UIColor clearColor]];
    [coverButton setFrame:CGRectMake(0, 0, _tableView.bounds.size.width, WindowHeight-AvatarSize/2)];
    [coverButton addTarget:self action:@selector(uploadCover) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:coverButton];
    
    // add upload avatar
    UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [avatarButton setBackgroundColor:[UIColor clearColor]];
    [avatarButton setFrame:self.avatar.frame];
    [avatarButton addTarget:self action:@selector(uploadAvatar) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:avatarButton];
    
    
    self.tableView.tableHeaderView = headerView;
    
    [self.view addSubview:self.tableView];
    
        
    
    // Infinite scroll and pagination
    __weak HMAccountViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf doQuery];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadAvatarDidFinished:) name:HMUploadAvatarDidFinishedNotification object:nil];
    
    [self doQuery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showActionSheet {
    NSString *buttonLabel = [NSString stringWithFormat:@"Follow %@", [[PFUser currentUser] objectForKey:kHMUserDisplayNameKey]];
    if (isFollowing) {
        buttonLabel = [NSString stringWithFormat:@"Unfollow %@", [[PFUser currentUser] objectForKey:kHMUserDisplayNameKey]];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:buttonLabel, nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (isFollowing) {
            // TODO
            NSLog(@"Unfollow %@", [[PFUser currentUser] objectForKey:kHMUserDisplayNameKey]);
        } else {
            NSLog(@"Follow %@", [[PFUser currentUser] objectForKey:kHMUserDisplayNameKey]);
        }
    }
}


#pragma mark - Parallax effect

- (void)updateOffsets {
    CGFloat yOffset   = _tableView.contentOffset.y;
    CGFloat threshold = WindowHeight - CoverHeight;
    
    if (yOffset <= threshold) {
        [self.tableView setContentOffset:CGPointMake(0, threshold)];
    }
    if (yOffset <= 0 && yOffset >= threshold) {
        self.coverView.frame = CGRectMake(0, (threshold - yOffset) / 2, 320, 320);
    } else if (yOffset >= 0) {
        self.coverView.frame = CGRectMake(0, threshold / 2 - yOffset, 320, 320);
    }
    
}

#pragma mark - View Layout
- (void)layoutImage {
    CGFloat imageWidth   = _coverView.frame.size.width;
    CGFloat imageYOffset = floorf((WindowHeight  - CoverHeight) / 2.0);
    CGFloat imageXOffset = 0.0;
    
    _coverView.frame  = CGRectMake(imageXOffset, imageYOffset, imageWidth, CoverHeight);
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect bounds = self.view.bounds;
    
    _tableView.backgroundView   = nil;
    _tableView.frame            = bounds;
    
    [self layoutImage];
    [self updateOffsets];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HMUploadAvatarDidFinishedNotification object:nil];
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier   = @"UserRecipeCell";
    
    HMUserRecipeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[HMUserRecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    PFObject *drink = [self.objects objectAtIndex:indexPath.row];
    [cell.photo setFile:[drink objectForKey:kHMRecipePhotoKey]];
    [cell.photo loadInBackground];
    [cell.avatar setFile:[self.user objectForKey:kHMUserProfilePicSmallKey]];
    [cell.avatar loadInBackground];
    
    NSTimeInterval timeInterval = [[drink createdAt] timeIntervalSinceNow];
    NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
    [cell.timestampLabel setText:timestamp];
    NSString *note = [drink objectForKey:kHMRecipeOverviewKey];
    [cell.noteLabel setText:note];
//    cell.backgroundColor             = [UIColor purpleColor];
//    cell.contentView.backgroundColor = [UIColor purpleColor];
    return cell;
}

#pragma mark - Table View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateOffsets];
}


#pragma mark - HMCameraDelegate
- (void)cameraViewControllerShowPicker:(HMCameraViewController *)picker {
    NSLog(@"run delegate from RecipeViewController");
    if (self.uploadPhoto == UploadCover) {
        [self.photoPicker showPhotoPicker:@"Change cover" inView:self.view];
    } else {
        [self.photoPicker showPhotoPicker:@"Change avatar" inView:self.view];
    }
    
}

- (void)cameraViewControllerDidCancel:(HMCameraViewController *)picker {
    NSLog(@"dismiss pick controller from RecipeViewController... delegate");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)cameraViewController:(HMCameraViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"didFinishPickingMediaWithInfo get executed...");
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (self.uploadPhoto == UploadCover) {
        [self shouldUploadCoverImage:image];
    } else {
        [self shouldUploadAvatarImage:image];
    }
    
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}



#pragma mark -
- (void)leftDrawerButtonClicked {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightDrawerButtonClicked {
    HMSettingViewController *settingViewController = [[HMSettingViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [self presentViewController:navigationController animated:YES completion:^{
    }];
}

- (void)uploadCover {
    self.uploadPhoto = UploadCover;
    [self cameraViewControllerShowPicker:self.photoPicker];
}

- (void)uploadAvatar {
    self.uploadPhoto = UploadAvatar;
    [self cameraViewControllerShowPicker:self.photoPicker];
}


- (BOOL)shouldUploadCoverImage:(UIImage *)anImage {
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640.0f, 640.0f) interpolationQuality:kCGInterpolationHigh];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    
    if (!imageData) {
        return NO;
    }
    
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.user setObject:imageFile forKey:kHMUserCoverPhotoKey];
            [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Saved new cover");
                    [self.coverView setFile:imageFile];
                    [self.coverView loadInBackground];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return YES;
}

- (BOOL)shouldUploadAvatarImage:(UIImage *)anImage {
    
    UIImage *mediumImage = [anImage thumbnailImage:kAvatarSizeMedium transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    UIImage *smallRoundedImage = [anImage thumbnailImage:kAvatarSizeSmall transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationLow];
    
    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);
    
    if (mediumImageData.length > 0) {
        PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileMediumImage forKey:kHMUserProfilePicMediumKey];
                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // Notify to update photo
                        [[NSNotificationCenter defaultCenter] postNotificationName:HMUploadAvatarDidFinishedNotification object:nil];
                    }
                }];
            }
        }];
    }
    
    if (smallRoundedImageData.length > 0) {
        PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileSmallRoundedImage forKey:kHMUserProfilePicSmallKey];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
    
    return YES;
}


- (void)doQuery {
    if (isLoading) {
        return;
    }
    isLoading = YES;
    
    PFUser *user = [PFUser currentUser];
    PFQuery *drinkQuery = [PFQuery queryWithClassName:kHMRecipeClassKey];
    [drinkQuery whereKey:kHMRecipeUserKey equalTo:user];
    drinkQuery.limit = QueryLimit;
    drinkQuery.skip = QueryLimit * currentPage;

    [drinkQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            @synchronized(self) {
                NSLog(@"%@", objects);
                [self.objects addObjectsFromArray:objects];
            }
            [self.tableView reloadData];
        }
    }];
    
    currentPage += 1;
    isLoading = NO;

}

- (void)uploadAvatarDidFinished:(NSNotification *)note {
    [self.avatar setFile:[self.user objectForKey:kHMUserProfilePicMediumKey]];
    [self.avatar loadInBackground];
    [self.tableView reloadData];
}


@end
