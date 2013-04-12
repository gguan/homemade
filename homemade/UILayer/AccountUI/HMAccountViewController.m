//
//  HMAccountViewController.m
//  homemade
//
//  Created by Guan Guan on 3/18/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMAccountViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface HMAccountViewController ()
@property (nonatomic, strong) NSDictionary *userProfile;
@end

@implementation HMAccountViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.title = @"Account";
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    // Left bar button
    UIImageView *leftBtnImage = [[UIImageView alloc] initWithFrame:CGRectMake(12.0f, 0.0f, 20.0f, 20.0f)];
    [leftBtnImage setImage:[UIImage imageNamed:@"icons_menu.png"]];
    leftBtnImage.alpha = 0.6f;
    leftBtnImage.layer.shadowColor = [UIColor whiteColor].CGColor;
    leftBtnImage.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    leftBtnImage.contentMode = UIViewContentModeScaleAspectFit;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(12.0f, 12.0f, 32.0f, 20.0f);
    [leftButton addSubview:leftBtnImage];
    [leftButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    
    
    if ([PFUser currentUser]) {
        self.userProfile = [PFUser currentUser][@"profile"];
    }
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            self.userProfile = @{@"facebookId": facebookID,
                                 @"name": userData[@"name"],
                                 @"location": userData[@"location"][@"name"],
                                 @"gender": userData[@"gender"],
                                 @"birthday": userData[@"birthday"],
                                 @"relationship": userData[@"relationship_status"],
                                 @"pictureURL": [pictureURL absoluteString]};
            
            [[PFUser currentUser] setObject:self.userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            

        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");

        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        NSString *text = @"Sign up and start sharing your story with your friends.";
        CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f] constrainedToSize:CGSizeMake( 255.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake( ([UIScreen mainScreen].bounds.size.width - textSize.width)/2.0f, 20.0f, textSize.width, textSize.height)];
        [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
        [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [textLabel setNumberOfLines:0];
        [textLabel setText:text];
        [textLabel setTextColor:[UIColor colorWithRed:214.0f/255.0f green:206.0f/255.0f blue:191.0f/255.0f alpha:1.0f]];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:textLabel];
    } else if (indexPath.row == 1) {
        UIButton *fbButton = [[UIButton alloc] initWithFrame:CGRectMake(81, 20, 159, 40)];
        [fbButton setTitle:@"FB Login" forState:UIControlStateNormal];
        [fbButton setBackgroundImage:[UIImage imageNamed:@"FacebookSDKResources.bundle/FBLoginView/images/login-button-small.png"] forState:UIControlStateNormal];
        [fbButton addTarget:self action:@selector(loginButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:fbButton];
    } else {
        if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            NSLog(@"User exist! %@", self.userProfile[@"name"]);
            NSString *text = self.userProfile[@"name"];
            CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f] constrainedToSize:CGSizeMake( 255.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];

            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake( ([UIScreen mainScreen].bounds.size.width - textSize.width)/2.0f, 20.0f, textSize.width, textSize.height)];
            [textLabel setTextColor:[UIColor colorWithRed:214.0f/255.0f green:206.0f/255.0f blue:191.0f/255.0f alpha:1.0f]];
            [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
            [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [textLabel setNumberOfLines:0];
            [textLabel setText:text];
            [textLabel setTextColor:[UIColor colorWithRed:214.0f/255.0f green:206.0f/255.0f blue:191.0f/255.0f alpha:1.0f]];
            [textLabel setBackgroundColor:[UIColor clearColor]];
            [textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell addSubview:textLabel];
        }

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - FB login

/* Login to facebook method */
- (void)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"email"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            
        } else {
            NSLog(@"User with facebook logged in!");
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}


@end
