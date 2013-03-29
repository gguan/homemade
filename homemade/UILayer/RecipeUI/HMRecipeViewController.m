//
//  HMRecipeViewController.m
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#define titleLabelWidth 280
#define descLabelWidth 280
#define stepLabelWidth 250
#define tipLabelWidth 280

#import "HMRecipeViewController.h"
#import "HMIngredientCell.h"
#import "HMRecipeStepCell.h"
#import "HMRecipeTipCell.h"

@interface HMRecipeViewController ()

@end

@implementation HMRecipeViewController

@synthesize photo = _photo;
@synthesize titleLabel = _titleLabel;
@synthesize descLabel = _descLabel;
@synthesize saveButton = _saveButton;
@synthesize ingredientsView = _ingredientsView;
@synthesize stepsView = _stepsView;
@synthesize ingredients = _ingredients;
@synthesize steps = _steps;
@synthesize recipeDetailView = _recipeDetailView;
@synthesize tips = _tips;
@synthesize stepsLabelHeight = _stepsLabelHeight;
@synthesize tipsLabelHeight = _tipsLabelHeight;
@synthesize ingredientsQuantity = _ingredientsQuantity;


- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
        
        //Here 480+22 will be changed based on device, 3.5inch or 4.0inch
        self.recipeDetailView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 + 22) style:UITableViewStylePlain];
        
        //Add customized backgound color in top bounce area if needed
        //        CGRect frame =CGRectMake(0, -568, 320, 568);//for 4 inch device
        //        UIView* grayView = [[UIView alloc] initWithFrame:frame];
        //        grayView.backgroundColor = [UIColor redColor];
        //        [self.recipeDetailView addSubview:grayView];

        self.recipeDetailView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
        self.recipeDetailView.dataSource = self;
        self.recipeDetailView.delegate = self;
        [self.recipeDetailView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:self.recipeDetailView];

    
        
        //Add descripiton view
        //Right now hardcode for text. Later all those values are from feedItem.
        self.titleLabel = @"Title";
        self.descLabel =  @"First Paragraph: This is for testing testing testing!!!This is for testing testing testing!!!This is for testing testing testing!!!  \n\nSecond Paragraph: This is for testing testing testing!!! This is for testing testing testing!!!  This is for testing testing testing!!!  \n\nThird Paragraph: This is for testing testing testing!!!  This is for testing testing testing!!! This is for testing testing testing!!! ";

        UIFont *titleLabelFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        int titleHeight = [self calculateContentHeight:self.titleLabel withFont:titleLabelFont withLabelWidth:titleLabelWidth];

        UIFont *descLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
        int descHeight = [self calculateContentHeight:self.descLabel withFont:descLabelFont withLabelWidth:descLabelWidth];
        
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
        
        self.stepsLabelHeight = [[NSMutableArray alloc] init];
        self.tipsLabelHeight = [[NSMutableArray alloc] init];
        
        //For testing
        //Ingredients
        self.ingredients = [[NSMutableArray alloc] init];
        for (int i = 0; i<10;i++)
        {
            //Hardcode for testing
            NSString *testString = [NSString stringWithFormat:@"Name"];
            NSNumber* quantity = [[NSNumber alloc] initWithInt:100];
            NSMutableDictionary *ingredientDict = [[NSMutableDictionary alloc] init];
            [ingredientDict setObject:testString forKey:@"name"];
            [ingredientDict setObject:quantity forKey:@"quantity"];

            [self.ingredients addObject:ingredientDict];
        }
        
        //Steps
        self.steps = [[NSMutableArray alloc] init];
        for (int i = 0; i<10;i++)
        {
            NSString *testString = [NSString stringWithFormat:@"%d: This is the steps descrpiton for each steps, testing testing testing testing testing!This is the steps descrpiton for each steps, testing testing testing testing testing! ",i];
            [self.steps addObject:testString];
            
            UIFont *stepLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
            int height = [self calculateContentHeight:testString withFont:stepLabelFont withLabelWidth:stepLabelWidth];

            NSNumber *num = [[NSNumber alloc] initWithInt:height];
            [self.stepsLabelHeight addObject:num];
        }
        
        //Tips
        self.tips = [[NSMutableArray alloc] init];
        for (int i = 0; i<5;i++)
        {
            NSString *testString = [NSString stringWithFormat:@"Tips %d:this is tips for this recipe!this is tips for this recipe!this is tips for this recipe!this is tips for this recipe!this is tips for this recipe! 1 2 3 4 5",i];
            [self.tips addObject:testString];
            
            UIFont *tipLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
            int height = [self calculateContentHeight:testString withFont:tipLabelFont withLabelWidth:tipLabelWidth];
            
            NSNumber *num = [[NSNumber alloc] initWithInt:height];
            [self.tipsLabelHeight addObject:num];
        }        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.recipeDetailView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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


