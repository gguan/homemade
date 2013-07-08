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
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];

    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    
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
    NSString *name = [user objectForKey:kHMUserDisplayNameKey];
    
    NSString *labelText;
    if (label.length > 30) {
        labelText = [NSString stringWithFormat:@"%@... - %@", [label substringToIndex:30], name];
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
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        headerView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:238.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 49.0f, 320, 1.0f)];
        border.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];
        
        UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(135, 15, 150, 30)];
        header.backgroundColor = [UIColor clearColor];
        header.font = [UIFont fontWithName:@"Helvetica-Oblique" size:15];
        header.textColor = [UIColor colorWithRed:69.0f/255.0f green:78.0f/255.0f blue:81.0f/255.0f alpha:1.0f];
        header.text = @"Upload a photo";
        
        UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 30, 30)];
        cameraButton.layer.cornerRadius = 15.0f;
        cameraButton.layer.borderWidth = 1.5f;
        cameraButton.layer.borderColor = [UIColor colorWithRed:63.0f/255.0f green:72.0f/255.0f blue:75.0f/255.0f alpha:1.0f].CGColor;
        UIImageView *cameraImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 16, 16)];
        [cameraImg setImage:[[UIImage imageNamed:@"icn40-camera.png"] changeImageToColor:[UIColor colorWithRed:63.0f/255.0f green:72.0f/255.0f blue:75.0f/255.0f alpha:1.0f]]];
        [cameraButton addSubview:cameraImg];
        
        [headerView addSubview:border];
        [headerView addSubview:header];
        [headerView addSubview:cameraButton];
        return headerView;
    }
        
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *obj = [self.objects objectAtIndex:indexPath.row];
    HMCommentViewController *commentView = [[HMCommentViewController alloc] initWithPFObject:obj andType:kHMCommentTypePhoto];
    [[self.recipeViewController navigationController] pushViewController:commentView animated:YES];
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

@end
