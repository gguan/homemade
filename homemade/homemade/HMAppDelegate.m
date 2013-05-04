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
#import "HMLoginViewController.h"
#import "HMRecipeViewController.h"
#import "HMRecipeFeedViewController.h"

// Import parse 
#import <Parse/Parse.h>

// Other libraries
#import "Reachability.h"

@interface HMAppDelegate()

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
    self.mainController = [[HMRecipeFeedViewController alloc] init];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.mainController];
    [self.window makeKeyAndVisible];

    // Display login view
    if (![PFUser currentUser]) {
        [self presentLoginViewControllerAnimated:YES];
    }
//    [[HMCache sharedCache] clear];
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // TODO: handle fb login
    if ([self handleActionURL:url]) {
        return YES;
    }
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

- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    HMLoginViewController *loginViewController = [[HMLoginViewController alloc] init];
    [loginViewController setDelegate:self];
    loginViewController.fields = PFLogInFieldsFacebook;
    loginViewController.facebookPermissions = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"email", @"publish_actions" ];
    
    [self.mainController presentViewController:loginViewController animated:animated completion:nil];
}

#pragma mark - LoginIn delegate

/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
//    [user save];
    // TODO: retrieve user information from facebook, and store/update in local file system
    [self.mainController dismissViewControllerAnimated:YES completion:NULL];
}

/// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Login failed. Error: %@", error);
}

#pragma mark - ()
- (BOOL)handleActionURL:(NSURL *)url {
    
    if ([[url fragment] rangeOfString:@"^pic/[A-Za-z0-9]{10}$" options:NSRegularExpressionSearch].location != NSNotFound) {
        NSString *recipeObjectId = [[url fragment] substringWithRange:NSMakeRange(4, 10)];
            if (recipeObjectId && recipeObjectId.length > 0) {
                [self shouldNavigateToRecipe:[PFObject objectWithoutDataWithClassName:kHMRecipeClassKey objectId:recipeObjectId]];
                return YES;
            }
    }
    
    return NO;
}

- (void)shouldNavigateToRecipe:(PFObject *)targetRecipe {
    for (PFObject *recipe in self.mainController.objects) {
        if ([recipe.objectId isEqualToString:targetRecipe.objectId]) {
            targetRecipe = recipe;
            break;
        }
    }
    
    // if we have a local copy of this photo, this won't result in a network fetch
    [targetRecipe fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            UINavigationController *homeNavigationController = self.mainController.navigationController;
            
            HMRecipeViewController *detailViewController = [[HMRecipeViewController alloc] initWithRecipe:object];
            [homeNavigationController pushViewController:detailViewController animated:YES];
        }
    }];
}

@end
