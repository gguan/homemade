//
//  HMIngredientEditViewController.m
//  homemade
//
//  Created by Guan Guan on 6/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMIngredientEditViewController.h"

@interface HMIngredientEditViewController ()
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *amountField;
@end

@implementation HMIngredientEditViewController

- (id)initWithName:(NSString *)name amount:(NSString *)amount
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 220, 40)];
        [self.nameField setPlaceholder:@"ingredient name"];
        [self.view addSubview:self.nameField];
        self.amountField = [[UITextField alloc] initWithFrame:CGRectMake(20, 180, 220, 40)];
        [self.amountField setPlaceholder:@"amount"];
        [self.view addSubview:self.amountField];
        
        if (name.length > 0) {
            [self.nameField setText:name];
        }
        if (amount.length > 0) {
            [self.amountField setText:amount];
        }

    }
    return self;
}
 
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightDrawerButtonClicked)];
    [self.navigationItem setRightBarButtonItem:rightItem];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightDrawerButtonClicked {
    NSLog(@"Add a ingredient item");
    NSDictionary *ingredientItem;
    
    NSString *trimmedName = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedAmount = [self.amountField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (trimmedName.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ingredient name can't be empty"
                                                        message:@"Please input a ingredient name."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else if (trimmedAmount.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ingredient amount can't be empty"
                                                        message:@"Please input amount of ingredient."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else {
        ingredientItem = @{kHMRecipeIngredientNameKey: trimmedName, kHMRecipeIngredientAmountKey: trimmedAmount};
    }
    
    if (self.delegate) {
        [self.delegate addIngredientItemViewController:self didFinishEnteringItem:ingredientItem];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
