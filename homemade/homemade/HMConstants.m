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
NSString *const kHMRecipeDifficultyKey   = @"difficulty";
NSString *const kHMRecipeIngredientsKey  = @"ingredients";
NSString *const kHMRecipeStepsKey    = @"steps";
NSString *const kHMRecipeTipsKey     = @"tips";

#pragma mark - Cached Recipe Attributes
// keys
NSString *const kHMRecipeAttributesIsSavedByCurrentUserKey  = @"isSavedByCurrentUser";
NSString *const kHMRecipeAttributesSaveCountKey             = @"saveCount";
NSString *const kHMRecipeAttributesSaversKey                = @"savers";
NSString *const kHMRecipeAttributesIsMadeByCurrentUserKey   = @"isMadeByCurrentUser";
NSString *const kHMRecipeAttributesMakeCountKey             = @"madeCount";
NSString *const kHMRecipeAttributesMakersKey                = @"makers";
NSString *const kHMRecipeAttributesCommentCountKey          = @"commentCount";
NSString *const kHMRecipeAttributesCommentersKey             = @"commenters";

#pragma mark - Cached User Attributes
// keys
NSString *const kHMUserAttributesRecipeCountKey      = @"userRecipeCount";
NSString *const kHMUserAttributesMadeCountKey        = @"userMadeCount";
NSString *const kHMUserAttributesSaveCountKey        = @"userSaveCount";
NSString *const kHMUserAttributesIsFollowedByCurrentUserKey  = @"isFollowedByCurrentUser";

NSString *const kHMUserProfilePicSmallKey                      = @"profilePictureSmall";

#pragma mark - TMCache keys
NSString *const kHMColorSuffixKey = @"colorArt";


#pragma mark - Save Class
NSString *const kHMSaveClassKey = @"Save";
// Field keys
NSString *const kHMSaveFromUserKey  = @"fromUser";
NSString *const kHMSaveToUserKey    = @"toUser";
NSString *const kHMSaveRecipeKey    = @"recipe";

#pragma mark - Save Class
NSString *const kHMCommentClassKey = @"Comment";
// Field keys
NSString *const kHMCommentFromUserKey  = @"fromUser";
NSString *const kHMCommentRecipeKey    = @"recipe";
