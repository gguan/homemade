//
//  HMTipEditViewController.m
//  homemade
//
//  Created by Guan Guan on 6/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMTipEditViewController.h"

@interface HMTipEditViewController ()
@property (nonatomic, strong) UITextField *tipField;
@end

@implementation HMTipEditViewController

- (id)initWithTip:(NSString *)tip
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        self.tipField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 220, 40)];
        [self.tipField setPlaceholder:@"write a tip"];
        [self.view addSubview:self.tipField];

        if (tip.length > 0) {
            [self.tipField setText:tip];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Tip";
    
    // Add a back navBarItem
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightDrawerButtonClicked)];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightDrawerButtonClicked {
    NSLog(@"Add a tip");
    
    NSString *trimmedTip = [self.tipField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    if (trimmedTip.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Content can't be empty"
                                                        message:@"Please input some tip content."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } 
    
    if (self.delegate) {
        [self.delegate addTipItemViewController:self didFinishEnteringItem:trimmedTip];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
