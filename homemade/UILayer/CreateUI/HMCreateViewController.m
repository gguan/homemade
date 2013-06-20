//
//  HMCreateViewController.m
//  homemade
//
//  Created by Guan Guan on 6/19/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCreateViewController.h"
#import "HMStepInputCell.h"
#import "HMIngredientCell.h"
#import "HMTipInputCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ResizeAdditions.h"

#define ButtonHeight 50.0f
#define StepCellHeight 70.0f
#define IngredientCellHeight 40.0f
#define TipCellHeight 40.0f;

@interface HMCreateViewController ()

@property (nonatomic, strong) HMCameraViewController *photoPicker;
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) PFImageView *coverView;
@property (nonatomic, strong) PFFile *coverImage;
@property (nonatomic, strong) UITextView *descriptionField;

@property (nonatomic, strong) NSMutableArray *steps; // dict array hold step content and PFFile
@property (nonatomic, strong) NSMutableArray *ingridents;
@property (nonatomic, strong) NSMutableArray *tips;
@property (nonatomic, weak)   PFImageView *imageViewholder;

@end

@implementation HMCreateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.photoPicker = [[HMCameraViewController alloc] init];
        self.photoPicker.delegate = self;
        self.photoPicker.container = self;
        
        self.steps = [[NSMutableArray alloc] init];
        self.ingridents =[[NSMutableArray alloc] init];
        self.tips = [[NSMutableArray alloc] init];

        
        // Custom initialization
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 290)];
        
        // title text field
        self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];
        [self.titleField setPlaceholder:@"add a title"];
        [self.titleField setBorderStyle:UITextBorderStyleRoundedRect];
        [headerView addSubview:self.titleField];
        
        // cover imageView
        self.coverView = [[PFImageView alloc] initWithFrame:CGRectMake(100, 60, 120, 120)];
        self.coverView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverView.clipsToBounds = YES;
        self.coverView.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        self.descriptionField.layer.borderWidth = 1.0f;
        UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [coverButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [coverButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [coverButton setFrame:CGRectMake(100, 60, 120, 120)];
        [coverButton setBackgroundColor:[UIColor clearColor]];
        [coverButton setTitle:@"drink picture" forState:UIControlStateNormal];
        coverButton.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        coverButton.layer.borderWidth = 1.0f;
        [coverButton addTarget:self action:@selector(uploadCoverPhoto) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.coverView];
        [headerView insertSubview:coverButton aboveSubview:self.coverView];
        
        self.descriptionField = [[UITextView alloc] initWithFrame:CGRectMake( 20.0f, 190.0f, 280.0f, 90.0f)];
        self.descriptionField.font = [UIFont systemFontOfSize:14.0f];
//        self.descriptionField.placeholder = @"add some description to introduce this drink";
        self.descriptionField.returnKeyType = UIReturnKeyDefault;
        self.descriptionField.layer.borderWidth = 1.0f;
        self.descriptionField.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        self.descriptionField.layer.cornerRadius = 4.0f;
        [headerView addSubview:self.descriptionField];

        
        self.tableView.tableHeaderView = headerView;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setTitle:@"Post a new recipe"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftDrawerButtonClicked)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightDrawerButtonClicked)];
    [self.navigationItem setRightBarButtonItem:rightItem];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
        [header setText:@"Write steps to make this drink"];
        return header;
    } else if (section == 1) {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
        [header setText:@"Write ingredients of this drink"];
        return header;

    } else if (section == 2) {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
        [header setText:@"Write some tips to make drink better"];
        return header;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.steps count] + 1;
    } else if (section == 1) {
        return [self.ingridents count] + 1;
    } else if (section == 2) {
        return [self.tips count] + 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row < self.steps.count) {
        return StepCellHeight;
    } else if (indexPath.section == 1 && indexPath.row < self.ingridents.count) {
        return IngredientCellHeight;
    } else if (indexPath.section == 2 && indexPath.row < self.tips.count) {
        return TipCellHeight;
    } else {
        return ButtonHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == self.steps.count) {
        UITableViewCell *buttonCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ButtonHeight)];
        [buttonCell setBackgroundColor:[UIColor redColor]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, self.view.bounds.size.width, ButtonHeight)];
        [button setTitle:@"Add step" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addStepAction) forControlEvents:UIControlEventTouchUpInside];
        [buttonCell addSubview:button];
        return buttonCell;
    } else if (indexPath.section == 1 && indexPath.row == self.ingridents.count) {
        UITableViewCell *buttonCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ButtonHeight)];
        [buttonCell setBackgroundColor:[UIColor redColor]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, self.view.bounds.size.width, ButtonHeight)];
        [button setTitle:@"Add ingredient" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addIngredientAction) forControlEvents:UIControlEventTouchUpInside];
        [buttonCell addSubview:button];
        return buttonCell;
    } else if (indexPath.section == 2 && indexPath.row == self.tips.count) {
        UITableViewCell *buttonCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ButtonHeight)];
        [buttonCell setBackgroundColor:[UIColor redColor]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, self.view.bounds.size.width, ButtonHeight)];
        [button setTitle:@"Add tip" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addTipAction) forControlEvents:UIControlEventTouchUpInside];
        [buttonCell addSubview:button];
        return buttonCell;
    }
    
    static NSString *StepCellIdentifier = @"CreateStepCell";
    static NSString *IngredientCellIdentifier = @"CreateIngredientCell";
    static NSString *TipCellIdentifier = @"CreateTipCell";
    
    if (indexPath.section == 0) {
        HMStepInputCell *cell = [tableView dequeueReusableCellWithIdentifier:StepCellIdentifier];
        if (!cell) {
            cell = [[HMStepInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StepCellIdentifier];
        }
        cell.imageButton.tag = indexPath.row;
        [cell.imageButton addTarget:self action:@selector(uploadStepPhoto:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.section == 1) {
        HMIngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:IngredientCellIdentifier];
        if (!cell) {
            cell = [[HMIngredientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IngredientCellIdentifier];
        }
        return cell;
    } else if (indexPath.section == 2) {
        HMTipInputCell *cell = [tableView dequeueReusableCellWithIdentifier:TipCellIdentifier];
        if (!cell) {
            cell = [[HMTipInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                    TipCellIdentifier];
        }
        return cell;
    } else {
        return nil;
    }
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - HMCameraDelegate
- (void)cameraViewControllerShowPicker:(HMCameraViewController *)picker {
    [self.photoPicker showPhotoPicker:@"upload drink cover"];
}

- (void)cameraViewControllerDidCancel:(HMCameraViewController *)picker {
}

- (void)cameraViewController:(HMCameraViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"didFinishPickingMediaWithInfo get executed...");
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self uploadImage:image];
}

- (BOOL)uploadImage:(UIImage *)anImage {
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640.0f, 640.0f) interpolationQuality:kCGInterpolationHigh];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    
    if (!imageData) {
        return NO;
    }
    
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.imageViewholder setFile:imageFile];
            [self.imageViewholder loadInBackground];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return YES;
}


- (void)leftDrawerButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)rightDrawerButtonClicked {
    NSLog(@"Save clicked!");
}

- (void)uploadCoverPhoto {
    NSLog(@"photo button clicked!");
    self.imageViewholder = self.coverView;
    [self cameraViewControllerShowPicker:self.photoPicker];
}

- (void)uploadStepPhoto:(id)sender {
    UIButton *button = sender;
    NSInteger index = button.tag;
//    self.imageViewholder = [self.tableView 
    [self cameraViewControllerShowPicker:self.photoPicker];
}

- (void)addStepAction {
    [self.steps addObject:@[@""]];
    [self.tableView reloadData];
}

- (void)addIngridentAction {
    
}

- (void)addTipAction {
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // resign first responder
    if (self.titleField.isFirstResponder || self.descriptionField.isFirstResponder) {
        [self.view endEditing:YES];
    }
}

@end
