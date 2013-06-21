//
//  HMRecipeCellView.m
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeCellView.h"
#import <QuartzCore/QuartzCore.h>

@interface HMRecipeCellView()

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation HMRecipeCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;    
        [self setBackgroundColor:[UIColor clearColor]];
        
        // Initialization code
        
        // Init cell swipe left view
        self.cellLeft = [[HMCellLeftView alloc] initWithFrame:CGRectMake(20.0, 0.0, self.frame.size.width, kFeedCellHeight)];
        
        self.backCover = [[UIView alloc] initWithFrame:CGRectMake(20.0, 10.0, kFeedCellWidth, kFeedCellHeight)];
        self.backCover.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

        
        self.photo = [[PFImageView alloc] initWithFrame:self.backCover.frame];
        self.photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.clipsToBounds = YES;
        [self.backCover addSubview:self.photo];
        
        
        
        UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(20.0, 155.0, kFeedCellWidth, 60.0)];
        banner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self.backCover addSubview:banner];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 7.0, 270.0, 30.0)];
        self.titleLabel.font = [HMUtility appFontOfSize:19.0];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.colorLine = [[UIView alloc] initWithFrame:CGRectMake(310.0, 155.0, 10.0, 60.0)];
        [self.colorLine setBackgroundColor:[UIColor clearColor]];
        self.colorLine.alpha = 0.95;
        
        self.divider = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.divider setFrame:CGRectMake(5.0f, 23.0f, 11.0f, 24.0f)];
        [self.divider setBackgroundImage:[UIImage imageNamed:@"divider.png"] forState:UIControlStateNormal];
        [self.divider setBackgroundImage:[UIImage imageNamed:@"divider.png"] forState:UIControlStateSelected];
        
        // add save button
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.saveButton setFrame:CGRectMake(90.0f, 40.0f, 18.0f, 18.0f)];
        [self.saveButton setBackgroundColor:[UIColor clearColor]];
        [self.saveButton setAdjustsImageWhenHighlighted:NO];
        [self.saveButton setAdjustsImageWhenDisabled:NO];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
        
        self.saveCount = [[UILabel alloc] initWithFrame:CGRectMake(110.0f, 41.0f, 40.0f, 18.0f)];
        [self.saveCount setBackgroundColor:[UIColor clearColor]];
        self.saveCount.textColor = [UIColor whiteColor];
        self.saveCount.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setFrame:CGRectMake(30.0f, 40.0f, 18.0f, 18.0f)];
        [self.commentButton setBackgroundColor:[UIColor clearColor]];
        [self.commentButton setAdjustsImageWhenHighlighted:NO];
        [self.commentButton setAdjustsImageWhenDisabled:NO];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        
        self.commentCount = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 41.0f, 40.0f, 18.0f)];
        [self.commentCount setBackgroundColor:[UIColor clearColor]];
        self.commentCount.textColor = [UIColor whiteColor];
        self.commentCount.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        
        [banner addSubview:self.divider];
        [banner addSubview:self.titleLabel];
        [banner addSubview:self.saveButton];
        [banner addSubview:self.commentButton];
        [banner addSubview:self.saveCount];
        [banner addSubview:self.commentCount];
        
        
        // add shadow view
//        UIView *dropshadowView = [[UIView alloc] init];
//        dropshadowView.frame = CGRectMake(0.0, 0.0, 320.0, 205.0);
//        [dropshadowView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
//        dropshadowView.layer.masksToBounds = NO;
//        dropshadowView.layer.shadowRadius = kShadowRadius;
//        dropshadowView.layer.shadowOpacity = kShadowOpacity;
//        dropshadowView.layer.shadowOffset = kShadowOffset;
//        dropshadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:dropshadowView.layer.bounds].CGPath;
//        
//        [self.contentView addSubview:dropshadowView];
        
        [self.contentView addSubview:self.cellLeft];
        [self.contentView addSubview:self.backCover];
        
        [self.contentView addSubview:self.colorLine];
        
        // Add Pan Gesture to cell view
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePan:)];
        _panGestureRecognizer.delegate = self;
        _panGestureRecognizer.maximumNumberOfTouches = 1;
        _panGestureRecognizer.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:_panGestureRecognizer];
        
        _leftIsVisible = NO;
    }
    
    return self;
}


// Override set method
- (void)setRecipe:(PFObject *)aRecipe {
    _recipe = aRecipe;
    
    self.titleLabel.text = [_recipe objectForKey:kHMRecipeTitleKey];
    self.photo.file = [_recipe objectForKey:kHMRecipePhotoKey];
    
    // user's stuff
    PFUser *user = [_recipe objectForKey:kHMRecipeUserKey];
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *profilePictureSmall = [user objectForKey:kHMUserProfilePicSmallKey];
            if (profilePictureSmall) {
                [self.cellLeft.avatarImageView setFile:profilePictureSmall];
            } else {
                [self.cellLeft.avatarImageView setFile:[PFFile fileWithData:UIImagePNGRepresentation([UIImage imageNamed:@"AvatarPlaceholder.png"])]];
            }
        }
    }];
    
    
