//
//  HMRecipeTipCell.h
//  homemade
//
//  Created by Sai Luo on 3/27/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMRecipeTipCell : UITableViewCell
{
    
}

@property (nonatomic) int labelHeight;
@property (nonatomic,strong) UIView *numberView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLableHeight:(int)height;

@end
