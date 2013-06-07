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

@interface HMRecipeViewController ()

@property(nonatomic,strong) CustomTabBar *tabBar;
@property(nonatomic,strong) NSArray *tabBarItems;
@property(nonatomic,strong) UIColor *color;
@property(nonatomic,strong) HMAboutViewController *aboutViewController;
@property(nonatomic,strong) HMStepsViewController *stepsViewController;
@property(nonatomic,strong) HMImadeItViewController *imadeitViewController;

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
        self.cameraPicker = [[HMCameraViewController alloc] init];
        self.color = color;
        
        // Add a baground color view
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, TabBarHeight, self.view.frame.size.width, self.view.frame.size.height - TabBarHeight)];
        [colorView setBackgroundColor:self.color];
        [self.view addSubview:colorView];
        
        // Set background image
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
        
        //The back button
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(13, 20, 12, 17)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventAllTouchEvents];
        [self.view addSubview:backButton];
        
        // Initialize three subViews
        self.aboutViewController = [[HMAboutViewController alloc] initWithRecipe:recipeObject];
        self.stepsViewController = [[HMStepsViewController alloc] initWithRecipe:recipeObject];
        self.imadeitViewController = [[HMImadeItViewController alloc] initWithRecipe:recipeObject];
        
        // Place the tab bar at the top of our view
        _tabBarItems = [NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"about.png", @"image", self.aboutViewController, @"viewController", nil, @"subTitle", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"steps.png", @"image", self.stepsViewController, @"viewController", nil, @"subTitle", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"imadeit.png", @"image", self.imadeitViewController, @"viewController", nil, @"subTitle", nil], nil];

        _tabBar = [[CustomTabBar alloc] initWithItemCount:3 itemSize:CGSizeMake(TabBarWidth/3, TabBarHeight-3) tag:0 delegate:self];
        
        self.tabBar.frame = CGRectMake((self.view.frame.size.width-TabBarWidth)/2, 0, TabBarWidth, TabBarHeight);
        [self.tabBar setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.tabBar];
        
        // Select the first tab
        [self touchDownAtItemAtIndex:0];
        [self.tabBar selectItemAtIndex:0];
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark CustomTabBarDelegate
- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
    // Get the right data
    NSDictionary* data = [self.tabBarItems objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    return [UIImage imageNamed:[data objectForKey:@"image"]];
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
    return [self changeImage:[UIImage imageNamed:@"TabBarNipple.png"] toColor:self.color] ;
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
    viewController.view.frame = CGRectMake(0, TabBarHeight, self.view.frame.size.width, self.view.frame.size.height - TabBarHeight);
    viewController.view.clipsToBounds = YES;
    NSLog(@"Bounds: %@",NSStringFromCGRect(viewController.view.bounds));
    // Se the tag so we can find it later
    viewController.view.tag = SELECTED_VIEW_TAG;
    
    // Add the new view controller's view
    [self.view insertSubview:viewController.view aboveSubview:_tabBar];
}


#pragma mark - Helper
//change the image color to required color
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
- (void)backButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - HMCameraDelegate
- (void)cameraViewControllerShowPicker:(HMCameraViewController *)picker {
    NSLog(@"run delegate from RecipeViewController");
    [self presentViewController:picker animated:NO completion:^{
        [picker showPhotoPicker];
    }];
}

- (void)cameraViewControllerDidCancel:(HMCameraViewController *)picker {
    NSLog(@"dismiss pick controller from RecipeViewController... delegate");
    [self dismissViewControllerAnimated:NO completion:^{
        NSLog(@"!!! %f", self.view.frame.size.height);
    }];
    
}

@end
