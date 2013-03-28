//
//  HMRecipeTipCell.m
//  homemade
//
//  Created by Sai Luo on 3/27/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeTipCell.h"

@implementation HMRecipeTipCell
@synthesize numberView = _numberView;
@synthesize labelHeight = _labelHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        self.numberView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        self.numberView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.numberView];

    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLableHeight:(int)height;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.labelHeight = height;
//        self.numberView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
//        self.numberView.backgroundColor = [UIColor yellowColor];
//        [self addSubview:self.numberView];//comment out for testing
        
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
    
//    self.textLabel.frame = CGRectMake(30, 12, 250, self.labelHeight ); // same as steps
    self.textLabel.frame = CGRectMake(0, 12, 280, self.labelHeight ); //no numberView
    self.textLabel.backgroundColor = [UIColor blueColor];
    
}


@end
