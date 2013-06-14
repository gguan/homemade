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
#import "HMRecipeFeedViewController.h"
#import "HMRecipeViewController.h"
#import "HMSearchViewController.h"
// Import parse 
#import <Parse/Parse.h>

// Other libraries
#import "Reachability.h"
#import "SVProgressHUD.h"

@interface HMAppDelegate() {
    NSMutableData *_data;
    BOOL firstLaunch;
}

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
#ifdef DEBUG
    [Parse setApplicationId:@"pdOSOMPSLbRBWodk6EQMePkVYo3fz9uljrn9FHNH"
                  clientKey:@"W176bVhYGUdEzF1gOaSabqjNujmV30UlIVOXD19n"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
#else
    [Parse setApplicationId:@"pdOSOMPSLbRBWodk6EQMePkVYo3fz9uljrn9FHNH"
                  clientKey:@"W176bVhYGUdEzF1gOaSabqjNujmV30UlIVOXD19n"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
#endif
    
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
//    self.mainController = [[HMSearchViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.mainController];
    [self.window makeKeyAndVisible];

    // Display login view
    if (![PFUser currentUser]) {
        [self presentLoginViewControllerAnimated:YES];
    }

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
    if (DEVICE_VERSION_7) {
        
//        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//        [[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];

//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbarMask.png"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
//        [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
            }
    
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

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Process user facebook profile image");
    [HMUtility processFacebookProfilePictureData:_data];
}


#pragma mark - LoginIn delegate

/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {

    // Retrieve user information from facebook, and store/update in local file system
    [SVProgressHUD showWithStatus:@"Loading" maskType: SVProgressHUDMaskTypeBlack];
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [self facebookRequestDidLoad:result];
        } else {
            [self facebookRequestDidFailWithError:error];
        }
    }];
    
    [SVProgressHUD dismiss];
    [self.mainController dismissViewControllerAnimated:YES completion:NULL];
}

/// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"Login failed"];
    NSLog(@"Login failed. Error: %@", error);
}

#pragma mark - ()
- (BOOL)handleActionURL:(NSURL *)url {
    
    if ([[url fragment] rangeOfString:@"^recipe/[A-Za-z0-9]{10}$" options:NSRegularExpressionSearch].location != NSNotFound) {
        NSString *recipeObjectId = [[url fragment] substringWithRange:NSMakeRange(8, 14)];
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

- (void)facebookRequestDidLoad:(id)result {
    // This method is called for the user's /me profile.
    NSLog(@"%@", result);
    
    PFUser *user = [PFUser currentUser];
    
    if (user) {
        [SVProgressHUD showWithStatus:@"Creating Profile" maskType: SVProgressHUDMaskTypeBlack];
        
        // display name
        NSString *facebookName = result[@"name"];
        if (facebookName && [facebookName length] != 0) {
            [user setObject:facebookName forKey:kHMUserDisplayNameKey];
        } else {
            [user setObject:@"Someone" forKey:kHMUserDisplayNameKey];
        }
        
        // facebook id
        NSString *facebookId = result[@"id"];
        if (facebookId && [facebookId length] != 0) {
            [user setObject:facebookId forKey:kHMUserFacebookIDKey];
        }
        
        // email
        NSString *email = result[@"email"];
        if (email && [email length] != 0) {
            user.email = email;
        }
        
        [user saveEventually];
        
        // Download user's profile picture
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", facebookId]];
        NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
        [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
        
        [SVProgressHUD dismiss];
    }
    

}

- (void)facebookRequestDidFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    [SVProgressHUD showErrorWithStatus:@"Facebook error"];
    
    if ([PFUser currentUser]) {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The Facebook token was invalidated. Logging out.");
            [self logout];
        }
    }
   
}

- (void)logout {
    // clear cache
    [[HMCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHMUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHMUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by removing the user association from the current installation.
//    [[PFInstallation currentInstallation] removeObjectForKey:kHMInstallationUserKey];
//    [[PFInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
    [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:NO];
    [self presentLoginViewControllerAnimated:NO];
    
}


@end
