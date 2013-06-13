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

#define RecipeImageViewHeight 200

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
    
    // Custom initialization
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Init recipe image view
    self.recipeImageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, RecipeImageViewHeight)];
    self.recipeImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.recipeImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.recipeImageView.clipsToBounds = YES;
    [self.recipeImageView setFile:[self.recipeObject objectForKey:kHMRecipePhotoKey]];
    [self.recipeImageView loadInBackground];

    // Init title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 300, 30)];
    [titleLabel setText:[self.recipeObject objectForKey:kHMRecipeTitleKey]];
    if (DEVICE_VERSION_7) {
        [titleLabel setFont:[UIFont preferredFontForTextStyle:@"UIFontTextStyleHeadline1"]];
    } else {
        [titleLabel setFont:[HMUtility appFontOfSize:21.0f]];
    }
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
    // Init description label
    UILabel *aboutLabel = [[UILabel alloc] init];
    NSString *aboutString = [self.recipeObject objectForKey:kHMRecipeOverviewKey];
    CGSize textSize = [aboutString sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    [aboutLabel setFrame:CGRectMake(10, 260, textSize.width, textSize.height)];
    [aboutLabel setText:aboutString];
    if (DEVICE_VERSION_7) {
        [aboutLabel setFont:[UIFont preferredFontForTextStyle:@"UIFontTextStyleBody"]];
    } else {
        [aboutLabel setFont:[HMUtility appFontOfSize:15.0f]];
    }
    [aboutLabel setTextColor:[UIColor darkGrayColor]];
    [aboutLabel setBackgroundColor:[UIColor clearColor]];
    [aboutLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [aboutLabel setNumberOfLines:0];
    
    
    // Init table view header
    UIView *headContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50 + RecipeImageViewHeight + textSize.height + 30)];
    [headContainerView addSubview:titleLabel];
    [headContainerView addSubview:self.recipeImageView];
    [headContainerView addSubview:aboutLabel];
    self.tableView.tableHeaderView = headContainerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
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
    return 20.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"IngredientCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HMIngredientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSDictionary *ingredient = [self.ingredients objectAtIndex:indexPath.row];
    NSString *name = [ingredient objectForKey:@"name"];
    NSString *amount = [ingredient objectForKey:@"amount"];
    [cell.textLabel setText:[NSString stringWithFormat:@"∙ %@ - %@", name, amount]];
    
    return cell;
}

@end
