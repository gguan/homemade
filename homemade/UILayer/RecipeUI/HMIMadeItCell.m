//
//  HMIMadeItCell.m
//  homemade
//
//  Created by Y.CORP.YAHOO.COM\gguan on 6/7/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMIMadeItCell.h"
#import <QuartzCore/QuartzCore.h>

#define AvatarSize 50.0f
#define PictureSize 230.0f
#define TimeLabelHeight 25.0f
#define CommentButtonHeight 35.0f
#define TextFontSize 12.0f

@implementation HMIMadeItCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // user avatar
        self.avatar = [[PFImageView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, AvatarSize, AvatarSize)];
        self.avatar.layer.cornerRadius = AvatarSize / 2;
        self.avatar.layer.masksToBounds = YES;
        [self addSubview:self.avatar];

        // create a container view
        self.container = [[UIView alloc] initWithFrame:CGRectMake(self.avatar.frame.origin.x + AvatarSize + 20.0f, 5.0f, PictureSize, TimeLabelHeight + PictureSize + CommentButtonHeight)];
        [self.container setBackgroundColor:[UIColor whiteColor]];
        self.container.layer.shadowRadius = 0.4f;
        self.container.layer.shadowOpacity = 0.4f;
        self.container.layer.shadowOffset = CGSizeMake( 0.0f, 0.4f);
        self.container.layer.cornerRadius = 3.5f;
        
        // add photo imageview
        self.photo = [[PFImageView alloc] initWithFrame:CGRectMake(0.0f, TimeLabelHeight, PictureSize, PictureSize)];
        [self.container addSubview:self.photo];
        
        // add note label
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10.0f, 5.0f, self.container.bounds.size.width - 20.0f, 0.0f)];
        self.noteLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.noteLabel.numberOfLines = 0;
        self.noteLabel.textColor = [UIColor blackColor];
        self.noteLabel.font = [UIFont systemFontOfSize:TextFontSize];
        [self.container addSubview:self.noteLabel];
        
        // add timestamp label
        self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10.0f, 5.0f, self.container.bounds.size.width - 10.0f - 72.0f, 15.0f)];
        [self.timestampLabel setTextColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:1.0f]];
        [self.timestampLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        [self.timestampLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.timestampLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [self.timestampLabel setBackgroundColor:[UIColor clearColor]];
        [self.container addSubview:self.timestampLabel];
        
        // add comment label
        self.commentButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, self.container.frame.size.height - CommentButtonHeight + 5, PictureSize - 20, CommentButtonHeight - 10)];
        [self.commentButtonLabel setText:@"  Comment..."];
        [self.commentButtonLabel setTextColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:1.0f]];
        [self.commentButtonLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        [self.commentButtonLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.commentButtonLabel setFont:[UIFont systemFontOfSize:TextFontSize]];
        [self.commentButtonLabel setBackgroundColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:0.2f]];
        self.commentButtonLabel.layer.cornerRadius = 3.5f;
        self.commentButtonLabel.layer.borderColor = [UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:0.3f].CGColor;
        self.commentButtonLabel.layer.borderWidth = 0.2f;
        [self.container addSubview:self.commentButtonLabel];
        
        [self addSubview:self.container];
    }
    
    return self;
}

+ (CGFloat) cellInitialHeight {
    return TimeLabelHeight + PictureSize + CommentButtonHeight + 10;
}

+ (CGFloat)heightForText:(NSString *)text {
    CGFloat height = 10.0f;
    height += ceilf([text sizeWithFont:[UIFont systemFontOfSize:TextFontSize] constrainedToSize:CGSizeMake(PictureSize - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height);
    return height;
}

- (void) adjustSize {
    CGFloat noteHeight = [HMIMadeItCell heightForText:self.noteLabel.text];
    NSLog(@"%@",self.noteLabel.text);
    self.container.frame = CGRectMake(self.avatar.frame.origin.x + AvatarSize + 20.0f, 5.0f, PictureSize, TimeLabelHeight + PictureSize + CommentButtonHeight + noteHeight);
    self.noteLabel.frame = CGRectMake( 10.0f, 5.0f, self.container.bounds.size.width - 20.0f, noteHeight);
    self.timestampLabel.frame = CGRectMake( 10.0f, 5.0f + noteHeight, self.container.bounds.size.width - 10.0f - 72.0f, 15.0f);
    self.photo.frame = CGRectMake(0.0f, TimeLabelHeight + noteHeight, PictureSize, PictureSize);
    self.commentButtonLabel.frame = CGRectMake(10.0f, self.container.frame.size.height - CommentButtonHeight + 5, PictureSize - 20, CommentButtonHeight - 10);

}

@end