//If we do not want the header section, thinking about adding zero rows section using footer as header of next section.
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
                        
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 20)];
            nameLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            nameLabel.text = [NSString stringWithFormat:@"%@",[[self.ingredients objectAtIndex:indexPath.row] objectForKey:@"name"]];
            nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [cell.nameView addSubview:nameLabel];

            UILabel *quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 20)];
            quantityLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            quantityLabel.text = [NSString stringWithFormat:@"%dg",[[[self.ingredients objectAtIndex:indexPath.row] objectForKey:@"quantity"] intValue]];
            quantityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            quantityLabel.textAlignment = NSTextAlignmentLeft;
            [cell.quantityView addSubview:quantityLabel];
            
            return cell;
            break;
        }
        case 1:
        {
//            NSString *detailString = [self.steps objectAtIndex:indexPath.row];
//            UIFont *descLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
//            int height = [self calculateContentHeight:detailString withFont:descLabelFont];
            int height = [[self.stepsLabelHeight objectAtIndex:indexPath.row] intValue];


            HMRecipeStepCell* cell = [[HMRecipeStepCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMRecipeStepCell" withLabelHeight:height];
            cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            cell.textLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            indexLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            indexLabel.text = [NSString stringWithFormat:@"%d",(indexPath.row+1)];
            indexLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            indexLabel.textAlignment = NSTextAlignmentCenter;
            [cell.numberView addSubview:indexLabel];
            [cell.imageView setImage:[UIImage imageNamed:@"icon_cloud.png"]];
            
            NSString *detailString = [self.steps objectAtIndex:indexPath.row];
            [cell.textLabel setText:detailString];
            cell.textLabel.numberOfLines = 0;
            UIFont *descLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
            cell.textLabel.font = descLabelFont;
            
            //Dynamically change the UILabel height
//            CGRect labelFrame = cell.textLabel.frame;
//            int height = [self calculateContentHeight:detailString withFont:descLabelFont];
//            labelFrame.size.height = height;
//            cell.textLabel.frame = labelFrame;
            
            return cell;
            break;
        }
        case 2:
        {
            
            int height = [[self.tipsLabelHeight objectAtIndex:indexPath.row] intValue];

            HMRecipeTipCell* cell = [[HMRecipeTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMRecipeTipCell" withLableHeight:height];
            cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            cell.textLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //Comment out if we do not need the numberView
//            UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//            indexLabel.text = [NSString stringWithFormat:@"%d",(indexPath.row+1)];
//            indexLabel.textAlignment = NSTextAlignmentCenter;
//            [cell.numberView addSubview:indexLabel];

            
            NSString *detailString = [self.tips objectAtIndex:indexPath.row];
//            [cell.textLabel setText:detailString];//with numberView
            [cell.textLabel setText:[NSString stringWithFormat:@"%d. %@",indexPath.row+1,detailString]]; //without numberView
            cell.textLabel.numberOfLines = 0;
            UIFont *descLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
            cell.textLabel.font = descLabelFont;
            
            //Dynamically change the UILabel height
            CGRect labelFrame = cell.textLabel.frame;
//            int height = [self calculateContentHeight:detailString withFont:descLabelFont];
            labelFrame.size.height = height;
            cell.textLabel.frame = labelFrame;

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
            return 30;
        }
        break;
        
        case 1:
        {
//            return 180;
            int height = [[self.stepsLabelHeight objectAtIndex:indexPath.row] intValue];
            int offset = 120;//From HMRecipeStepCell
            return height + offset;
        }
        break;
            
        case 2:
        {
//            return 50;
            int height = [[self.tipsLabelHeight objectAtIndex:indexPath.row] intValue];
            int offset = 12;
            return height + offset;
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
    CGRect frame = CGRectMake(20, 0, 280, 30);
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
    return 30;
}

#pragma mark - Helper

//calculate height based on content dynamically
-(float)calculateContentHeight:(NSString *)inputString withFont:(UIFont *)font withLabelWidth:(int)width
{
    CGSize maximumLabelSize = CGSizeMake(width, MAXFLOAT);
    //NSLineBreakByWordWrapping is deprecated in iOS6
    //    CGSize expectedLabelSize = [inputString sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    CGSize expectedLabelSize = [inputString sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];

    return expectedLabelSize.height;
}

@end