//    NSString *authorName = [user objectForKey:kHMUserDisplayNameKey];
//    [self.userButton setTitle:authorName forState:UIControlStateNormal];
//    NSLog(authorName);
    
    
    // Add button listening selectors
    [self.cellLeft.saveButton addTarget:self action:@selector(didTapSaveRecipeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cellLeft.commentButton addTarget:self action:@selector(didTapCommentRecipeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cellLeft.shareButton addTarget:self action:@selector(didTapShareRecipeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNeedsDisplay];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Gesture Recognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _panGestureRecognizer) {
        UIScrollView *superview = (UIScrollView *) self.superview;
        CGPoint translation = [(UIPanGestureRecognizer *) gestureRecognizer translationInView:superview];
        
        // Make sure it is scrolling horizontally
        return ((fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO && (superview.contentOffset.y == 0.0 && superview.contentOffset.x == 0.0));
    }
    return NO;
}

- (void)_handlePan:(UIPanGestureRecognizer *)gesture {
    UIGestureRecognizerState state = [gesture state];

    CGPoint touchPoint = [gesture locationInView:self];
    
    CGFloat xPos = 0.0;
    
    if (state == UIGestureRecognizerStateBegan) {
        
        gestureStartPoint = [gesture locationInView:self];
        
    }  else if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        
        if (_leftIsVisible == NO) {
            xPos = touchPoint.x - gestureStartPoint.x;
            if (xPos > kMaximumGestureLength) {
                xPos = kMaximumGestureLength;
            }
            if (xPos <= 0) {
                xPos = 0;
            }
        } else {
            xPos = touchPoint.x - gestureStartPoint.x + kCellDragDist;
            if (xPos > kMaximumGestureLength) {
                xPos = kMaximumGestureLength;
            }
            if (xPos <= 0) {
                xPos = 0;
            }
        }
       
        CGRect frame = self.backCover.frame;
        frame.origin = CGPointMake(xPos, 0);
        self.backCover.frame = frame;

    }
    else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        
        if (_leftIsVisible == NO) {
            xPos = touchPoint.x - gestureStartPoint.x;
            if (xPos > kMinimumGestureLength) {
                if(xPos - kMinimumGestureLength < 20) {
                    [self bounceToRight:0.1];
                } else {
                    [self bounceToRight:0.3];
                }
            } else {
                [self bounceToLeft:0.2];
            }
        } else {
            if (touchPoint.x < 20) {
                [self bounceToLeft:0.1];
            } else {
                [self bounceToLeft:0.3];
            }
        
        }
    }
}

// move image back to left
- (void)bounceToLeft:(CGFloat)duration {
    CGRect frame = self.backCover.frame;
    frame.origin = CGPointMake(0, 0);
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backCover.frame = frame;
                     }
                     completion:^(BOOL finished){
                         _leftIsVisible = NO;
                     }];
}

- (void)bounceToRight:(CGFloat)duration {
    CGRect frame = self.backCover.frame;
    frame.origin = CGPointMake(kCellDragDist, 0);
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backCover.frame = frame;
                     }
                     completion:^(BOOL finished){
                         _leftIsVisible = YES;
                     }];
}

// Configures save Button to match the give save status
- (void)setSaveStatus:(BOOL)saved {
    [self.cellLeft.saveButton setSelected:saved];
}

// Enable the save button to start receiving actions
- (void)shouldEnableSaveButton:(BOOL)enable {
    if (!enable) {
        NSLog(@"Remove listener");
        [self.cellLeft.saveButton removeTarget:self.cellLeft.saveButton action:@selector(didTapSaveRecipeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
         NSLog(@"Add listener");
        [self.cellLeft.saveButton addTarget:self.cellLeft.saveButton action:@selector(didTabSaveRecipeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - ()

- (void)didTapSaveRecipeButtonAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(recipeTableCellView:didTapSaveButton:recipe:)]) {
        NSLog(@"Tap save button...");
        [_delegate recipeTableCellView:self didTapSaveButton:button recipe:self.recipe];
    }
}

- (void)didTapCommentRecipeButtonAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(recipeTableCellView:didTapCommentButton:recipe:)]) {
        NSLog(@"Tap comment button...");
        [_delegate recipeTableCellView:self didTapCommentButton:button recipe:self.recipe];
    }
}

- (void)didTapShareRecipeButtonAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(recipeTableCellView:didTapSaveButton:recipe:)]) {
        NSLog(@"Tap share button...");
        [_delegate recipeTableCellView:self didTapShareButton:button recipe:self.recipe];
    }
}


@end
