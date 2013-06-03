//
//  CustomTakingPictureToolBar.h
//  ECSlidingViewController
//
//  Created by Xiaodi Xing on 10/31/12.
//
//

#import <UIKit/UIKit.h>
@class CustomTakingPictureToolBar;
@protocol CustomTakingPictureToolBarDelegate <NSObject>


@optional
- (void) TBtouchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void) TBtouchDownAtItemAtIndex:(NSUInteger)itemIndex;
@end


@interface CustomTakingPictureToolBar : UIView
{
    NSObject <CustomTakingPictureToolBarDelegate> *delegate;
    NSMutableArray* buttons;
}
@property (retain,nonatomic) NSMutableArray *buttons;

- (id) initWithItemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <CustomTakingPictureToolBarDelegate>*)customTabBarDelegate;
@end
