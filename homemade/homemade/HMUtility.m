//
//  HMUtility.m
//  homemade
//
//  Created by Guan Guan on 4/28/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMUtility.h"
#import "UIImage+ResizeAdditions.h"

NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@implementation HMUtility

+ (void)saveRecipeInBackground:(id)recipe block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    
    PFQuery *queryExistingSaves = [PFQuery queryWithClassName:kHMSaveClassKey];
    [queryExistingSaves whereKey:kHMSaveRecipeKey equalTo:recipe];
    [queryExistingSaves whereKey:kHMSaveFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingSaves setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingSaves findObjectsInBackgroundWithBlock:^(NSArray *saves, NSError *error) {
        if (!error) {
            if ([saves count] > 0) {
                NSLog(@"The recipe has already been saved by user.");
            } else {
                // proceed to creating new save
                NSLog(@"Save recipe by user on Parse server.");
                PFObject *saveActivity = [PFObject objectWithClassName:kHMSaveClassKey];
                [saveActivity setObject:[PFUser currentUser] forKey:kHMSaveFromUserKey];
                [saveActivity setObject:[recipe objectForKey:kHMRecipeUserKey] forKey:kHMSaveToUserKey];
                [saveActivity setObject:recipe forKey:kHMSaveRecipeKey];
                
                PFACL *saveACL = [PFACL ACLWithUser:[PFUser currentUser]];
                [saveACL setPublicReadAccess:YES];
                [saveACL setWriteAccess:YES forUser:[recipe objectForKey:kHMRecipeUserKey]];
                saveActivity.ACL = saveACL;
                
                [saveActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (completionBlock) {
                        completionBlock(succeeded, error);
                    }
                    
                    // refresh cache
                    PFQuery *query = [HMUtility queryForSavesOnRecipe:recipe cachePolicy:kPFCachePolicyNetworkOnly];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            BOOL isSavedByCurrentUser = NO;
                            for (PFObject *save in objects) {
                                if ([[[save objectForKey:kHMSaveFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                    isSavedByCurrentUser = YES;
                                    break;
                                }
                            }
                            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInt:[objects count]],
                                                        kHMRecipeAttributesSaveCountKey,
                                                        [NSNumber numberWithBool:isSavedByCurrentUser],
                                                        kHMRecipeAttributesIsSavedByCurrentUserKey,
                                                        nil];
                            [[HMCache sharedCache] setAttributesForRecipe:recipe attributes:attributes];
                        }
                    }];
                }];
                
            }
        }
    }];
}
+ (void)unSaveRecipeInBackground:(id)recipe block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    
    PFQuery *queryExistingSaves = [PFQuery queryWithClassName:kHMSaveClassKey];
    [queryExistingSaves whereKey:kHMSaveRecipeKey equalTo:recipe];
    [queryExistingSaves whereKey:kHMSaveFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingSaves setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingSaves findObjectsInBackgroundWithBlock:^(NSArray *saves, NSError *error) {
    
        if (!error) {
            for (PFObject *save in saves) {
                [save delete];
            }
            if (completionBlock) {
                completionBlock(YES,nil);
            }
            
            // refresh cache
            PFQuery *query = [HMUtility queryForSavesOnRecipe:recipe cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    BOOL isSavedByCurrentUser = NO;
                    for (PFObject *save in objects) {
                        if ([[[save objectForKey:kHMSaveFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            isSavedByCurrentUser = YES;
                            break;
                        }
                    }
                    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [NSNumber numberWithInt:[objects count]],
                                                kHMRecipeAttributesSaveCountKey,
                                                [NSNumber numberWithBool:isSavedByCurrentUser],
                                                kHMRecipeAttributesIsSavedByCurrentUserKey,
                                                nil];
                    [[HMCache sharedCache] setAttributesForRecipe:recipe attributes:attributes];
                }
            }];
        }
    }];
}


