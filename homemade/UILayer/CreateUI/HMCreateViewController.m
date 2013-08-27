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

#define ButtonCellHeight 50.0f
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
@property (nonatomic, strong) NSArray *emptyArray;

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
        self.emptyArray = [[NSArray alloc] init];
        
        // Custom initialization
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 290)];
        
        // title text field
        self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];
        [self.titleField setPlaceholder:@"Drink title"];
        [self.titleField setBorderStyle:UITextBorderStyleRoundedRect];
        [headerView addSubview:self.titleField];
        
        // cover imageView
        self.coverView = [[PFImageView alloc] initWithFrame:CGRectMake(100, 60, 120, 120)];
        self.coverView.image = [UIImage imageNamed:@"UploadCoverPlaceholder.png"];
        self.coverView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverView.clipsToBounds = YES;
        self.coverView.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        self.descriptionField.layer.borderWidth = 1.0f;
        UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [coverButton setFrame:CGRectMake(100, 60, 120, 120)];
        [coverButton setBackgroundColor:[UIColor clearColor]];
        [coverButton addTarget:self action:@selector(uploadCoverPhoto) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.coverView];
        [headerView insertSubview:coverButton aboveSubview:self.coverView];
        
        self.descriptionField = [[UITextView alloc] initWithFrame:CGRectMake( 20.0f, 190.0f, 280.0f, 90.0f)];
        self.descriptionField.font = [UIFont systemFontOfSize:14.0f];
        self.descriptionField.returnKeyType = UIReturnKeyDefault;
        self.descriptionField.layer.borderWidth = 1.0f;
        self.descriptionField.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        self.descriptionField.layer.cornerRadius = 4.0f;
        [headerView addSubview:self.descriptionField];

        
        self.tableView.tableHeaderView = headerView;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        self.tableView.tableFooterView = footerView;
        
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
        header.textAlignment = NSTextAlignmentCenter;
        header.textColor = [UIColor lightGrayColor];
        [header setText:@"Steps of making this drink"];
        return header;
    } else if (section == 1) {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
        header.textAlignment = NSTextAlignmentCenter;
        header.textColor = [UIColor lightGrayColor];
        [header setText:@"Ingredients for this drink"];
        return header;
    } else if (section == 2) {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
        header.textAlignment = NSTextAlignmentCenter;
        header.textColor = [UIColor lightGrayColor];
        [header setText:@"Some tips to make drink better"];
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
        return ButtonCellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // add button for each section
    if (indexPath.section == 0 && indexPath.row == self.steps.count) {
        
        UIImage *buttonImage = [[UIImage imageNamed:@"blackButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIButton *stepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [stepButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [stepButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
        [stepButton setTitle:@"Add Step" forState:UIControlStateNormal];
        [stepButton setFrame:CGRectMake(50, 5, 220, ButtonCellHeight-10)];
        [stepButton addTarget:self action:@selector(stepButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UITableViewCell *buttonCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ButtonCellHeight)];
        [buttonCell addSubview:stepButton];
        return buttonCell;
    } else if (indexPath.section == 1 && indexPath.row == self.ingridents.count) {
        
        UIImage *buttonImage = [[UIImage imageNamed:@"blackButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIButton *ingredientButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ingredientButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [ingredientButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
        [ingredientButton setTitle:@"Add Ingredient" forState:UIControlStateNormal];
        [ingredientButton setFrame:CGRectMake(50, 5, 220, ButtonCellHeight-10)];
        [ingredientButton addTarget:self action:@selector(ingredientButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UITableViewCell *buttonCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ButtonCellHeight)];
        [buttonCell addSubview:ingredientButton];

        return buttonCell;
    } else if (indexPath.section == 2 && indexPath.row == self.tips.count) {
        UIImage *buttonImage = [[UIImage imageNamed:@"blackButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tipButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [tipButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
        [tipButton setTitle:@"Add Tip" forState:UIControlStateNormal];
        [tipButton setFrame:CGRectMake(50, 5, 220, ButtonCellHeight-10)];
        [tipButton addTarget:self action:@selector(tipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UITableViewCell *buttonCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ButtonCellHeight)];
        [buttonCell addSubview:tipButton];

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
        NSDictionary *stepItem = [self.steps objectAtIndex:indexPath.row];
        NSString *content = [stepItem objectForKey:kHMRecipeStepsContentKey];
        PFFile *imageFile = [stepItem objectForKey:kHMRecipeStepsPhotoKey];
        [cell.content setText:content];
        if (imageFile) {
            [cell.stepImage setFile:imageFile];
            [cell.stepImage loadInBackground];
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IngredientCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IngredientCellIdentifier];
        }
        NSDictionary *ingredient = [self.ingridents objectAtIndex:indexPath.row];
        NSString *name = [ingredient objectForKey:kHMRecipeIngredientNameKey];
        NSString *amount = [ingredient objectForKey:kHMRecipeIngredientAmountKey];
        NSString *text = [NSString stringWithFormat:@"%@ - %@", name, amount];
        [cell.textLabel setText:text];
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TipCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                    TipCellIdentifier];
        }
        [cell.textLabel setText:[self.tips objectAtIndex:indexPath.row]];
        return cell;
    } else {
        return nil;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self.steps.count) {
            return;
        } else {
            NSDictionary *step = [self.steps objectAtIndex:indexPath.row];
            NSString *content = [step objectForKey:kHMRecipeStepsContentKey];
            PFFile *photo = [step objectForKey:kHMRecipeStepsPhotoKey];
            HMStepEditViewController *editViewController = [[HMStepEditViewController alloc] initWithContent:content photo:photo];
            editViewController.delegate = self;
            [self.navigationController pushViewController:editViewController animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == self.ingridents.count) {
            return;
        } else {
            NSDictionary *ingredient = [self.ingridents objectAtIndex:indexPath.row];
            NSString *name = [ingredient objectForKey:kHMRecipeIngredientNameKey];
            NSString *amount = [ingredient objectForKey:kHMRecipeIngredientAmountKey];
            HMIngredientEditViewController *editViewController = [[HMIngredientEditViewController alloc] initWithName:name amount:amount];
            editViewController.delegate = self;
            [self.navigationController pushViewController:editViewController animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == self.tips.count) {
            return;
        } else {
            HMTipEditViewController *editViewController;
            NSString *tip = [self.tips objectAtIndex:indexPath.row];
            editViewController = [[HMTipEditViewController alloc] initWithTip:tip];
            editViewController.delegate = self;
            [self.navigationController pushViewController:editViewController animated:YES];
        }
    } 
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0 && indexPath.row == self.steps.count) {
        return NO;
    } else if (indexPath.section == 1 && indexPath.row == self.ingridents.count) {
        return NO;
    } else if (indexPath.section == 2 && indexPath.row == self.tips.count) {
        return NO;
    }
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (indexPath.section == 0) {
            [self.steps removeObjectAtIndex:indexPath.row];
        } else if (indexPath.section == 1) {
            [self.ingridents removeObjectAtIndex:indexPath.row];
        } else if (indexPath.section == 2) {
            [self.tips removeObjectAtIndex:indexPath.row];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

#pragma mark - HMCameraDelegate
- (void)cameraViewControllerShowPicker:(HMCameraViewController *)picker {
    [self.photoPicker showPhotoPicker:@"upload drink cover" inView:self.view];
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
            self.coverImage = imageFile;
            [self.coverView setFile:imageFile];
            [self.coverView loadInBackground];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return YES;
}


#pragma mark -
- (void)leftDrawerButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)rightDrawerButtonClicked {
    NSLog(@"Save clicked!");
    
    NSString *trimmedTitle = [self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedDescription = [self.descriptionField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedTitle.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drink title can't be empty"
                                                        message:@"Please input drink title in title field."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else if (trimmedDescription.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drink description can't be empty"
                                                        message:@"Please input some note for the drink."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else if (!self.coverImage) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drink photo haven't been uploaded"
                                                        message:@"Please upload a photo for the drink."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else if (self.steps.count == 0 || self.ingridents.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Steps and ingredients can't be empty"
                                                        message:@"Please writes some steps and list ingredients."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else {
        // construct PFObject and upload
        PFObject *recipe = [PFObject objectWithClassName:kHMRecipeClassKey];
        [recipe setObject:[PFUser currentUser] forKey:kHMRecipeUserKey];
        [recipe setObject:trimmedTitle forKey:kHMRecipeTitleKey];
        [recipe setObject:trimmedDescription forKey:kHMRecipeOverviewKey];
        [recipe setObject:self.coverImage forKey:kHMRecipePhotoKey];
        [recipe setObject:self.ingridents forKey:kHMRecipeIngredientsKey];
        [recipe setObject:self.steps forKey:kHMRecipeStepsKey];
        [recipe setObject:self.tips forKey:kHMRecipeTipsKey];
        [recipe setObject:[HMUtility getPreferredLanguage] forKey:kHMRecipeLanguageKey];
        [recipe setObject:[NSNumber numberWithBool:YES] forKey:kHMRecipeRecommandKey];
        [recipe setObject:self.emptyArray forKey:kHMRecipeCategoryKey];
        
        // Photos are public, but may only be modified by the user who uploaded them
        PFACL *recipeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [recipeACL setPublicReadAccess:YES];
        [recipeACL setWriteAccess:YES forRoleWithName:@"Admin"];    // Admin can edit recipe
        recipe.ACL = recipeACL;
        
        [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save drink recipe failed"
                                                                message:@"Please check your network conection and input content."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
        }];
    }
}

- (void)uploadCoverPhoto {
    NSLog(@"photo button clicked!");
    [self cameraViewControllerShowPicker:self.photoPicker];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // resign first responder
    if (self.titleField.isFirstResponder || self.descriptionField.isFirstResponder) {
        [self.view endEditing:YES];
    }
}


#pragma mark - Step edit view delegate
- (void)addStepItemViewController:(HMStepEditViewController *)controller didFinishEnteringItem:(NSDictionary *)stepItem {
    
    [self.steps addObject:stepItem];
    [self.tableView reloadData];
}

- (void)addIngredientItemViewController:(HMStepEditViewController *)controller didFinishEnteringItem:(NSDictionary *)ingredientItem {
    [self.ingridents addObject:ingredientItem];
    [self.tableView reloadData];
}

- (void)addTipItemViewController:(HMTipEditViewController *)controller didFinishEnteringItem:(NSString *)tipItem {
    [self.tips addObject:tipItem];
    [self.tableView reloadData];
}

#pragma mark - ()
- (void)stepButtonClicked {
    HMStepEditViewController *editViewController = [[HMStepEditViewController alloc] initWithContent:nil photo:nil];
    editViewController.delegate = self;
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)ingredientButtonClicked {
    HMIngredientEditViewController *editViewController = [[HMIngredientEditViewController alloc] initWithName:nil amount:nil];
    editViewController.delegate = self;
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)tipButtonClicked {
    HMTipEditViewController *editViewController = [[HMTipEditViewController alloc] initWithTip:nil];
    editViewController.delegate = self;
    [self.navigationController pushViewController:editViewController animated:YES];
}

@end
