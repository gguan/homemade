//
//  HMStepEditViewController.m
//  homemade
//
//  Created by Guan Guan on 6/19/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMStepEditViewController.h"
#import "UIImage+ResizeAdditions.h"
#import <QuartzCore/QuartzCore.h>

@interface HMStepEditViewController ()
@property (nonatomic, strong) PFImageView *photoView;
@property (nonatomic, strong) PFFile *photoImage;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) UITextView *contentField;
@property (nonatomic, strong) HMCameraViewController *photoPicker;
@end

@implementation HMStepEditViewController

- (id)initWithContent:(NSString *)content photo:(PFFile *)photoFile
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        self.photoImage = photoFile;
        self.content = content;
        self.photoPicker = [[HMCameraViewController alloc] init];
        self.photoPicker.delegate = self;
        self.photoPicker.container = self;

        
        self.photoView = [[PFImageView alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];
        self.photoView.image = [UIImage imageNamed:@"StepImagePlaceholder.png"];
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds = YES;
        self.photoView.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        
        UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [coverButton setFrame:CGRectMake(100, 60, 120, 120)];
        [coverButton setBackgroundColor:[UIColor clearColor]];
        [coverButton addTarget:self action:@selector(uploadStepPhoto) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.photoView];
        [self.view insertSubview:coverButton aboveSubview:self.photoView];
        
        
        self.contentField = [[UITextView alloc] initWithFrame:CGRectMake( 20.0f, 250.0f, 280.0f, 90.0f)];
        self.contentField.font = [UIFont systemFontOfSize:14.0f];
        //        self.descriptionField.placeholder = @"add some description to introduce this drink";
        self.contentField.returnKeyType = UIReturnKeyDefault;
        self.contentField.layer.borderWidth = 1.0f;
        self.contentField.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        self.contentField.layer.cornerRadius = 4.0f;
        [self.view addSubview:self.contentField];
        
        
        if (self.photoImage) {
            [self.photoView setFile:self.photoImage];
            [self.photoView loadInBackground];
        }
        if (self.content) {
            [self.contentField setText:self.content];
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

- (void)uploadStepPhoto {
    NSLog(@"photo button clicked!");
    [self cameraViewControllerShowPicker:self.photoPicker];
}

#pragma mark - HMCameraDelegate
- (void)cameraViewControllerShowPicker:(HMCameraViewController *)picker {
    [self.photoPicker showPhotoPicker:@"upload a step photo" inView:self.view];
}

- (void)cameraViewControllerDidCancel:(HMCameraViewController *)picker {
}

- (void)cameraViewController:(HMCameraViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
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
            self.photoImage = imageFile;
            [self.photoView setFile:imageFile];
            [self.photoView loadInBackground];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return YES;
}


- (void)rightDrawerButtonClicked {
    NSLog(@"Add a step item");
    NSDictionary *stepItem;
    
    NSString *trimmedContent = [self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (trimmedContent.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Step content can't be empty"
                                                        message:@"Please input some step description in the text field."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else if (!self.photoImage) {
        stepItem = @{kHMRecipeStepsContentKey: trimmedContent};
    } else {
        stepItem = @{kHMRecipeStepsContentKey: trimmedContent, kHMRecipeStepsPhotoKey: self.photoImage};
    }
    
    if (self.delegate) {
        [self.delegate addStepItemViewController:self didFinishEnteringItem:stepItem];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
