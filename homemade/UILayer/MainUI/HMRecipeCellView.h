//
//  HMRecipeCellView.h
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "UIImage+ColorArt.h"
#import "HMCellLeftView.h"
#import "YLProgressBar.h"

@protocol HMRecipeCellViewDelegate;

@interface HMRecipeCellView : PFTableViewCell {
    CGPoint     gestureStartPoint;
}

@property (strong, nonatomic) UIView    *backCover;
@property (strong, nonatomic) PFImageView   *photo;
@property (strong, nonatomic) UIButton  *divider;
@property (strong, nonatomic) UILabel   *titleLabel;
@property (strong, nonatomic) UIView    *colorLine;
@property (strong, nonatomic) UIButton  *saveIcon;
@property (strong, nonatomic) UIButton  *cameraIcon;
@property (strong, nonatomic) UIButton  *actionButton;
@property (strong, nonatomic) UILabel   *saveCount;
@property (strong, nonatomic) UILabel   *commentCount;
@property (strong, nonatomic) UIColor   *colorArt;


@property (strong, nonatomic) PFObject  *recipe;

// Left function panel
@property (strong, nonatomic) HMCellLeftView *cellLeft;

@property (strong, nonatomic) YLProgressBar *progressBar;

// Wheter left panel is visible
@property (assign, nonatomic) BOOL leftIsVisible;

// Delegate
@property (nonatomic,weak) id <HMRecipeCellViewDelegate> delegate;

// Configures save Button to match the give save status
- (void)setSaveStatus:(BOOL)saved;

// Enable the save button to start receiving actions
- (void)shouldEnableSaveButton:(BOOL)enable;

// Hide left panel
- (void)bounceToLeft:(CGFloat)duration;
// Show left panel
- (void)bounceToRight:(CGFloat)duration;

@end


@protocol HMRecipeCellViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the save button is tapped
 @param user the PFUser associated with this button
 */
- (void)recipeTableCellView:(HMRecipeCellView *)recipeTableCellView didTapSaveButton:(UIButton *)button recipe:(PFObject *)recipe;

/*!
 Sent to the delegate when the comment button is tapped
 @param user the PFUser associated with this button
 */
- (void)recipeTableCellView:(HMRecipeCellView *)recipeTableCellView didTapCommentButton:(UIButton *)button recipe:(PFObject *)recipe;

/*!
 Sent to the delegate when the share button is tapped
 @param photo the PFObject for the photo that will be commented on
 */
- (void)recipeTableCellView:(HMRecipeCellView *)recipeTableCellView didTapShareButton:(UIButton *)button recipe:(PFObject *)recipe;


@end
