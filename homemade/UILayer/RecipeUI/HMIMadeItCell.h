//
//  HMIMadeItCell.h
//  homemade
//
//  Created by Y.CORP.YAHOO.COM\gguan on 6/7/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Parse/Parse.h>

@interface HMIMadeItCell : PFTableViewCell

@property (strong, nonatomic) PFObject *photoObject;
@property (strong, nonatomic) PFImageView *avatar;
@property (strong, nonatomic) PFImageView *photo;
@property (strong, nonatomic) UILabel *timestampLabel;
@property (strong, nonatomic) UILabel *commentButtonLabel;
@property (strong, nonatomic) UILabel *noteLabel;
@property (strong, nonatomic) UIView *container;

+ (CGFloat) cellInitialHeight;
+ (CGFloat) heightForText:(NSString *)text;

- (void) adjustSize;

@end
