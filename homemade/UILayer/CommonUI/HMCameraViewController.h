//
//  HMCameraViewController.h
//  homemade
//
//  Created by Guan Guan on 6/6/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

@class HMCameraViewController;

@protocol HMCameraDelegate <NSObject>
@optional
- (void)cameraViewControllerShowPicker:(HMCameraViewController *)picker;
- (void)cameraViewController:(HMCameraViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)cameraViewControllerDidCancel:(HMCameraViewController *)picker;
@end

@interface HMCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) id <HMCameraDelegate> delegate;
@property (nonatomic, weak) UIViewController *container;

- (void)showPhotoPicker:(NSString *)title;

@end
