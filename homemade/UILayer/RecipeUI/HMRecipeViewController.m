//
//  HMRecipeViewController.m
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeViewController.h"
#import "HMIngredientCell.h"
#import "HMRecipeStepCell.h"
#import "HMRecipeTipCell.h"

@interface HMRecipeViewController ()

@end

@implementation HMRecipeViewController

@synthesize photo,titleLabel,descLabel,saveButton,ingredientsView,stepsView,ingredients,steps,recipeDetailView,tips;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        
//    }
//    return self;
//}

- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
        
        self.recipeDetailView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 + 44) style:UITableViewStylePlain];
        
        //Add customized backgound color in top bounce area if needed
        //        CGRect frame =CGRectMake(0, -568, 320, 568);//for 4 inch device
        //        UIView* grayView = [[UIView alloc] initWithFrame:frame];
        //        grayView.backgroundColor = [UIColor redColor];
        //        [self.recipeDetailView addSubview:grayView];

        self.recipeDetailView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
        recipeDetailView.dataSource = self;
        recipeDetailView.delegate = self;
        [self.recipeDetailView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:self.recipeDetailView];

    
        
        //Add descripiton view
        //Right now hardcode for text. Later all those values are from feedItem.
        self.titleLabel = @"Title";
        self.descLabel =  @"First Paragraph: This is for testing testing testing!!!This is for testing testing testing!!!This is for testing testing testing!!!  \n\nSecond Paragraph: This is for testing testing testing!!! This is for testing testing testing!!!  This is for testing testing testing!!!  \n\nThird Paragraph: This is for testing testing testing!!!  This is for testing testing testing!!! This is for testing testing testing!!! ";

        UIFont *titleLabelFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        int titleHeight = [self calculateContentHeight:self.titleLabel withFont:titleLabelFont];

        
        UIFont *descLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
        int descHeight = [self calculateContentHeight:self.descLabel withFont:descLabelFont];
        
        int imageHeight = 260; //Image height is 240, 20 bottom margin in ImageView
        UIImageView *recipeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recipeTestImage.jpg"]];
    
        int marginUnderDes = 20;
        int descViewHeight =  imageHeight + titleHeight + descHeight + marginUnderDes;
        UIView *descriptionView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, descViewHeight)];
        
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imageHeight, 280, titleHeight)];
        tLabel.numberOfLines = 0;
        tLabel.text = self.titleLabel;
        tLabel.textColor = [UIColor blackColor];
        tLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
        tLabel.font = titleLabelFont;
        [descriptionView addSubview:tLabel];

        UILabel *dLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imageHeight + titleHeight, 280, descHeight)];
        dLabel.numberOfLines = 0;
        dLabel.text = self.descLabel;
        dLabel.textColor = [UIColor blackColor];
        dLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
        dLabel.font = descLabelFont;
        [descriptionView addSubview:recipeImageView];
        [descriptionView addSubview:dLabel];
        
        self.recipeDetailView.tableHeaderView = descriptionView;
        self.recipeDetailView.tableHeaderView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
        
        
        //For testing
        self.steps = [[NSMutableArray alloc] init];
        for (int i = 0; i<10;i++)
        {
            NSString *testString = [NSString stringWithFormat:@"Step %d",i];
            [self.steps addObject:testString];
        }
        self.ingredients = [[NSMutableArray alloc] init];
        for (int i = 0; i<10;i++)
        {
            NSString *testString = [NSString stringWithFormat:@"Ingredients %d",i];
            [self.ingredients addObject:testString];
        }
        self.tips = [[NSMutableArray alloc] init];
        for (int i = 0; i<5;i++)
        {
            NSString *testString = [NSString stringWithFormat:@"Tips %d",i];
            [self.tips addObject:testString];
        }


        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.recipeDetailView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.ingredients count];
            break;
            
        case 1:
            return [self.steps count];;
            break;
        case 2:
            return [self.tips count];
            break;
            
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            HMIngredientCell* cell = [[HMIngredientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMIngredientCell"];
            cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            cell.textLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            NSString *detailString = [self.ingredients objectAtIndex:indexPath.row];
            [cell.textLabel setText:detailString];
            return cell;
            break;
        }
        case 1:
        {
            HMRecipeStepCell* cell = [[HMRecipeStepCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMRecipeStepCell"];
            cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            cell.textLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            NSString *detailString = [self.steps objectAtIndex:indexPath.row];
            [cell.textLabel setText:detailString];
            return cell;
            break;
        }
        case 2:
        {
            HMRecipeTipCell* cell = [[HMRecipeTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMRecipeTipCell"];
            cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            cell.textLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            NSString *detailString = [self.tips objectAtIndex:indexPath.row];
            [cell.textLabel setText:detailString];
            return cell;
            break;
        }

        default:
            return nil;
            break;
    }
    
//
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recipeViewCell"];
//    cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
//    cell.textLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
//
//    [cell.textLabel setTextColor:[UIColor blackColor]];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//
//
//    if(indexPath.section == 0)
//    {
//        NSString *detailString = [self.steps objectAtIndex:indexPath.row];
//        [cell.textLabel setText:detailString];
//    }
//    else
//    {
//        [cell.textLabel setText:@"section 2"];
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //change to return dynamically
    switch (indexPath.section) {
        case 0:
        {
            return 20;
        }
        break;
        
        case 1:
        {
            return 50;
        }
        break;
            
        case 2:
        {
            return 50;
        }
            
        default:
            return 50;
            break;
    }
}

-(UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    //need to customize the position of UILabel insdie headerView
    CGRect frame = CGRectMake(20, 0, 280, 50);
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    switch (section)
    {
        case 0:
        {
            UILabel *ingredientTitleLabel = [[UILabel alloc] initWithFrame:frame];
            ingredientTitleLabel.text = @"Ingredients";
            ingredientTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            ingredientTitleLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            [headerView addSubview:ingredientTitleLabel];
            return headerView;
            break;
        }
        case 1:
        {
            UILabel *stepsTitleLabel = [[UILabel alloc] initWithFrame:frame];
            stepsTitleLabel.text = @"Steps";
            stepsTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            stepsTitleLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            [headerView addSubview:stepsTitleLabel];
            return headerView;
            break;
        }
        case 2:
        {
            UILabel *tipsTitleLabel = [[UILabel alloc] initWithFrame:frame];
            tipsTitleLabel.text = @"Tips";
            tipsTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            tipsTitleLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            [headerView addSubview:tipsTitleLabel];
            return headerView;
            break;
        }

        default:
            return  nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark - Helper

//calculate height based on content dynamically
-(float)calculateContentHeight:(NSString *)inputString withFont:(UIFont *)font
{
    CGSize maximumLabelSize = CGSizeMake(280, MAXFLOAT);
    //NSLineBreakByWordWrapping is deprecated in iOS6
    //    CGSize expectedLabelSize = [inputString sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    CGSize expectedLabelSize = [inputString sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];

    return expectedLabelSize.height;
}

@end
