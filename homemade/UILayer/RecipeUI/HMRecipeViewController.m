//
//  HMRecipeViewController.m
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#define SELECTED_VIEW_TAG 98456345

#import "HMRecipeViewController.h"
#import "HMStepsViewController.h"
#import "HMAboutViewController.h"
#import "HMImadeItViewController.h"
#import "HMEditPhotoViewController.h"

@interface HMRecipeViewController ()

@property (nonatomic, strong) CustomTabBar *tabBar;
@property (nonatomic, strong) HMAboutViewController *aboutViewController;
@property (nonatomic, strong) HMStepsViewController *stepsViewController;
@property (nonatomic, strong) HMImadeItViewController *imadeitViewController;
@property(nonatomic,strong) NSArray *tabBarItems;
@property(nonatomic,strong) UIColor *color;

@end

@implementation HMRecipeViewController

@synthesize tabBar = _tabBar;
@synthesize tabBarItems = _tabBarItems;
@synthesize color = _color;
@synthesize aboutViewController = _aboutViewController;
@synthesize stepsViewController = _stepsViewController;
@synthesize imadeitViewController = _imadeitViewController;

- (id)initWithRecipe:(PFObject*)recipeObject{
   return  [self initWithRecipe:recipeObject andUIColor:[UIColor colorWithRed:162.0/255.0 green:73.0/255.0 blue:43.0/255.0 alpha:1.0]];
}

- (id)initWithRecipe:(PFObject*)recipeObject andUIColor:(UIColor*)color
{
    self = [super init];
    if (self)
    {
        self.recipeObject = recipeObject;
        self.color = color;
        
        // Init photo picker
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
    
    // Add a share navBarItem
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonClicked)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Initialize three subViews
    self.aboutViewController = [[HMAboutViewController alloc] initWithRecipe:self.recipeObject];
    self.stepsViewController = [[HMStepsViewController alloc] initWithRecipe:self.recipeObject];
    self.imadeitViewController = [[HMImadeItViewController alloc] initWithRecipe:self.recipeObject];
    self.imadeitViewController.recipeViewController = self;
    
    // Place the tab bar at the top of our view
    _tabBarItems = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"about.png", @"image", self.aboutViewController, @"viewController", @"About", @"subTitle", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"steps.png", @"image", self.stepsViewController, @"viewController", @"Steps", @"subTitle", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"imadeit.png", @"image", self.imadeitViewController, @"viewController", @"Pics", @"subTitle", nil], nil];
    
    _tabBar = [[CustomTabBar alloc] initWithItemCount:3 itemSize:CGSizeMake(TabBarWidth/3, TabBarHeight) tag:0 delegate:self];
    self.tabBar.frame = CGRectMake(0, 0, TabBarWidth, TabBarHeight);
    [self.tabBar setBackgroundColor:[UIColor clearColor]];

    [self.navigationItem setTitleView:_tabBar];
//    self.edgesForExtendedLayout = UIExtendedEdgeNone;
    
    // Select the first tab
    [self touchDownAtItemAtIndex:0];
    [self.tabBar selectItemAtIndex:0];

    
}

// TODO
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark -
#pragma mark CustomTabBarDelegate
- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
    // Get the right data
//    NSDictionary* data = [self.tabBarItems objectAtIndex:itemIndex];
    // Return the image for this tab bar item
//    return [UIImage imageNamed:[data objectForKey:@"image"]];
    return nil;
}

- (NSString*) titleFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex{
    
    NSDictionary* data = [self.tabBarItems objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    return [data objectForKey:@"subTitle"];
}


// This is the blue background shown for selected tab bar items
- (UIImage*) selectedItemBackgroundImage
{
    return nil;
}


//It's not used temporarily

- (UIImage*) tabBarArrowImage
{
    return [UIImage imageNamed:@"tabArrow.png"];
//    return [self changeImage:[UIImage imageNamed:@"TabBarNipple.png"] toColor:self.color] ;
}

- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    // Remove the current view controller's view
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_TAG];
    [currentView removeFromSuperview];
    
    // Get the right view controller
    NSDictionary* data = [self.tabBarItems objectAtIndex:itemIndex];
    UIViewController* viewController = [data objectForKey:@"viewController"];
    
    // Set the view controller's frame to account for the tab bar
    NSLog(@"Bounds: %@ %@",NSStringFromCGRect(self.view.bounds), NSStringFromCGRect(viewController.view.bounds));
    // Se the tag so we can find it later
    viewController.view.tag = SELECTED_VIEW_TAG;
    
    // Add the new view controller's view
    [self.view insertSubview:viewController.view aboveSubview:self.view];
//    [self.view addSubview:viewController.view];
}


#pragma mark - Helper
//change the nipple image color to required color
-(UIImage*)changeImage:(UIImage*)image toColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  [UIImage imageWithCGImage:img.CGImage
                                scale:1.0 orientation: UIImageOrientationDownMirrored];
    
}


#pragma UIbutton method
- (void)shareButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - HMCameraDelegate
- (void)cameraViewControllerShowPicker:(HMCameraViewController *)picker {
    NSLog(@"run delegate from RecipeViewController");
    [self.photoPicker showPhotoPicker:@"Upload a picture"];
}

- (void)cameraViewControllerDidCancel:(HMCameraViewController *)picker {
    NSLog(@"dismiss pick controller from RecipeViewController... delegate");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)cameraViewController:(HMCameraViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"didFinishPickingMediaWithInfo get executed...");
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    HMEditPhotoViewController *viewController = [[HMEditPhotoViewController alloc] initWithImage:image withRecipe:self.recipeObject];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:viewController animated:NO completion:nil];
}

@end
