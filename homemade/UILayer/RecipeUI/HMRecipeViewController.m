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
#import "HMDrinkPhotoViewController.h"

@interface HMRecipeViewController ()

@property (nonatomic, strong) CustomTabBar *tabBar;
@property (nonatomic, strong) HMAboutViewController *aboutViewController;
@property (nonatomic, strong) HMStepsViewController *stepsViewController;
@property (nonatomic, strong) HMDrinkPhotoViewController *photoViewController;
@property (nonatomic, strong) NSArray *tabBarItems;
@property (nonatomic, strong) UIColor *color;

@end


@implementation HMRecipeViewController

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Recipe view frame: %@", NSStringFromCGRect(self.view.frame));
    
    // Add a share navBarItem
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonClicked)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClicked)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Initialize three subViews
    self.aboutViewController = [[HMAboutViewController alloc] initWithRecipe:self.recipeObject];
    self.stepsViewController = [[HMStepsViewController alloc] initWithRecipe:self.recipeObject];
    self.photoViewController = [[HMDrinkPhotoViewController alloc] initWithRecipe:self.recipeObject];
    self.photoViewController.recipeViewController = self;
    
    // Place the tab bar at the top of our view
    _tabBarItems = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"about.png", @"image", self.aboutViewController, @"viewController", @"About", @"subTitle", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"steps.png", @"image", self.stepsViewController, @"viewController", @"Steps", @"subTitle", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"imadeit.png", @"image", self.photoViewController, @"viewController", @"Pics", @"subTitle", nil], nil];
    
    _tabBar = [[CustomTabBar alloc] initWithItemCount:3 itemSize:CGSizeMake(TabBarWidth/3, TabBarHeight) tag:0 delegate:self];
    self.tabBar.frame = CGRectMake(0, 0, TabBarWidth, TabBarHeight);
    [self.tabBar setBackgroundColor:[UIColor clearColor]];

    [self.navigationItem setTitleView:_tabBar];
    
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
    
    // Se the tag so we can find it later
    viewController.view.tag = SELECTED_VIEW_TAG;
    
    // Add the new view controller's view
    [self.view insertSubview:viewController.view aboveSubview:self.view];
}


#pragma UIbutton method
- (void)shareButtonClicked
{
    
}

- (void)leftDrawerButtonClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
