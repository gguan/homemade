//
//  HMStepsViewController.m
//  homemade
//
//  Created by Xiaodi Xing on 4/30/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMStepsViewController.h"
#import "PagedFlowView.h"
#import "HMStepsView.h"
#import <QuartzCore/QuartzCore.h>


#define PageControlHeight 40

@interface HMStepsViewController ()<PagedFlowViewDelegate,PagedFlowViewDataSource>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) PagedFlowView *pagedFlowView;
@property (nonatomic, strong) UIPageControl *pageControll;

@end


@implementation HMStepsViewController

- (id)initWithRecipe:(PFObject*)recipeObject{
    self = [super init];
    if (self) {
        NSArray *steps= [recipeObject objectForKey:kHMRecipeStepsKey];
       	self.items = [NSMutableArray arrayWithArray:steps];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height)];
    NSLog(@"Step view frame: %@", NSStringFromCGRect(self.view.frame));
    
    CGFloat y = 0.0f;
    if (DEVICE_VERSION_7) {
        y = 64.0f;
    }
    //initialzie the pagedFlowView
    _pagedFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0 + y, self.view.frame.size.width, self.view.frame.size.height - PageControlHeight - 10.0f - y)];
    _pagedFlowView.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagedFlowView.dataSource = self;
    _pagedFlowView.delegate = self;
    _pagedFlowView.minimumPageAlpha = 0.8;
    _pagedFlowView.minimumPageScale = 0.9;
    [self.view addSubview:self.pagedFlowView];
    
    //initialzie the pageControll

    y = -44.0f;
    if (DEVICE_VERSION_7) {
        y = 20.0f;
    }
    _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - PageControlHeight + y, self.view.frame.size.width, PageControlHeight)];
    _pageControll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_pageControll addTarget:self action:@selector(pageControlValueDidChange:) forControlEvents:UIControlEventAllTouchEvents];
    [_pageControll setCurrentPageIndicatorTintColor:[UIColor purpleColor]];
    [_pageControll setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.pageControll];
    _pagedFlowView.pageControl = _pageControll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;{
    CGFloat y = 0.0f;
    if ([[UIScreen mainScreen] bounds].size.height < 548.0f) {
        y = -30.0f;
    }
    return CGSizeMake(PageFlowViewWidth, PageFlowViewHeight + y);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView {
    NSLog(@"Scrolled to page # %d", pageNumber);
}


#pragma mark -
#pragma mark PagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView{
    return [self.items count];
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    HMStepsView *view = [[HMStepsView alloc] initWithFrame:CGRectMake(0, 0, PageFlowViewWidth, PageFlowViewHeight)];
    NSDictionary *step = [self.items objectAtIndex:index];
    NSString *description = [step objectForKey:kHMRecipeStepsContentKey];
    PFFile *stepPhoto = [step objectForKey:kHMRecipeStepsPhotoKey];
    
    view.stepDescriptionText = description;
    [view.stepDescrptionLabel setText:description];
    [view.stepNumberLabel setText:[NSString stringWithFormat:@"%i", index + 1]];
    [view setLayout];
    
    if (stepPhoto) {
        [view.stepImageView setFile:stepPhoto];
        [view.stepImageView setContentMode:UIViewContentModeScaleAspectFill];
        [view.stepImageView loadInBackground];
    }
    
    return view;
}

- (void)pageControlValueDidChange:(id)sender {
    UIPageControl *pageControl = sender;
    [_pagedFlowView scrollToPage:pageControl.currentPage];
    
}
@end
