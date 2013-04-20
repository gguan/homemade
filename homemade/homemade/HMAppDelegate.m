//
//  HMAppDelegate.m
//  homemade
//
//  Created by Guan Guan on 3/15/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//


#import "HMAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

// Import view controllers
#import "SWRevealViewController.h"
#import "HMMenuViewController.h"
#import "HMFeedStreamViewController.h"
#import "HMSearchViewController.h"
#import "HMRecipeFeedViewController.h"

// Import parse 
#import <Parse/Parse.h>

// Other libraries
#import "Reachability.h"

@interface HMAppDelegate()<SWRevealViewControllerDelegate>

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;
@end


@implementation HMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // ****************************************************************************
    // Parse initialization
    [Parse setApplicationId:@"pdOSOMPSLbRBWodk6EQMePkVYo3fz9uljrn9FHNH"
                  clientKey:@"W176bVhYGUdEzF1gOaSabqjNujmV30UlIVOXD19n"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Make sure to update your URL scheme to match this facebook id. It should be "fbFACEBOOK_APP_ID" where FACEBOOK_APP_ID is your Facebook app's id.
    // You may set one up at https://developers.facebook.com/apps
    [PFFacebookUtils initializeFacebook];
    // ****************************************************************************
    
    // Clear app icon badge
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }
    
    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Set up our app's global UIAppearance
    [self setupAppearance];
    
    // Initialize panel controller
	UINavigationController *centerNavController = [[UINavigationController alloc] initWithRootViewController:[[HMRecipeFeedViewController alloc] init]];
    HMMenuViewController *menuController = [[HMMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    menuController.recipeFeedViewController = centerNavController;
	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:menuController frontViewController:centerNavController];
    revealController.rightViewController = [[HMSearchViewController alloc] init];
    
    revealController.delegate = self;
//    revealController.rearViewRevealWidth = 70.0f;
//    revealController.rightViewRevealWidth = 290.0f;
//    revealController.rearViewRevealOverdraw = 100.0f;
    revealController.frontViewController.view.layer.cornerRadius = 3.0f;
    revealController.frontViewController.view.clipsToBounds = YES;
    self.mainController = revealController;
    
    self.window.rootViewController = self.mainController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // TODO: handle fb login
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [FBSession.activeSession close];
}


#pragma mark - Customize Style
- (void)setupAppearance {
    UIImage *navBarImage = [UIImage imageNamed:@"nav-bar"];
    // draw a border on image
	UIGraphicsBeginImageContext(navBarImage.size);
    
	// draw original image into the context
	[navBarImage drawAtPoint:CGPointZero];
    
	// get the context for CoreGraphics
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
	// set stroking color and draw circle
	[[UIColor grayColor] setStroke];
    
    CGContextBeginPath (ctx);
    CGContextMoveToPoint(ctx, 0, 44);
    CGContextAddLineToPoint(ctx, 320, 44);
    CGContextStrokePath(ctx);
    
	// make image out of bitmap context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
	// free the context
	UIGraphicsEndImageContext();
    
    // set navigation bar title attributtes
    [[UINavigationBar appearance] setBackgroundImage:newImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor blackColor], UITextAttributeTextColor,
     [UIColor whiteColor], UITextAttributeTextShadowColor,
     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
     [UIFont fontWithName:@"Copperplate-Bold" size:22], UITextAttributeFont, nil]
    ];
    
}


#pragma mark - ()
- (void)monitorReachability {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostname: @"api.parse.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}


@end
