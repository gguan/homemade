//
//  HMSearchBar.m
//  homemade
//
//  Created by Guan Guan on 5/8/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMSearchBar.h"

@implementation HMSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.searchBarTextField setBackground:[UIImage imageNamed:@"searchFrame.png"]];
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}

-(UITextField *)searchBarTextField
{
	if (_searchBarTextField == nil) {
		for (UIView *v in [self subviews]) {
			if ([v isKindOfClass:[UITextField class]]) {
				_searchBarTextField = (UITextField *)v ;
				UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
				[self insertSubview:imageView belowSubview:_searchBarTextField];
				return (UITextField *)v;
			}
		}
	}
	return _searchBarTextField;
}


@end
