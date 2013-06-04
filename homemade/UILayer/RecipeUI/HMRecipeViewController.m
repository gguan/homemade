//
//  HMRecipeViewController.m
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#define titleLabelWidth 280
#define descLabelWidth 280
#define stepLabelWidth 135
#define tipLabelWidth 280
#define TABBARHEIGHT 44
#define TopImageViewHeight 88
#define SELECTED_VIEW_TAG 98456345
#define ingredientsTableView_TAG 100
#define stepsTableView_TAG 101


#import "HMRecipeViewController.h"
#import "HMIngredientCell.h"
#import "HMRecipeStepCell.h"
#import "HMRecipeTipCell.h"
#import "HMStepsViewController.h"
#import "HMIngredientViewController.h"
#import "HMImadeItViewController.h"

@interface HMRecipeViewController ()
@property (strong, nonatomic) UIImageView  *photo;

@property (strong, nonatomic) NSString      *titleLabel;

@property (strong, nonatomic) NSString     *descLabel;

@property (strong, nonatomic) UIButton     *saveButton;

@property (strong, nonatomic) UITableView  *ingredientsTableView;

@property (strong, nonatomic) UITableView  *stepsTableView;

@property (strong, nonatomic) NSMutableArray *ingredients;

@property (strong, nonatomic) NSMutableArray *steps;

@property (strong, nonatomic) NSMutableArray *tips;

@property (strong, nonatomic) NSMutableArray *ingredientsQuantity;

@property (strong, nonatomic) NSMutableArray *stepsLabelHeight;

@property (strong, nonatomic) NSMutableArray *tipsLabelHeight;

@property(nonatomic,strong) UIView *stepView;

@property(nonatomic,strong) UIView *ingredientView;

@property(nonatomic,strong) UIView *ImadeitView;

@property(nonatomic,strong) CustomTabBar *tabBar;

@property(nonatomic,strong) NSArray *Items;

@property(nonatomic,strong) UIColor *color;

@property(nonatomic,strong) HMStepsViewController *stepsViewController;

@property(nonatomic,strong) HMIngredientViewController *ingredientViewController;

@property(nonatomic,strong) HMImadeItViewController *imadeitViewController;


@end

@implementation HMRecipeViewController

@synthesize photo = _photo;
@synthesize titleLabel = _titleLabel;
@synthesize descLabel = _descLabel;
@synthesize saveButton = _saveButton;
@synthesize ingredientsTableView = _ingredientsTableView;
@synthesize stepsTableView = _stepsTableView;
@synthesize ingredients = _ingredients;
@synthesize steps = _steps;
@synthesize tips = _tips;
@synthesize stepsLabelHeight = _stepsLabelHeight;
@synthesize tipsLabelHeight = _tipsLabelHeight;
@synthesize ingredientsQuantity = _ingredientsQuantity;
@synthesize stepView = _stepView;
@synthesize ingredientView = _ingredientView;
@synthesize ImadeitView = _ImadeitView;
@synthesize tabBar = _tabBar;
@synthesize Items = _Items;
@synthesize color = _color;
@synthesize ingredientViewController = _ingredientViewController;
@synthesize stepsViewController = _stepsViewController;
@synthesize imadeitViewController = _imadeitViewController;

- (id)initWithRecipe:(PFObject*)recipeObject{
   return  [self initWithRecipe:recipeObject andUIColor:[UIColor colorWithRed:162.0/255.0 green:73.0/255.0 blue:43.0/255.0 alpha:1.0]];
    
}



