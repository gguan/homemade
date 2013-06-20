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

#define AvatarSize 80
#define WindowHeight 220
#define CoverHeight 320

@interface HMAccountViewController ()

@property (nonatomic, strong) PFImageView *coverView;
@property (nonatomic, strong) PFImageView *avatar;

@end

@implementation HMAccountViewController

- (id)initWithUser:(PFUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
        
        // photo picker
        self.photoPicker = [[HMCameraViewController alloc] init];
        self.photoPicker.delegate = self;
        self.photoPicker.container = self;
        
        _coverScroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _coverScroller.backgroundColor = [UIColor whiteColor];
        _coverScroller.showsHorizontalScrollIndicator = NO;
        _coverScroller.showsVerticalScrollIndicator = NO;
        
        _coverView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        _coverView.backgroundColor = [UIColor whiteColor];
        [_coverScroller addSubview:_coverView];
                
        // table view
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor              = [UIColor clearColor];
        _tableView.dataSource                   = self;
        _tableView.delegate                     = self;
        _tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        
        // add a upload button
        UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [coverButton setBackgroundColor:[UIColor clearColor]];
        [coverButton setFrame:CGRectMake(0, 0, _tableView.bounds.size.width, WindowHeight)];
        [coverButton addTarget:self action:@selector(uploadCover) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableHeaderView = coverButton;
        
        // add a border
//        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, WindowHeight-1, _tableView.bounds.size.width, 1.0f)];
//        [border setBackgroundColor:[UIColor blackColor]];
//        [coverButton addSubview:border];
        
        // avatar
        _avatar = [[PFImageView alloc] initWithFrame:CGRectMake(225.0f, 125.0f, AvatarSize, AvatarSize)];
        _avatar.layer.cornerRadius = AvatarSize / 2;
        _avatar.layer.borderWidth = 2.0f;
        _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatar.layer.masksToBounds = YES;
        [self.tableView.tableHeaderView addSubview:_avatar];
        
        
        
        [self.view addSubview:_coverScroller];
        [self.view addSubview:_tableView];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    NSString *title = [[PFUser currentUser] objectForKey:kHMUserDisplayNameKey];
    [self.navigationItem setTitle:title];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(leftDrawerButtonClicked)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Setting" style:UIBarButtonItemStylePlain target:self action:@selector(rightDrawerButtonClicked)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    // Cover Photo
    [self.coverView setFile: [self.user objectForKey:kHMUserCoverPhotoKey]];
    [self.coverView loadInBackground];
    
    // Avatar
    [self.avatar setFile:[self.user objectForKey:kHMUserProfilePicMediumKey]];
    [self.avatar loadInBackground];
    

    // Name label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 165, 200, 30)];
    [nameLabel setText:[self.user objectForKey:kHMUserDisplayNameKey]];
    [nameLabel setFont:[HMUtility appFontOfSize:21.0f]];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [nameLabel setTextColor:[UIColor whiteColor]];
    [self.tableView.tableHeaderView addSubview:nameLabel];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parallax effect

- (void)updateOffsets {
    CGFloat yOffset   = _tableView.contentOffset.y;
    CGFloat threshold = CoverHeight - WindowHeight;
    
    if (yOffset > -threshold && yOffset < 0) {
        _coverScroller.contentOffset = CGPointMake(0.0, floorf(yOffset / 2.0));
    } else if (yOffset < 0) {
        _coverScroller.contentOffset = CGPointMake(0.0, yOffset + floorf(threshold / 2.0));
    } else {
        _coverScroller.contentOffset = CGPointMake(0.0, yOffset);
    }
}

#pragma mark - View Layout
- (void)layoutImage {
    CGFloat imageWidth   = _coverScroller.frame.size.width;
    CGFloat imageYOffset = floorf((WindowHeight  - CoverHeight) / 2.0);
    CGFloat imageXOffset = 0.0;
    
    _coverView.frame  = CGRectMake(imageXOffset, imageYOffset, imageWidth, CoverHeight);
    _coverScroller.contentSize   = CGSizeMake(imageWidth, self.view.bounds.size.height);
    _coverScroller.contentOffset = CGPointMake(0.0, 0.0);
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect bounds = self.view.bounds;
    
    _coverScroller.frame        = CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height);
    _tableView.backgroundView   = nil;
    _tableView.frame            = bounds;
    
    [self layoutImage];
    [self updateOffsets];
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 10.0;         
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier   = @"RBParallaxTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
            cell.backgroundColor             = [UIColor purpleColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle              = UITableViewCellSelectionStyleNone;
    } 
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateOffsets];
}


#pragma mark - HMCameraDelegate
- (void)cameraViewControllerShowPicker:(HMCameraViewController *)picker {
    NSLog(@"run delegate from RecipeViewController");
    [self.photoPicker showPhotoPicker:@"Change cover"];
}

- (void)cameraViewControllerDidCancel:(HMCameraViewController *)picker {
    NSLog(@"dismiss pick controller from RecipeViewController... delegate");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)cameraViewController:(HMCameraViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"didFinishPickingMediaWithInfo get executed...");
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self shouldUploadCoverImage:image];
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}



#pragma mark -
- (void)leftDrawerButtonClicked {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)rightDrawerButtonClicked {
    HMSettingViewController *settingViewController = [[HMSettingViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [self presentViewController:navigationController animated:YES completion:^{
    }];
}

- (void)uploadCover {
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


@end
