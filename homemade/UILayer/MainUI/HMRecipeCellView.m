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
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // Initialization code
        
        // Init cell swipe left view
        self.cellLeft = [[HMCellLeftView alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 205.0)];
        
        self.backCover = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 205.0)];
        [self.backCover setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
        self.backCover.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.backCover.clipsToBounds = YES;
        
        self.photo = [[PFImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 205.0)];
        self.photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.clipsToBounds = YES;
        
        UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(0.0, 135.0, 320.0, 70.0)];
        banner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
                
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0, 7.0, 270.0, 30.0)];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:19.0];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.colorLine = [[UIView alloc] initWithFrame:CGRectMake(312.0, 135.0, 8.0, 70.0)];
        [self.colorLine setBackgroundColor:[UIColor clearColor]];
        self.colorLine.alpha = 0.95;
        
        self.divider = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.divider setFrame:CGRectMake(5.0f, 23.0f, 11.0f, 24.0f)];
        [self.divider setBackgroundImage:[UIImage imageNamed:@"divider.png"] forState:UIControlStateNormal];
        [self.divider setBackgroundImage:[UIImage imageNamed:@"divider.png"] forState:UIControlStateSelected];

//        NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
        
        // add save button
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.saveButton setFrame:CGRectMake(100.0f, 50.0f, 12.0f, 12.0f)];
        [self.saveButton setBackgroundColor:[UIColor clearColor]];
        [self.saveButton setAdjustsImageWhenHighlighted:NO];
        [self.saveButton setAdjustsImageWhenDisabled:NO];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"likeActive.png"] forState:UIControlStateSelected];
        [self.saveButton setSelected:YES];
        
        self.saveCount = [[UILabel alloc] initWithFrame:CGRectMake(118.0f, 50.0f, 40.0f, 12.0f)];
        [self.saveCount setBackgroundColor:[UIColor clearColor]];
        self.saveCount.textColor = [UIColor whiteColor];
        self.saveCount.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setFrame:CGRectMake(40.0f, 50.0f, 12.0f, 12.0f)];
        [self.commentButton setBackgroundColor:[UIColor clearColor]];
        [self.commentButton setAdjustsImageWhenHighlighted:NO];
        [self.commentButton setAdjustsImageWhenDisabled:NO];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentActive.png"] forState:UIControlStateSelected];
        [self.commentButton setSelected:YES];
        
        self.commentCount = [[UILabel alloc] initWithFrame:CGRectMake(58.0f, 50.0f, 40.0f, 12.0f)];
        [self.commentCount setBackgroundColor:[UIColor clearColor]];
        self.commentCount.textColor = [UIColor whiteColor];
        self.commentCount.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
        
        [banner addSubview:self.divider];
        [banner addSubview:self.titleLabel];
        [banner addSubview:self.saveButton];
        [banner addSubview:self.commentButton];
        [banner addSubview:self.saveCount];
        [banner addSubview:self.commentCount];
        
        
        // add shadow view
        UIView *dropshadowView = [[UIView alloc] init];
        dropshadowView.frame = CGRectMake(0.0, 0.0, 320.0, 205.0);
        [dropshadowView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
        dropshadowView.layer.masksToBounds = NO;
        dropshadowView.layer.shadowRadius = 2.0f;
        dropshadowView.layer.shadowOpacity = 0.7f;
        dropshadowView.layer.shadowOffset = CGSizeMake( 0.0f, 1.0f);
        dropshadowView.layer.shadowPath =
        [UIBezierPath bezierPathWithRect:dropshadowView.layer.bounds].CGPath;
        
        [self.contentView addSubview:dropshadowView];
        [self.contentView addSubview:self.cellLeft];
        [self.contentView addSubview:self.backCover];
        [self.backCover addSubview:self.photo];
        [self.backCover addSubview:banner];
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
                [self bounceToRight:0.3];
            } else {
                [self bounceToLeft:0.3];
            }
        } else {
            [self bounceToLeft:0.3];
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


@end