+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData {
    if (newProfilePictureData.length == 0) {
        return;
    }
    
    // The user's Facebook profile picture is cached to disk. Check if the cached profile picture data matches the incoming profile picture. If it does, avoid uploading this data to Parse.
    
    NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory
    
    NSURL *profilePictureCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:@"FacebookProfilePicture.jpg"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[profilePictureCacheURL path]]) {
        // We have a cached Facebook profile picture
        
        NSData *oldProfilePictureData = [NSData dataWithContentsOfFile:[profilePictureCacheURL path]];
        
        if ([oldProfilePictureData isEqualToData:newProfilePictureData]) {
            return;
        }
    }
    
    UIImage *image = [UIImage imageWithData:newProfilePictureData];
    
    UIImage *mediumImage = [image thumbnailImage:320 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    UIImage *smallRoundedImage = [image thumbnailImage:150 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationLow];
    
    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);
    
    if (mediumImageData.length > 0) {
        PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileMediumImage forKey:kHMUserProfilePicMediumKey];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
    
    if (smallRoundedImageData.length > 0) {
        PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileSmallRoundedImage forKey:kHMUserProfilePicSmallKey];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
}

+ (BOOL)userHasValidFacebookData:(PFUser *)user {
    NSString *facebookId = [user objectForKey:kHMUserFacebookIDKey];
    return (facebookId && facebookId.length > 0);
}

+ (BOOL)userHasProfilePictures:(PFUser *)user {
    PFFile *profilePictureMedium = [user objectForKey:kHMUserProfilePicMediumKey];
    PFFile *profilePictureSmall = [user objectForKey:kHMUserProfilePicSmallKey];
    
    return (profilePictureMedium && profilePictureSmall);
}


#pragma mark Display Name

+ (NSString *)firstNameForDisplayName:(NSString *)displayName {
    if (!displayName || displayName.length == 0) {
        return @"Someone";
    }
    
    NSArray *displayNameComponents = [displayName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *firstName = [displayNameComponents objectAtIndex:0];
    if (firstName.length > 100) {
        // truncate to 100 so that it fits in a Push payload
        firstName = [firstName substringToIndex:100];
    }
    return firstName;
}


#pragma mark - Common queries 
+ (PFQuery *)queryForSavesOnRecipe:(PFObject *)recipe cachePolicy:(PFCachePolicy)cachePolicy {
    PFQuery *query = [PFQuery queryWithClassName:kHMSaveClassKey];
    [query whereKey:kHMSaveRecipeKey equalTo:recipe];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kHMSaveFromUserKey];
    [query includeKey:kHMSaveRecipeKey];
    return query;
}

+ (PFQuery *)queryForCommentsOnRecipe:(PFObject *)recipe cachePolicy:(PFCachePolicy)cachePolicy {
    PFQuery *query = [PFQuery queryWithClassName:kHMCommentClassKey];
    [query whereKey:kHMCommentRecipeKey equalTo:recipe];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kHMSaveFromUserKey];
    [query includeKey:kHMSaveRecipeKey];
    return query;
}

+ (PFQuery *)queryForPhotosOnRecipe:(PFObject *)recipe cachePolicy:(PFCachePolicy)cachePolicy {
    PFQuery *query = [PFQuery queryWithClassName:kHMDrinkPhotoClassKey];
    [query whereKey:kHMDrinkPhotoRecipeKey equalTo:recipe];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kHMDrinkPhotoUserKey];
    [query includeKey:kHMDrinkPhotoRecipeKey];
    return query;
}


#pragma mark Shadow Rendering

+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {
    // Push the context
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y, rect.size.width + 20.0f, rect.size.height + 10.0f));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x,
                                          rect.origin.y - 5.0f,
                                          rect.size.width,
                                          rect.size.height + 5.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (CGFloat)textHeight:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width {
    return ceilf([text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height);
}

+ (CGFloat)screenHeight {
    
    return [UIScreen mainScreen].applicationFrame.size.height;
}

+ (UIFont *)appFontOfSize:(CGFloat)size {
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (NSString *)getPreferredLanguage {
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

+ (NSArray *)getCategories {
    return @[@"APERITIFS", @"VODKA", @"GIN", @"TEQUILA", @"RUM", @"WHISKEY", @"BRANDY", @"LIQUEURS & FORTIFIED WINES", @"MOCKTAILS", @"BEER", @"NON ALCOHOLIC DRINKS"];
}

@end
