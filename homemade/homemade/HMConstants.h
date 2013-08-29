//
//  HMConstants.h
//  homemade
//
//  Created by Guan Guan on 4/13/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>


// Global config
#define kShadowRadius   1.5f
#define kShadowOpacity  0.5f
#define kShadowOffset   CGSizeMake(0.0f, 0.0f)

#define kToolBarHeight  44.0f

#define kCellDragDist           60
#define kMinimumGestureLength   40
#define kMaximumGestureLength   100
#define TabBarHeight 44
#define TabBarWidth 180

#define CameraButtonWidth 100
#define CameraButtonHeight 47

#define kFeedCellHeight 220.0f
#define kFeedCellWidth  320.0f

#define kAvatarSizeMedium   320.0f
#define kAvatarSizeSmall    150.0f

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
extern NSString *const kHMRecipeLanguageKey;
extern NSString *const kHMRecipeCategoryKey;
extern NSString *const kHMRecipeRecommandKey;
// Recipe subkeys
extern NSString *const kHMRecipeStepsContentKey;
extern NSString *const kHMRecipeStepsPhotoKey;
extern NSString *const kHMRecipeIngredientNameKey;
extern NSString *const kHMRecipeIngredientAmountKey;


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
extern NSString *const kHMRecipeAttributesPhotoCountKey;
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
extern NSString *const kHMUserCoverPhotoKey;
extern NSString *const kHMUserFirstNameKey;
extern NSString *const kHMUserLastNameKey;

#pragma mark - TMCache keys
extern NSString *const kHMColorSuffixKey;


#pragma mark - Save Class
extern NSString *const kHMSaveClassKey;
// Field keys
extern NSString *const kHMSaveFromUserKey;
extern NSString *const kHMSaveToUserKey;
extern NSString *const kHMSaveRecipeKey;

#pragma mark - Follow Class
extern NSString *const kHMFollowClassKey;
// Field keys
extern NSString *const kHMFollowFromUserKey;
extern NSString *const kHMFollowToUserKey;

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

extern NSString *const HMUploadAvatarDidFinishedNotification;