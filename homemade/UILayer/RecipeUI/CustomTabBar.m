//
//  CustomTabBar.m
//  CustomTabBar
//
//  Created by Peter Boctor on 1/2/11.
//
// Copyright (c) 2011 Peter Boctor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "CustomTabBar.h"
#define TAB_ARROW_IMAGE_TAG 2394859
#define SELECTED_ITEM_TAG 2394860

@interface CustomTabBar (PrivateMethods)
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex;
- (void) addTabBarArrowAtIndex:(NSUInteger)itemIndex;
-(UIButton*) buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width;
-(UIImage*) tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;
-(UIImage*) tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;
@end

@implementation CustomTabBar
@synthesize buttons;

- (id) initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <CustomTabBarDelegate>*)customTabBarDelegate
{
    if (self = [super init])
    {
        
        
        // The tag allows callers withe multiple controls to distinguish between them
        self.tag = objectTag;
        
        // Set the delegate
        delegate = customTabBarDelegate;
        
        
        // Adjust our width based on the number of items & the width of each item
        self.frame = CGRectMake(0, 0, itemSize.width * itemCount, itemSize.height);
        
        // Initalize the array we use to store our buttons
        self.buttons = [[NSMutableArray alloc] initWithCapacity:itemCount];
        
        // horizontalOffset tracks the proper x value as we add buttons as subviews
        CGFloat horizontalOffset = 0;
        
        
        // Iterate through each item
        for (NSUInteger i = 0 ; i < itemCount ; i++)
        {
            // Create a button
            UIButton* button = [self buttonAtIndex:i width:self.frame.size.width/itemCount];
            
            // Register for touch events
            [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
            
            // Add the button to our buttons array
            [buttons addObject:button];
            
            // Set the button's x offset
            button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);
            
            [button setBackgroundColor:   [UIColor clearColor]];
            // Add the button as our subview
            [self addSubview:button];
            
            // Advance the horizontal offset
            horizontalOffset = horizontalOffset + itemSize.width;
        }
    }
    
    return self;
}

-(void) dimAllButtonsExcept:(UIButton*)selectedButton
{
    for (UIButton* button in buttons)
    {
        if (button == selectedButton)
        {
            button.selected = YES;
            
            button.highlighted = NO;
            button.tag = SELECTED_ITEM_TAG;
            
            UIImageView* tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
            NSUInteger selectedIndex = [buttons indexOfObjectIdenticalTo:button];
            if (tabBarArrow)
            {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                CGRect frame = tabBarArrow.frame;
                frame.origin.x = [self horizontalLocationFor:selectedIndex];
                tabBarArrow.frame = frame;
                [UIView commitAnimations];
            }
            else
            {
                [self addTabBarArrowAtIndex:selectedIndex];
            }
        }
        else
        {
            button.selected = NO;
            button.highlighted = NO;
            button.tag = 0;
        }
    }
}

- (void)touchDownAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
    
    if ([delegate respondsToSelector:@selector(touchDownAtItemAtIndex:)])
        [delegate touchDownAtItemAtIndex:[buttons indexOfObject:button]];
    
}

- (void)touchUpInsideAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
    
    if ([delegate respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
        [delegate touchUpInsideItemAtIndex:[buttons indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
}

- (void) selectItemAtIndex:(NSInteger)index
{
    // Get the right button to select
    UIButton* button = [buttons objectAtIndex:index];

    [self dimAllButtonsExcept:button];
}





- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    UIImageView* tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
    
    // A single tab item's width is the same as the button's width
    UIButton* button = [buttons objectAtIndex:tabIndex];
    CGFloat tabItemWidth = button.frame.size.width;
    
    // A half width is tabItemWidth divided by 2 minus half the width of the arrow
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
    
    // The horizontal location is the index times the width plus a half width
    return button.frame.origin.x + halfTabItemWidth;
}

- (void) addTabBarArrowAtIndex:(NSUInteger)itemIndex
{
    UIImage* tabBarArrowImage = [delegate tabBarArrowImage];
    UIImageView* tabBarArrow = [[UIImageView alloc] initWithImage:tabBarArrowImage];
    tabBarArrow.tag = TAB_ARROW_IMAGE_TAG;
    [self addSubview:tabBarArrow];
    
    // To get the vertical location we go up by the height of arrow and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
    CGFloat verticalLocation = 40 - tabBarArrowImage.size.height;
    tabBarArrow.frame = CGRectMake([self horizontalLocationFor:itemIndex], verticalLocation, tabBarArrowImage.size.width, tabBarArrowImage.size.height);
}

// Create a button at the provided index
- (UIButton*) buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width
{
    // Create a new button with the right dimensions
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, width, self.frame.size.height);
    
    // Ask the delegate for the button's image
    UIImage* rawButtonImage = [delegate imageFor:self atIndex:itemIndex];
    // Create the normal state image by converting the image's background to gray
    NSString* subTitle = [delegate titleFor:self atIndex:itemIndex];
    [button setTitle:subTitle forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal]; // SET the colour for your wishes
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted]; // SET the colour for your wishes
    //   [button setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, .f, -10.f)];
    // Set the gray & blue images as the button states
    [button setImage:rawButtonImage forState:UIControlStateNormal];
    [button setImage:rawButtonImage forState:UIControlStateHighlighted];
    [button setImage:rawButtonImage forState:UIControlStateSelected];
    
    // Ask the delegate for the highlighted/selected state image & set it as the selected background state
    
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat itemWidth = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)  ? self.window.frame.size.height : self.window.frame.size.width)/buttons.count;
    // horizontalOffset tracks the x value
    CGFloat horizontalOffset = 0;
    
    // Iterate through each button
    for (UIButton* button in buttons)
    {
        // Set the button's x offset
        button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);
        
        // Advance the horizontal offset
        horizontalOffset = horizontalOffset + itemWidth;
    }
    
    // Move the arrow to the new button location
    UIButton* selectedButton = (UIButton*)[self viewWithTag:SELECTED_ITEM_TAG];
    [self dimAllButtonsExcept:selectedButton];
}




@end
