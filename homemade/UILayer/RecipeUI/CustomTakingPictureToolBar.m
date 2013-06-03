//
//  CustomTakingPictureToolBar.m
//  ECSlidingViewController
//
//  Created by Xiaodi Xing on 10/31/12.
//
//

#import "CustomTakingPictureToolBar.h"
#import "PAPUtility.h"
#define BUTTON_GAP_SPACE  50


@interface  CustomTakingPictureToolBar()

-(UIButton*) buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width;
@end


@implementation CustomTakingPictureToolBar
@synthesize buttons;

- (id) initWithItemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <CustomTakingPictureToolBarDelegate>*)customTabBarDelegate
{
    if (self = [super init])
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        // The tag allows callers withe multiple controls to distinguish between them
        self.tag = objectTag;
        [self setBackgroundColor:[PAPUtility Red]];
        // Set the delegate
        delegate = customTabBarDelegate;
        

        
        // Adjust our width based on the number of items & the width of each item
        self.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
        
        // Initalize the array we use to store our buttons
        self.buttons = [[NSMutableArray alloc] initWithCapacity:3];
        
        
        // Iterate through each item
        for (NSUInteger i = 0 ; i < 3; i++)
        {
            // Create a button
            UIButton* button = [self buttonAtIndex:i width:(self.frame.size.width-2*BUTTON_GAP_SPACE)/3];
            
            // Register for touch events
            [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
            
            // Add the button to our buttons array
            [buttons addObject:button];
            
            // Set the button's x offset
            if (i == 0) {
                button.frame = CGRectMake(7, 8, 28, 28);
            }
            if (i == 1) {
                button.frame = CGRectMake(self.frame.size.width/2 - 45, 1, 90, 42);
            }
            if (i == 2) {
                button.frame = CGRectMake(self.frame.size.width - 28 -7, 8, 28, 28);
            }
       
            
            // Add the button as our subview
            [self addSubview:button];
            
            // Advance the horizontal offset
        
        }
    }
    
    return self;
}
-(UIButton*) buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width{
    // Create a new button with the right dimensions
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
  
    switch (itemIndex) {
        case 0:
            [button setBackgroundImage:[UIImage imageNamed:@"ButtonMenu.png"] forState:UIControlStateNormal];
        
            break;
        case 1:
            [button setBackgroundImage:[UIImage imageNamed:@"ButtonCamera.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [button setBackgroundImage:[UIImage imageNamed:@"ButtonFriend.png"] forState:UIControlStateNormal];
          
            break;
        default:
            break;
    }

    
    return button;
}

- (void)touchDownAction:(UIButton*)button
{
   
    
    if ([delegate respondsToSelector:@selector(TBtouchDownAtItemAtIndex:)])
        [delegate TBtouchDownAtItemAtIndex:[buttons indexOfObject:button]];
  
}

- (void)touchUpInsideAction:(UIButton*)button
{
       
    if ([delegate respondsToSelector:@selector(TBtouchUpInsideItemAtIndex:)])
        [delegate TBtouchUpInsideItemAtIndex:[buttons indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton*)button
{
   
}







@end
