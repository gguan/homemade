//
//  HMConstants.m
//  homemade
//
//  Created by Guan Guan on 4/13/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMConstants.h"


NSString *const kHMUserDefaultsActivityFeedViewControllerLastRefreshKey    = @"com.parse.Anypic.userDefaults.activityFeedViewController.lastRefresh";
NSString *const kHMUserDefaultsCacheFacebookFriendsKey                     = @"com.parse.Anypic.userDefaults.cache.facebookFriends";

#pragma mark - PFObject Recipe Class
// Class key
NSString *const kHMRecipeClassKey    = @"Recipe";

// Field keys
NSString *const kHMRecipeTitleKey    = @"title";
NSString *const kHMRecipeOverviewKey = @"overview";
NSString *const kHMRecipeUserKey     = @"user";
NSString *const kHMRecipePhotoKey    = @"photo";
NSString *const kHMRecipeColorKey    = @"color";
NSString *const kHMRecipeDifficultyKey  = @"difficulty";
NSString *const kHMRecipeIngredientsKey = @"ingredients";
NSString *const kHMRecipeStepsKey    = @"steps";
NSString *const kHMRecipeTipsKey     = @"tips";
NSString *const kHMRecipeLanguageKey = @"language";
NSString *const kHMRecipeCategoryKey = @"category";
NSString *const kHMRecipeRecommandKey   = @"recommand";
// Recipe subkeys
NSString *const kHMRecipeStepsContentKey = @"content";
NSString *const kHMRecipeStepsPhotoKey = @"photo";
NSString *const kHMRecipeIngredientNameKey = @"name";
NSString *const kHMRecipeIngredientAmountKey = @"amount";

#pragma mark - PFObject Drink Photo Class
NSString *const kHMDrinkPhotoClassKey   = @"Photo";
NSString *const kHMDrinkPhotoUserKey    = @"user";
NSString *const kHMDrinkPhotoRecipeKey  = @"recipe";
NSString *const kHMDrinkPhotoPictureKey = @"picture";
NSString *const kHMDrinkPhotoNoteKey    = @"note";

#pragma mark - Cached Recipe Attributes
// keys
NSString *const kHMRecipeAttributesIsSavedByCurrentUserKey  = @"isSavedByCurrentUser";
NSString *const kHMRecipeAttributesSaveCountKey             = @"saveCount";
NSString *const kHMRecipeAttributesPhotoCountKey            = @"photoCount";
NSString *const kHMRecipeAttributesSaversKey                = @"savers";
NSString *const kHMRecipeAttributesIsMadeByCurrentUserKey   = @"isMadeByCurrentUser";
NSString *const kHMRecipeAttributesMakeCountKey             = @"madeCount";
NSString *const kHMRecipeAttributesMakersKey                = @"makers";
NSString *const kHMRecipeAttributesCommentCountKey          = @"commentCount";
NSString *const kHMRecipeAttributesCommentersKey            = @"commenters";

#pragma mark - Cached User Attributes
// keys
NSString *const kHMUserAttributesRecipeCountKey      = @"userRecipeCount";
NSString *const kHMUserAttributesMadeCountKey        = @"userMadeCount";
NSString *const kHMUserAttributesSaveCountKey        = @"userSaveCount";
NSString *const kHMUserAttributesIsFollowedByCurrentUserKey  = @"isFollowedByCurrentUser";

NSString *const kHMUserProfilePicMediumKey          = @"profilePictureMedium";
NSString *const kHMUserProfilePicSmallKey           = @"profilePictureSmall";
NSString *const kHMUserDisplayNameKey               = @"displayName";
NSString *const kHMUserEmailKey                     = @"email";
NSString *const kHMUserFacebookIDKey                = @"facebookId";
NSString *const kHMUserPhotoIDKey                   = @"photoId";
NSString *const kHMUserCoverPhotoKey                = @"coverPhoto";
NSString *const kHMUserFirstNameKey                 = @"firstName";
NSString *const kHMUserLastNameKey                  = @"lastName";

#pragma mark - TMCache keys
NSString *const kHMColorSuffixKey = @"colorArt";



#pragma mark - Save Class
NSString *const kHMSaveClassKey = @"Save";
// Field keys
NSString *const kHMSaveFromUserKey  = @"fromUser";
NSString *const kHMSaveToUserKey    = @"toUser";
NSString *const kHMSaveRecipeKey    = @"recipe";

#pragma mark - Comment Class
NSString *const kHMCommentClassKey = @"Comment";
// Field keys
NSString *const kHMCommentFromUserKey   = @"fromUser";
NSString *const kHMCommentContentKey    = @"content";
NSString *const kHMCommentTypeKey       = @"type";
NSString *const kHMCommentRecipeKey     = @"recipe";
NSString *const kHMCommentPhotoKey      = @"photo";
// Type values
NSString *const kHMCommentTypeRecipe    = @"recipe";
NSString *const kHMCommentTypePhoto     = @"photo";


#pragma mark - User Info Keys
NSString *const kHMEditPhotoViewControllerUserInfoCommentKey = @"comment";

#pragma mark - NSNotification
NSString *const HMCameraControllerDidFinishEditingPhotoNotification = @"com.gguan.drink.tabBarController.didFinishEditingPhoto";
NSString *const HMCommentControllerDidFinishEditingCommentNotification = @"com.gguan.drink.navController.didFinishEditingComment";

