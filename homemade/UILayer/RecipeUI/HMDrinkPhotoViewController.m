//
//  HMDrinkPhotoViewController.m
//  homemade
//
//  Created by Guan Guan on 7/4/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMDrinkPhotoViewController.h"
#import "HMDrinkPhotoViewCell.h"
#import "SVPullToRefresh.h"
#import "UIImage+ColorImage.h"
#import "HMCommentViewController.h"
#import "HMEditPhotoViewController.h"
#import "HMDrinkPhotoViewHeader.h"
#import <QuartzCore/QuartzCore.h>

static NSString *cellIdentifier = @"DrinkPhotoCollectionCell";
static NSString *headerViewIdentifier = @"DrinkPhotoCollectionHeader";
int numPerPage = 6;

@interface HMDrinkPhotoViewController ()

@property (nonatomic, strong) PFObject *recipeObject;
@property (nonatomic, strong) NSMutableArray *objects;

@end

@implementation HMDrinkPhotoViewController {
    BOOL isLoading;
    NSInteger page;
    NSString *searchTerm;
}

- (id)initWithRecipe:(PFObject*)recipeObject{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:1.0f];
    [flowLayout setItemSize:CGSizeMake(159.5f, 200.0f)];
    flowLayout.headerReferenceSize = CGSizeMake(320, 50);
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        self.recipeObject = recipeObject;   
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[HMDrinkPhotoViewCell class]
            forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[HMDrinkPhotoViewHeader class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:headerViewIdentifier];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];
    if (DEVICE_VERSION_7) {
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    } else {
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    NSLog(@"Photo view frame: %@", NSStringFromCGRect(self.view.frame));
    isLoading = NO;
    page = 0;
    self.objects = [NSMutableArray array];
    self.collectionView.scrollEnabled = YES;
    self.collectionView.bounces = YES;
    
    __weak HMDrinkPhotoViewController *weakSelf = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.collectionView.infiniteScrollingView startAnimating];
            [weakSelf loadNextPage];
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        });
    }];
    
    [self loadNextPage];
    
    // camera config
    self.photoPicker = [[HMCameraViewController alloc] init];
    self.photoPicker.delegate = self;
    self.photoPicker.container = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPublishPhoto:) name:HMCameraControllerDidFinishEditingPhotoNotification object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HMDrinkPhotoViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *photoObject = [self.objects objectAtIndex:indexPath.row];
    [cell.photoView setFile:[photoObject objectForKey:kHMDrinkPhotoPictureKey]];
    [cell.photoView loadInBackground];
    
    NSString *label = [photoObject objectForKey:kHMDrinkPhotoNoteKey];
    
    PFUser *user = [photoObject objectForKey:kHMDrinkPhotoUserKey];
    NSString *name = [user objectForKey:kHMUserFirstNameKey];
    
    NSString *labelText;
    if (label.length > 35) {
        labelText = [NSString stringWithFormat:@"%@... - %@", [label substringToIndex:35], name];
    } else {
        labelText = [NSString stringWithFormat:@"%@ - %@", label, name];
    }
    
    cell.label.text = labelText;
    [cell.label setText:labelText afterInheritingLabelAttributesAndConfiguringWithBlock:
        ^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange boldRange = [[mutableAttributedString string] rangeOfString:name options:NSLiteralSearch];
            UIFont *boldFont = [UIFont boldSystemFontOfSize:11];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldFont.fontName, boldFont.pointSize, NULL);
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                 CFRelease(font);
            }
            return mutableAttributedString;
    }];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        HMDrinkPhotoViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        [headerView setFrame:CGRectMake(0, 0, 320, 50)];
        [headerView.cameraButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];

        return headerView;
    }
        
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *obj = [self.objects objectAtIndex:indexPath.row];
    HMCommentViewController *commentView = [[HMCommentViewController alloc] initWithPFObject:obj andType:kHMCommentTypePhoto];
    [self.recipeViewController.navigationController pushViewController:commentView animated:YES];
}

#pragma mark -

- (void)loadNextPage {
    if (isLoading || !self.recipeObject) {
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:kHMDrinkPhotoClassKey];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
        
    [query whereKey:kHMDrinkPhotoRecipeKey equalTo:self.recipeObject];
    [query includeKey:kHMDrinkPhotoUserKey];
    [query orderByDescending:@"createdAt"];
    query.limit = numPerPage;
    query.skip = numPerPage * page;
    
    isLoading = YES;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.objects addObjectsFromArray:objects];
            [self.collectionView reloadData];
            page += 1;
        }
    }];
    isLoading = NO;
}

#pragma mark - Notification
- (void)userDidPublishPhoto:(NSNotification *)note {
    if (self.objects.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    
    [self.objects removeAllObjects];
    isLoading = NO;
    page = 0;
    [self loadNextPage];
    [self.collectionView reloadData];
    
    // refresh photo count cache
    PFQuery *photoQuery = [HMUtility queryForPhotosOnRecipe:self.recipeObject cachePolicy:kPFCachePolicyNetworkOnly];
    [photoQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        @synchronized(self) {
            if (error) {
                return;
            }
            // cache photo count
            [[HMCache sharedCache] setPhotoCountForRecipe:self.recipeObject count:number];
        }
    }];
    
}

#pragma mark - HMCameraDelegate
- (void)cameraViewControllerShowPicker:(HMCameraViewController *)picker {
    [picker showPhotoPicker:@"Upload a picture" inView:self.view];
}

- (void)cameraViewController:(HMCameraViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    HMEditPhotoViewController *viewController = [[HMEditPhotoViewController alloc] initWithImage:image withRecipe:self.recipeObject];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:viewController animated:NO completion:nil];
}

- (void)cameraViewControllerDidCancel:(HMCameraViewController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
- (void)takePicture {
    if (self.photoPicker.delegate && [self.photoPicker.delegate respondsToSelector:@selector(cameraViewControllerShowPicker:)]) {
        [self.photoPicker.delegate cameraViewControllerShowPicker:self.photoPicker];
    }
}

@end
