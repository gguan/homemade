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
#import "HMSignUpViewController.h"
#import "HMRecipeFeedViewController.h"
#import "HMLeftPanelViewController.h"
#import "HMRecipeViewController.h"
#import "MMDrawerController.h"
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
    // Override point for customization after application launch.
    
    // ****************************************************************************
    // Parse initialization
#ifdef DEBUG
    [Parse setApplicationId:@"pdOSOMPSLbRBWodk6EQMePkVYo3fz9uljrn9FHNH"
                  clientKey:@"W176bVhYGUdEzF1gOaSabqjNujmV30UlIVOXD19n"];
#else
    [Parse setApplicationId:@"pdOSOMPSLbRBWodk6EQMePkVYo3fz9uljrn9FHNH"
                  clientKey:@"W176bVhYGUdEzF1gOaSabqjNujmV30UlIVOXD19n"];
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
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
    
    // Register for remote notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                    UIRemoteNotificationTypeAlert|
                                                    UIRemoteNotificationTypeSound];
    
    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Set up our app's global UIAppearance
    [self setupAppearance];
    
    // Initialize panel controller
    HMLeftPanelViewController *leftSidePanelController = [[HMLeftPanelViewController alloc] init];
    leftSidePanelController.recipeFeedViewController = [[HMRecipeFeedViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:leftSidePanelController.recipeFeedViewController];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:navigationController leftDrawerViewController:leftSidePanelController];
    [drawerController setMaximumLeftDrawerWidth:240.0f];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setShouldStretchDrawer:NO];
    
    self.mainController = leftSidePanelController.recipeFeedViewController;
    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];

    // Display login view
    if (!([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])) {
        [self presentLoginViewControllerAnimated:YES];
    }

    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
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
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    [FBAppEvents activateApp];
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [FBSession.activeSession close];
}


#pragma mark - Customize Style
- (void)setupAppearance {
    
    [self.window.layer setCornerRadius:0.0f];
    [self.window.layer setMasksToBounds:YES];
    self.window.layer.opaque = YES;
    
    if (DEVICE_VERSION_7) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor whiteColor],UITextAttributeTextColor,
                                                              [UIColor colorWithWhite:0.0f alpha:0.750f],
                                                              UITextAttributeTextShadowColor,
                                                              [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],
                                                              UITextAttributeTextShadowOffset,
                                                              nil]];
//        [[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
//        [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        //  [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:39.0f/255.0f green:44.0f/255.0f blue:46.0f/255.0f alpha:1.0f]];
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    } else {
        
        
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor whiteColor],UITextAttributeTextColor,
                                                              [UIColor colorWithWhite:0.0f alpha:0.750f],
                                                              UITextAttributeTextShadowColor,
                                                              [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],
                                                              UITextAttributeTextShadowOffset,
                                                              nil]];
        
        // navbar button
        [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal];
        [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateHighlighted];
        // navbar back button
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage alloc] init]
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage alloc] init]
                                                          forState:UIControlStateSelected
                                                        barMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                               UITextAttributeTextColor: [UIColor whiteColor],
                                                               UITextAttributeTextShadowColor: [UIColor colorWithWhite:0.0f alpha:0.750f],
                                                               UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]
                                                               } forState:UIControlStateNormal];
        
        [[UISearchBar appearance] setTintColor:[UIColor colorWithRed:39.0f/255.0f green:44.0f/255.0f blue:46.0f/255.0f alpha:1.0f]];
        
        
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
    // Customize the Log In View Controller
    HMLoginViewController *logInViewController = [[HMLoginViewController alloc] init];
    logInViewController.delegate = self;
//    logInViewController.fields = PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton;
    logInViewController.fields = PFLogInFieldsFacebook;
    logInViewController.facebookPermissions = @[ @"user_about_me", @"user_relationships", @"public_profile", @"user_location", @"email", @"publish_actions" ];
    
    // Customize the Sign Up View Controller
    HMSignUpViewController *signUpViewController = [[HMSignUpViewController alloc] init];
    signUpViewController.delegate = self;
    signUpViewController.fields = PFSignUpFieldsDefault;
    logInViewController.signUpController = signUpViewController;

    
    [self.mainController presentViewController:logInViewController animated:animated completion:nil];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([PFUser currentUser] && ![[PFUser currentUser] objectForKey:kHMUserProfilePicMediumKey]) {
        NSLog(@"Process user facebook profile image");
        [HMUtility processFacebookProfilePictureData:_data];
    }
}


#pragma mark - LoginIn delegate
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [self facebookRequestDidLoad:result];
        } else {
            [self facebookRequestDidFailWithError:error];
        }
    }];
    
    [self.mainController dismissViewControllerAnimated:YES completion:^{
        ((HMLeftPanelViewController *)((MMDrawerController *)self.window.rootViewController).leftDrawerViewController).currentIndex = 0;
    }];
}

/// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"Login failed"];
    NSLog(@"Login failed. Error: %@", error);
}



#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self.mainController dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
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
        // fist and last name
        NSString *firstName = result[@"first_name"];
        if (firstName && [firstName length] != 0) {
            [user setObject:firstName forKey:kHMUserFirstNameKey];
        } else {
            [user setObject:@"Some" forKey:kHMUserFirstNameKey];
        }
        NSString *lastName = result[@"last_name"];
        if (lastName && [lastName length] != 0) {
            [user setObject:lastName forKey:kHMUserLastNameKey];
        } else {
            [user setObject:@"One" forKey:kHMUserLastNameKey];
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
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainController];
    __weak HMAppDelegate *weakSelf = self;
    [(MMDrawerController *)self.window.rootViewController setCenterViewController:navigationController withCloseAnimation:NO completion:^(BOOL success) {
        [weakSelf presentLoginViewControllerAnimated:NO];
    }];
    
}

// Handling push notification
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


@end
