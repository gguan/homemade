//
//  HMRecipeStepCell.m
//  homemade
//
//  Created by Sai Luo on 3/27/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeStepCell.h"

@implementation HMRecipeStepCell
@synthesize labelHeight = _labelHeight;
@synthesize leftNumberView = _leftNumberView;
@synthesize rightNumberView = _rightNumberView;
@synthesize leftImageView = _leftImageView;
@synthesize rightImageView = _rightImageView;
@synthesize leftLabel = _leftLabel;
@synthesize rightLabel = _rightLabel;

//Do not use this default one, make sure pass in the labelHeight
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLabelHeight:(int)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:67.0/255.0 blue:29.0/255.0 alpha:1.0];
        self.labelHeight = height;
        
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 135, 100)]; // your positioning here
        self.leftImageView.backgroundColor = [UIColor clearColor];
        self.leftNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 30, 30)];
        self.leftNumberView.backgroundColor = [UIColor clearColor];
        [self.leftImageView addSubview:self.leftNumberView];
        
        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(145, 10, 135, 100)];// your positioning here
        self.rightImageView.backgroundColor = [UIColor clearColor];
        self.rightNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 30, 30)];
        self.rightNumberView.backgroundColor = [UIColor clearColor];
        [self.rightImageView addSubview:self.rightNumberView];
        
//        self.textLabel.frame = CGRectMake( 0, 120, 280, self.labelHeight ); // your positioning here
//        self.textLabel.backgroundColor = [UIColor blueColor];
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 135, self.labelHeight)];
        self.leftLabel.backgroundColor = [UIColor purpleColor];
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 120, 135, self.labelHeight)];
        self.rightLabel.backgroundColor = [UIColor purpleColor];
        
//        [self.textLabel addSubview:self.leftLabel];
//        [self.textLabel addSubview:self.rightLabel];
        
        [self.contentView addSubview:self.leftImageView];
        [self.contentView addSubview:self.rightImageView];
//        [self.contentView addSubview:self.textLabel];
        
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.rightLabel];

    
        [self layoutSubviews];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect b = [self bounds];
    b.size.width -= 40;
    b.origin.x = 20;
    [self.contentView setFrame:b];
    
//    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 135, 100)]; // your positioning here
//    self.leftImageView.backgroundColor = [UIColor redColor];
//    self.leftNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    self.leftNumberView.backgroundColor = [UIColor yellowColor];
//    [self.leftImageView addSubview:self.leftNumberView];
//    
//    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(145, 10, 135, 100)];// your positioning here
//    self.rightImageView.backgroundColor = [UIColor redColor];
//    self.rightNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    self.rightNumberView.backgroundColor = [UIColor yellowColor];
//    [self.rightImageView addSubview:self.rightNumberView];
//    
//    self.textLabel.frame = CGRectMake( 0, 120, 280, self.labelHeight ); // your positioning here
//    self.textLabel.backgroundColor = [UIColor blueColor];
//    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 135, self.labelHeight)];
//    self.leftLabel.backgroundColor = [UIColor purpleColor];
//    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 0, 135, self.labelHeight)];
//    self.rightLabel.backgroundColor = [UIColor purpleColor];
//
//    [self.textLabel addSubview:self.leftLabel];
//    [self.textLabel addSubview:self.rightLabel];
//    
//    [self.contentView addSubview:self.leftImageView];
//    [self.contentView addSubview:self.rightImageView];
//    [self.contentView addSubview:self.textLabel];

}

@end