- (id)initWithRecipe:(PFObject*)recipeObject andUIColor:(UIColor*)color
{
    self = [super init];
    if (self)
    {
        self.color = color;
       // self.color = [UIColor colorWithRed:193.0/255.0 green:67.0/255.0 blue:29.0/255.0 alpha:1.0];
        //The top image view
        PFImageView *topImageView = [[PFImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
        
        [topImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, TopImageViewHeight + TABBARHEIGHT)];
        [self.view addSubview:topImageView];
        
        topImageView.file = [recipeObject objectForKey:kHMRecipePhotoKey];
    
        if (topImageView.file.isDataAvailable) {
            [topImageView loadInBackground:^(UIImage *image, NSError *error){
                if (!error) {
                    [topImageView setContentMode:UIViewContentModeScaleAspectFill];
                    topImageView.clipsToBounds = YES;
                }
                
                else {
                    
                    NSLog(@"error:%@",[error userInfo]);
                }
            }];

        }
        else{
            NSLog(@"no image");
            [topImageView.file getDataInBackgroundWithBlock:^(NSData* data,NSError* error){
                if (!error) {
                     [topImageView loadInBackground];
                    [topImageView setContentMode:UIViewContentModeScaleAspectFill];
                    topImageView.clipsToBounds = YES;
                  
                }
                else{
                    NSLog(@"error:%@",[error userInfo]);
                }
                
            }];
            
        }
   
        
        //The back button
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(12.5, 15, 30, 30)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventAllTouchEvents];
        [self.view addSubview:backButton];
        
        //The "Fuzzy Thing" label
        
        UILabel *fuzzyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 50, 130, 30)];
        [fuzzyLabel setText:@"Fuzzy Thing"];
        [fuzzyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21]];
        [fuzzyLabel setTextColor:[UIColor whiteColor]];
        [fuzzyLabel setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:fuzzyLabel];
        
        
        //initialize the tabBar and three subViews
        _stepsViewController = [[HMStepsViewController alloc] initWithRecipe:recipeObject];
       
        NSLog(@"%@ 111",NSStringFromCGRect(_stepsViewController.view.bounds));
        _ingredientViewController = [[HMIngredientViewController alloc] initWithRecipe:recipeObject];
        _imadeitViewController = [[HMImadeItViewController alloc] initWithRecipe:recipeObject];
        
        
        _Items = [NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"step.png", @"image", self.stepsViewController, @"viewController", @"Steps",@"subTitle",nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"ingredient.png", @"image", self.ingredientViewController, @"viewController",@"ingredient",@"subTitle", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Imadit.png", @"image", self.imadeitViewController, @"viewController",@"I made it",@"subTitle", nil],nil];
    
        _tabBar = [[CustomTabBar alloc] initWithItemCount:3 itemSize:CGSizeMake(self.view.frame.size.width/3, TABBARHEIGHT) tag:0 delegate:self];
        
        // Place the tab bar at the top of our view
        self.tabBar.frame = CGRectMake(0,TopImageViewHeight,self.view.frame.size.width, TABBARHEIGHT);
        [self.view addSubview:self.tabBar];
        // Select the first tab
        [self.tabBar selectItemAtIndex:0];
        [self.tabBar setBackgroundColor:[UIColor blackColor]];
        [self touchDownAtItemAtIndex:0];
        [self.tabBar setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.tabBar];
        
        
        
        
        //Initialize the ingredients table view
        self.ingredientsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TABBARHEIGHT - TopImageViewHeight) style:UITableViewStylePlain];
        
        //Add customized backgound color in top bounce area if needed
        //        CGRect frame =CGRectMake(0, -568, 320, 568);//for 4 inch device
        //        UIView* grayView = [[UIView alloc] initWithFrame:frame];
        //        grayView.backgroundColor = [UIColor redColor];
        //        [self.ingredientsTableView addSubview:grayView];

        self.ingredientsTableView.backgroundColor = self.color;
        self.ingredientsTableView.dataSource = self;
        self.ingredientsTableView.delegate = self;
        self.ingredientsTableView.tag = ingredientsTableView_TAG;
        [self.ingredientsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.ingredientView addSubview:self.ingredientsTableView];
        
        //Initialize the steps table view
        self.stepsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TABBARHEIGHT + TopImageViewHeight, self.view.frame.size.width, self.view.frame.size.height - TABBARHEIGHT - TopImageViewHeight) style:UITableViewStylePlain];
        
        //Add customized backgound color in top bounce area if needed
        //        CGRect frame =CGRectMake(0, -568, 320, 568);//for 4 inch device
        //        UIView* grayView = [[UIView alloc] initWithFrame:frame];
        //        grayView.backgroundColor = [UIColor redColor];
        //        [self.ingredientsTableView addSubview:grayView];
        
        self.stepsTableView.backgroundColor =self.color;
        self.stepsTableView.dataSource = self;
        self.stepsTableView.delegate = self;
        self.stepsTableView.tag = stepsTableView_TAG;
        [self.stepsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
       
        [self.stepView addSubview:self.stepsTableView];

        
        self.stepsLabelHeight = [[NSMutableArray alloc] init];
        self.tipsLabelHeight = [[NSMutableArray alloc] init];
        
        //For testing
        //Ingredients
        self.ingredients = [[NSMutableArray alloc] init];
        for (int i = 0; i<5;i++)
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
        for (int i = 0; i<11;i++)
        {
            NSString *testString = @"This is the steps descrpiton! ";
            if(i==0)
                testString = @"This is the steps descrpiton! This is the steps descrpiton! ";
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


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma tableView Delegate Method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag)
        {
            case ingredientsTableView_TAG:
            {
                
                return [self.ingredients count];
                break;
            }
            case stepsTableView_TAG:
            {
                return [self.steps count]/2 + [self.steps count]%2;
                break;
            }
    
    
            default:
                return  0;
                break;
        }

}


