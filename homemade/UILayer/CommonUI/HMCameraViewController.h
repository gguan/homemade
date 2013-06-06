//
//  HMCameraViewController.h
//  homemade
//
//  Created by Guan Guan on 6/6/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMCameraViewController;

@protocol HMCameraDelegate <NSObject>
@optional
- (void)cameraViewControllerShowActionSheet:(HMCameraViewController *)picker;
- (void)cameraViewController:(HMCameraViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)cameraViewControllerDidCancel:(HMCameraViewController *)picker;
@end

@interface HMCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (assign, nonatomic) id <HMCameraDelegate> delegate;

@end
