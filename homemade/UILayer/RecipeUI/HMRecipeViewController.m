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
#import "HMRecipeActionView.h"
#import "HMCommentViewController.h"

static int ActionViewHeight = 80.0f;

@interface HMRecipeViewController ()

@property (nonatomic, strong) CustomTabBar *tabBar;
@property (nonatomic, strong) HMAboutViewController *aboutViewController;
@property (nonatomic, strong) HMStepsViewController *stepsViewController;
@property (nonatomic, strong) HMDrinkPhotoViewController *photoViewController;
@property (nonatomic, strong) NSArray *tabBarItems;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) HMRecipeActionView *actionView;

@end


@implementation HMRecipeViewController {
    BOOL isExpanded;
    BOOL enableSaveButton;
}

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
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(actionButtonClicked)];
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
    
    isExpanded = NO;
    enableSaveButton = YES;
    
    self.actionView = [[HMRecipeActionView alloc] initWithFrame:CGRectMake(0, -ActionViewHeight, 320, ActionViewHeight)];
    [self.view addSubview:self.actionView];
    
    [self.actionView.saveButton addTarget:self action:@selector(didTapSaveButton) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView.commentButton addTarget:self action:@selector(didTapCommentButton) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView.shareButton addTarget:self action:@selector(didTapShareButton) forControlEvents:UIControlEventTouchUpInside];
    [self updateSaveButton];
    
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
- (void)actionButtonClicked
{
    CGRect bounds = self.view.bounds;
    [self.view setBounds:bounds];
    if (isExpanded) {
        bounds.origin.y += ActionViewHeight;
        isExpanded = NO;
    } else {
        bounds.origin.y -= ActionViewHeight;
        isExpanded = YES;
    }
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view setBounds:bounds];
    } completion:^(BOOL finished) {}];
    
}

- (void)leftDrawerButtonClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Button action

- (void)didTapSaveButton {
    NSLog(@"Tap save button!");
    if (!enableSaveButton) {
        return;
    }
    
    
    
    // When user tap the button, we temperaly disable the button until server and cache are updated.
    enableSaveButton = NO;
    
    BOOL saved = !self.actionView.saveButton.selected;
    
    // update sever
    if (saved) {
        [HMUtility saveRecipeInBackground:self.recipeObject block:^(BOOL succeeded, NSError *error) {
            enableSaveButton = YES;
            [self.actionView.saveButton setSelected:succeeded];
            if (succeeded) {
                [[HMCache sharedCache] incrementSaverCountForRecipe:self.recipeObject];
                [[HMCache sharedCache] setRecipeIsSavedByCurrentUser:self.recipeObject saved:YES];
            }
        }];
    } else {
        [HMUtility unSaveRecipeInBackground:self.recipeObject block:^(BOOL succeeded, NSError *error) {
            enableSaveButton = YES;
            [self.actionView.saveButton setSelected:!succeeded];
            if (succeeded) {
                [[HMCache sharedCache] decrementSaverCountForRecipe:self.recipeObject];
                [[HMCache sharedCache] setRecipeIsSavedByCurrentUser:self.recipeObject saved:NO];
            }
        }];
    }
    [self updateSaveButton];
}

- (void)updateSaveButton {
    if ([[HMCache sharedCache] isSavedByCurrentUser:self.recipeObject]) {
        [self.actionView.saveButton setSelected:YES];
        [self.actionView.saveLabel setText:@"SAVED"];
    } else {
        [self.actionView.saveButton setSelected:NO];
        [self.actionView.saveLabel setText:@"SAVE"];
    }
}


- (void)didTapCommentButton {
    
    NSLog(@"Comment button tapped.");
    HMCommentViewController *commentView = [[HMCommentViewController alloc] initWithPFObject:self.recipeObject andType:kHMCommentTypeRecipe];
    [[self navigationController] pushViewController:commentView animated:YES];
}

// Sent to the delegate when the share button is tapped
// @param photo the PFObject for the photo that will be commented on
- (void)didTapShareButton {
    
    // First attempt: Publish using the Facenook Share dialog
    FBAppCall *call = [self publishWithShareDialog:self.recipeObject];
    
    // Second fallback: Publish using the iOS6 OS Integrated Share dialog
    BOOL displayedNativeDialog = YES;
    if (!call) {
        [self publishWithOSIntegratedShareDialog:self.recipeObject];
    }
    
    // Third fallback: Publish using either the Graph API or the Web Dialog
    if (!call && !displayedNativeDialog) {
        [self publishWithWebDialog:self.recipeObject];
    }
}

