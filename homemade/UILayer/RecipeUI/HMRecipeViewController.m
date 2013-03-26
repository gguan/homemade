//
//  HMRecipeViewController.m
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeViewController.h"

@interface HMRecipeViewController ()

@end

@implementation HMRecipeViewController

@synthesize photo,titleLabel,descLabel,saveButton,ingredientsView,stepsView,ingredients,steps,recipeDetailView;

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
        NSString *desc = @"First Paragraph: This is for testing testing testing!!!This is for testing testing testing!!!This is for testing testing testing!!!  \n\nSecond Paragraph: This is for testing testing testing!!! This is for testing testing testing!!!  This is for testing testing testing!!!  \n\nThird Paragraph: This is for testing testing testing!!!  This is for testing testing testing!!! This is for testing testing testing!!! ";
        UIFont *descLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:11];
        int descHeight = [self calculateContentHeight:desc withFont:descLabelFont];
        
        int imageHeight = 0;
        int descViewHeight =  descHeight+imageHeight;
        UIView *descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, descViewHeight)];
        UILabel *dLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageHeight, 320, descHeight)];
        dLabel.numberOfLines = 0;
        dLabel.text = desc;
        dLabel.textColor = [UIColor blackColor];
        dLabel.backgroundColor = [UIColor blueColor];
        [descriptionView addSubview:dLabel];
        
        self.recipeDetailView.tableHeaderView = descriptionView;
        self.recipeDetailView.tableHeaderView.backgroundColor = [UIColor blueColor];
        
        
        //For testing
        self.steps = [[NSMutableArray alloc] init];
        for (int i = 0; i<10;i++)
        {
            NSString *testStepString = [NSString stringWithFormat:@"Step %d",i];
            [self.steps addObject:testStepString];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.steps count];
            break;
            
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recipeViewCell"];
    cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
    cell.textLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];

    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];


    if(indexPath.section == 0)
    {
        NSString *detailString = [self.steps objectAtIndex:indexPath.row];
        [cell.textLabel setText:detailString];
    }
    else
    {
        [cell.textLabel setText:@"section 2"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Helper

//calculate height based on content dynamically
-(float)calculateContentHeight:(NSString *)inputString withFont:(UIFont *)font
{
    //100?
    CGSize maximumLabelSize = CGSizeMake(100, MAXFLOAT);
    //NSLineBreakByWordWrapping is deprecated in iOS6
    //    CGSize expectedLabelSize = [inputString sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    CGSize expectedLabelSize = [inputString sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];

    return expectedLabelSize.height;
}

@end
