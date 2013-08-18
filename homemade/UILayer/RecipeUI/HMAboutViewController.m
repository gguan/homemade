//
//  HMIngredientViewController.m
//  homemade
//
//  Created by Xiaodi Xing on 4/30/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMAboutViewController.h"
#import "HMIngredientCell.h"
#import "UIImageView+Addition.h"
#import "UIImage+ColorImage.h"
#import <QuartzCore/QuartzCore.h>

#define AboutViewImageHeight 220

@interface HMAboutViewController ()
@property (nonatomic, strong) PFImageView *recipeImageView;
@property (nonatomic, strong) PFObject *recipeObject;
@property (nonatomic, strong) NSArray *ingredients;
@end

@implementation HMAboutViewController

- (id)initWithRecipe:(PFObject*)recipeObject{
    self = [super init];
    if (self) {
        self.recipeObject = recipeObject;
        self.ingredients = [recipeObject objectForKey:kHMRecipeIngredientsKey];
     }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (DEVICE_VERSION_7) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 20);
    } else {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    NSLog(@"About view frame: %@", NSStringFromCGRect(self.view.frame));
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:238.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
    [self.tableView setBackgroundView:backgroundView];
    self.view.clipsToBounds = YES;

//    self.tableView.contentInset = UIEdgeInsetsMake(80.0f, 0, 0, 0);
    
    // Custom initialization
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Init recipe image view
    self.recipeImageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, AboutViewImageHeight)];
    self.recipeImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.recipeImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.recipeImageView.clipsToBounds = YES;
    [self.recipeImageView setFile:[self.recipeObject objectForKey:kHMRecipePhotoKey]];
    [self.recipeImageView loadInBackground];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320, 0.5f)];
    divider.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];

    UIView *divider0 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, AboutViewImageHeight, 320, 0.5f)];
    divider0.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];
    
    // Init title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, AboutViewImageHeight+20 , 240, 50)];
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20.0f];
    [titleLabel setText:[[self.recipeObject objectForKey:kHMRecipeTitleKey] uppercaseString]];
    [titleLabel setTextColor:[UIColor colorWithRed:63.0f/255.0f green:72.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    // avatar
    PFImageView *avatar = [[PFImageView alloc] initWithFrame:CGRectMake(240, AboutViewImageHeight - 15, 60, 60)];
    avatar.clipsToBounds = YES;
    avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    avatar.layer.borderWidth = 2.0f;
    avatar.clipsToBounds = NO;
    avatar.layer.shadowOpacity = 0.4f;
    avatar.layer.shadowColor = [UIColor blackColor].CGColor;
    avatar.layer.shadowOffset = CGSizeMake(0.1f,0.1f);

    
    PFUser *user = [self.recipeObject objectForKey:kHMRecipeUserKey];
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            [avatar setFile:[user objectForKey:kHMUserProfilePicSmallKey]];
            [avatar loadInBackground];
        }
    }];
    
    UIView *divider1 = [[UIView alloc] initWithFrame:CGRectMake(15.0f, AboutViewImageHeight+79, 290, 1.0f)];
    divider1.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(270.0f, AboutViewImageHeight+20, 1.0f, 60.0f)];
    verticalLine.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];

    
    // Init description label
    UILabel *aboutLabel = [[UILabel alloc] init];
    NSString *aboutString = [self.recipeObject objectForKey:kHMRecipeOverviewKey];
    CGSize textSize = [aboutString sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    [aboutLabel setFrame:CGRectMake(15, AboutViewImageHeight + 90, textSize.width, textSize.height)];
    [aboutLabel setText:aboutString];
    [aboutLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [aboutLabel setTextColor:[UIColor colorWithRed:69.0f/255.0f green:78.0f/255.0f blue:81.0f/255.0f alpha:1.0f]];
    [aboutLabel setBackgroundColor:[UIColor clearColor]];
    [aboutLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [aboutLabel setNumberOfLines:0];
    
    UIView *divider2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, AboutViewImageHeight+textSize.height+109.5f, 320, 0.5f)];
    divider2.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];

    // Init table view header
    UIView *headContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  AboutViewImageHeight+110+textSize.height)];
    [headContainerView addSubview:self.recipeImageView];
    [headContainerView addSubview:divider];
    [headContainerView addSubview:divider0];
    [headContainerView addSubview:titleLabel];
    [headContainerView addSubview:avatar];
    [headContainerView addSubview:divider1];
    [headContainerView addSubview:divider2];
    [headContainerView insertSubview:verticalLine belowSubview:avatar];
    [headContainerView addSubview:aboutLabel];
    self.tableView.tableHeaderView = headContainerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5f)];
    footerView.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];
    self.tableView.tableFooterView = footerView;
    
    [self.recipeImageView addDetailShow];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.ingredients) {
        return [self.ingredients count];
    } else {
        return 0;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"IngredientCell";
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IngredientHeader"];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
        header.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
        UIImageView *icon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"icn40-list.png"] changeImageToColor:[UIColor colorWithRed:63.0f/255.0f green:72.0f/255.0f blue:75.0f/255.0f alpha:1.0f]]];
        [icon setFrame:CGRectMake(28, 19, 12, 12)];
        [header addSubview:icon];
        UILabel *ingredientLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 5, 250, 39)];
        [ingredientLabel setText:@"Ingredients"];
        [ingredientLabel setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:17]];
        [ingredientLabel setTextColor:[UIColor colorWithRed:63.0f/255.0f green:72.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
        [ingredientLabel setBackgroundColor:[UIColor clearColor]];
        [ingredientLabel setAdjustsFontSizeToFitWidth:YES];
        [header addSubview:ingredientLabel];
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(25, 39, 270, 1)];
        divider.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];
        [header addSubview:divider];
        [cell addSubview:header];
        return cell;
    } else {
        HMIngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[HMIngredientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        NSDictionary *ingredient = [self.ingredients objectAtIndex:indexPath.row - 1];
        NSString *name = [ingredient objectForKey:@"name"];
        NSString *amount = [ingredient objectForKey:@"amount"];
        [cell.nameLabel setText:name];
        [cell.quantityLabel setText:amount];
        return cell;
    }
    
}

@end