//If we do not want the header section, thinking about adding zero rows section using footer as header of next section.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    switch (tableView.tag) {
        case ingredientsTableView_TAG:
        {
            
            
            HMIngredientCell* cell = [[HMIngredientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMIngredientCell"];
            cell.contentView.backgroundColor = self.color;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 20)];
            nameLabel.backgroundColor = self.color;
            nameLabel.text = [NSString stringWithFormat:@"%@",[[self.ingredients objectAtIndex:indexPath.row] objectForKey:@"name"]];
            nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [cell.nameView addSubview:nameLabel];

            UILabel *quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 20)];
            quantityLabel.backgroundColor = self.color;
            quantityLabel.text = [NSString stringWithFormat:@"%dg",[[[self.ingredients objectAtIndex:indexPath.row] objectForKey:@"quantity"] intValue]];
            quantityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            quantityLabel.textAlignment = NSTextAlignmentLeft;
            [cell.quantityView addSubview:quantityLabel];
            
            return cell;
            break;
        }
        case stepsTableView_TAG:
        {
            
           int leftHeight = [[self.stepsLabelHeight objectAtIndex:2*indexPath.row] intValue];
            int rightHeight = 0;
            if((2*indexPath.row+1)<[self.stepsLabelHeight count])
             rightHeight = [[self.stepsLabelHeight objectAtIndex:(2*indexPath.row+1)] intValue];

            HMRecipeStepCell* cell = [[HMRecipeStepCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMRecipeStepCell" withLabelHeight:leftHeight>rightHeight?leftHeight:rightHeight];

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UILabel *leftIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            leftIndexLabel.backgroundColor = [UIColor clearColor];
            leftIndexLabel.text = [NSString stringWithFormat:@"%d",(indexPath.row*2)];
       
            leftIndexLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
            leftIndexLabel.textAlignment = NSTextAlignmentCenter;
            leftIndexLabel.textColor = [UIColor lightGrayColor];
            [cell.leftNumberView addSubview:leftIndexLabel];
            [cell.leftImageView setImage:[UIImage imageNamed:@"icons_1.png"]];
        
            
            UIFont *descLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:12];

            //Right now set to 16 according to font
            int leftNumberOfLines = leftHeight%16==0?leftHeight/16:(leftHeight/16 + 1);
            int rightNumberOfLines = rightHeight%16==0?rightHeight/16:(rightHeight/16 + 1);
            int numberOfLines = leftNumberOfLines>rightNumberOfLines?leftNumberOfLines:rightNumberOfLines;
            
            NSString *leftDetailString = [self.steps objectAtIndex:2*indexPath.row];
            [cell.leftLabel setText:leftDetailString];
            cell.leftLabel.numberOfLines = numberOfLines;
            cell.leftLabel.textAlignment = NSTextAlignmentLeft;
            cell.leftLabel.font = descLabelFont;

            if((2*indexPath.row+1)<[self.stepsLabelHeight count])
            {
            UILabel *rightIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            rightIndexLabel.backgroundColor = [UIColor clearColor];
            rightIndexLabel.text = [NSString stringWithFormat:@"%d",(indexPath.row*2 + 1)];
            rightIndexLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
            rightIndexLabel.textAlignment = NSTextAlignmentCenter;
            rightIndexLabel.textColor = [UIColor lightGrayColor];
            [cell.rightNumberView addSubview:rightIndexLabel];
            [cell.rightImageView setImage:[UIImage imageNamed:@"icons_2.png"]];
            
            NSString *rightDetailString = [self.steps objectAtIndex:(2*indexPath.row + 1)];
            [cell.rightLabel setText:rightDetailString];
            cell.rightLabel.numberOfLines = numberOfLines;
            cell.rightLabel.textAlignment = NSTextAlignmentLeft;
            cell.rightLabel.font = descLabelFont;
                
            }
           

            
            return cell;
            break;
        }
       
        

        default:
            return nil;
            break;
    }
    

}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //change to return dynamically
    switch (tableView.tag) {
        case ingredientsTableView_TAG:
        {
            return 30;
            break;

        }
                
        case stepsTableView_TAG:
        {
//            return 180;
            int height = [[self.stepsLabelHeight objectAtIndex:indexPath.row] intValue];
            int offset = 120;//From HMRecipeStepCell
            return height + offset;
            break;
        }
     
            
        default:
            return 50;
            break;
    }
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

