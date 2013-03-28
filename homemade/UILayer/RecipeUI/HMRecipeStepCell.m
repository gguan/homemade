//
//  HMRecipeStepCell.m
//  homemade
//
//  Created by Sai Luo on 3/27/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeStepCell.h"

@implementation HMRecipeStepCell
@synthesize labelHeight,numberView;

//Do not use this default one, make sure pass in the labelHeight
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.numberView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        self.numberView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.numberView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLabelHeight:(int)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.labelHeight = height;
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.numberView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        self.numberView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.numberView];
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
    
    self.imageView.frame = CGRectMake( 30, 10, 150, 100 ); // your positioning here
    self.imageView.backgroundColor = [UIColor redColor];
    self.textLabel.frame = CGRectMake( 30, 120, 250, self.labelHeight ); // your positioning here
    self.textLabel.backgroundColor = [UIColor blueColor];

   
}

@end