- (BOOL) publishWithOSIntegratedShareDialog:(PFObject *)recipe {
    PFFile *imageFile = [recipe objectForKey:kHMRecipePhotoKey];
    return [FBDialogs
            presentOSIntegratedShareDialogModallyFrom:self
            initialText: [recipe objectForKey:kHMRecipeTitleKey]
            image: [UIImage imageWithData:[imageFile getData]]
            url:nil
            handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                // Only show the error if it is not due to the dialog
                // not being supported, otherwise ignore because our fallback
                // will show the share view controller.
                if ([[error userInfo][FBErrorDialogReasonKey]
                     isEqualToString:FBErrorDialogNotSupported]) {
                    return;
                }
                if (error) {
                    [self showAlert:[self checkErrorMessage:error]];
                } else if (result == FBNativeDialogResultSucceeded) {
                    [self showAlert:@"Posted successfully."];
                }
            }];
}

/*
 * Share using the Web Dialog
 */
- (void) publishWithWebDialog:(PFObject *)recipe {
    // Put together the dialog parameters
    
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     [recipe objectForKey:kHMRecipeTitleKey], @"name",
     [recipe objectForKey:kHMRecipeOverviewKey], @"description",
     // recipeLink, @"link", ! we should have a website to give a facebook share link
     [(PFFile *)[recipe objectForKey:kHMRecipePhotoKey] url], @"picture",
     nil];
    
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             [self showAlert:[self checkErrorMessage:error]];
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     [self showAlert:[self checkPostId:urlParams]];
                 }
             }
         }
     }];
}

/*
 * Share using the Facebook native Share Dialog
 */
- (FBAppCall *) publishWithShareDialog:(PFObject *)recipe {
    // Set up the dialog parameters
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:[(PFFile *)[recipe objectForKey:kHMRecipePhotoKey] url]];
    params.picture = [NSURL URLWithString:[(PFFile *)[recipe objectForKey:kHMRecipePhotoKey] url]];
    params.name = [recipe objectForKey:kHMRecipeTitleKey];
    params.description = [recipe objectForKey:kHMRecipeOverviewKey];
    // Set this flag on to enable the Share Dialog beta feature
    //    [FBSettings  enableBetaFeature:FBBetaFeaturesShareDialog];
    return [FBDialogs presentShareDialogWithParams:params
                                       clientState:nil
                                           handler:
            ^(FBAppCall *call, NSDictionary *results, NSError *error) {
                if(error) {
                    // If there's an error show the relevant message
                    [self showAlert:[self checkErrorMessage:error]];
                } else {
                    // Check if cancel info is returned and log the event
                    if (results[@"completionGesture"] &&
                        [results[@"completionGesture"] isEqualToString:@"cancel"]) {
                        NSLog(@"User canceled story publishing.");
                    } else {
                        // If the post went through show a success message
                        [self showAlert:[self checkPostId:results]];
                    }
                }
                
            }];
}


#pragma mark - Helper methods
/*
 * Helper method to show alert results or errors
 */
- (NSString *)checkErrorMessage:(NSError *)error {
    NSString *errorMessage = @"";
    if (error.fberrorUserMessage) {
        errorMessage = error.fberrorUserMessage;
    } else {
        errorMessage = @"Operation failed due to a connection problem, retry later.";
    }
    return errorMessage;
}

/*
 * Helper method to check for the posted ID
 */
- (NSString *) checkPostId:(NSDictionary *)results {
    NSString *message = @"Posted successfully.";
    // Share Dialog
    NSString *postId = results[@"postId"];
    if (!postId) {
        // Web Dialog
        postId = results[@"post_id"];
    }
    if (postId) {
        message = [NSString stringWithFormat:@"Posted story, id: %@", postId];
    }
    return message;
}

/*
 * Helper method to parse URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

/*
 * Helper method to show an alert
 */
- (void)showAlert:(NSString *) alertMsg {
    if (![alertMsg isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Result"
                                    message:alertMsg
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}



@end