//change the image color to required color
-(UIImage*)changeImage:(UIImage*)image toColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  [UIImage imageWithCGImage:img.CGImage
            scale:1.0 orientation: UIImageOrientationDownMirrored];
    
}

#pragma mark -
#pragma mark CustomTabBarDelegate

- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
    
    // Get the right data
    NSDictionary* data = [self.Items objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    return [UIImage imageNamed:[data objectForKey:@"image"]];
}

- (NSString*) titleFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex{
    
    NSDictionary* data = [self.Items objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    return [data objectForKey:@"subTitle"];
}


// This is the blue background shown for selected tab bar items
- (UIImage*) selectedItemBackgroundImage
{
    return [UIImage imageNamed:@""];
}


//It's not used temporarily

- (UIImage*) tabBarArrowImage
{
    return [self changeImage:[UIImage imageNamed:@"TabBarNipple.png"] toColor:self.color] ;
}

- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    // Remove the current view controller's view
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_TAG];
    [currentView removeFromSuperview];
    
    // Get the right view controller
    NSDictionary* data = [self.Items objectAtIndex:itemIndex];
    UIViewController* viewController = [data objectForKey:@"viewController"];
    
    // Set the view controller's frame to account for the tab bar
    viewController.view.frame = CGRectMake(0, TopImageViewHeight + TABBARHEIGHT, self.view.frame.size.width, self.view.frame.size.height - TABBARHEIGHT -TopImageViewHeight);
    viewController.view.clipsToBounds = YES;
    NSLog(@"%@ 222",NSStringFromCGRect(viewController.view.bounds));
    // Se the tag so we can find it later
    viewController.view.tag = SELECTED_VIEW_TAG;
    
    
    // Add the new view controller's view
    [self.view insertSubview:viewController.view belowSubview:_tabBar];
    
}

#pragma UIbutton method

- (void)backButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
