//
//  HMConstants.h
//  homemade
//
//  Created by Guan Guan on 4/13/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>


// Global config
#define kShadowRadius   0.4f
#define kShadowOpacity  0.4f
#define kShadowOffset   CGSizeMake(0.0f, 0.4f)

#define kToolBarHeight  44.0f

#define kCellDragDist           60
#define kMinimumGestureLength   40
#define kMaximumGestureLength   100
#define TabBarHeight 55
#define TabBarWidth 210
#define PageFlowViewWidth 250
#define PageFlowViewHeight 400
#define CameraButtonWidth 100
#define CameraButtonHeight 47

#pragma mark - NSUserDefaults
extern NSString *const kHMUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kHMUserDefaultsCacheFacebookFriendsKey;

#pragma mark - PFObject Recipe Class
// Class key
extern NSString *const kHMRecipeClassKey;
// Field keys
extern NSString *const kHMRecipeTitleKey;
extern NSString *const kHMRecipeOverviewKey;
extern NSString *const kHMRecipeUserKey;
extern NSString *const kHMRecipePhotoKey;
extern NSString *const kHMRecipeColorKey;
extern NSString *const kHMRecipeDifficultyKey;
extern NSString *const kHMRecipeIngredientsKey;
extern NSString *const kHMRecipeStepsKey;
extern NSString *const kHMRecipeTipsKey;

#pragma mark - PFObject Drink Photo Class
extern NSString *const kHMDrinkPhotoClassKey;
extern NSString *const kHMDrinkPhotoUserKey;
extern NSString *const kHMDrinkPhotoRecipeKey;
extern NSString *const kHMDrinkPhotoPictureKey;
extern NSString *const kHMDrinkPhotoNoteKey;


#pragma mark - Cached Recipe Attributes
// keys
extern NSString *const kHMRecipeAttributesIsSavedByCurrentUserKey;
extern NSString *const kHMRecipeAttributesSaveCountKey;
extern NSString *const kHMRecipeAttributesSaversKey;
extern NSString *const kHMRecipeAttributesIsMadeByCurrentUserKey;
extern NSString *const kHMRecipeAttributesMakeCountKey;
extern NSString *const kHMRecipeAttributesMakersKey;
extern NSString *const kHMRecipeAttributesCommentCountKey;
extern NSString *const kHMRecipeAttributesCommentersKey;

#pragma mark - Cached User Attributes
// keys
extern NSString *const kHMUserAttributesRecipeCountKey;
extern NSString *const kHMUserAttributesMadeCountKey;
extern NSString *const kHMUserAttributesSaveCountKey;
extern NSString *const kHMUserAttributesIsFollowedByCurrentUserKey;

extern NSString *const kHMUserProfilePicMediumKey;
extern NSString *const kHMUserProfilePicSmallKey;
extern NSString *const kHMUserDisplayNameKey;
extern NSString *const kHMUserEmailKey;
extern NSString *const kHMUserFacebookIDKey;
extern NSString *const kHMUserPhotoIDKey;

#pragma mark - TMCache keys
extern NSString *const kHMColorSuffixKey;


#pragma mark - Save Class
extern NSString *const kHMSaveClassKey;
// Field keys
extern NSString *const kHMSaveFromUserKey;
extern NSString *const kHMSaveToUserKey;
extern NSString *const kHMSaveRecipeKey;

#pragma mark - Comment Class
extern NSString *const kHMCommentClassKey;
// Field keys
extern NSString *const kHMCommentFromUserKey;
extern NSString *const kHMCommentTypeKey;
extern NSString *const kHMCommentContentKey;
extern NSString *const kHMCommentRecipeKey;
extern NSString *const kHMCommentPhotoKey;
// Type values
extern NSString *const kHMCommentTypeRecipe;
extern NSString *const kHMCommentTypePhoto;

#pragma mark - User Info Keys
extern NSString *const kHMEditPhotoViewControllerUserInfoCommentKey;


#pragma mark - NSNotification
extern NSString *const HMCameraControllerDidFinishEditingPhotoNotification;
extern NSString *const HMCommentControllerDidFinishEditingCommentNotification;

