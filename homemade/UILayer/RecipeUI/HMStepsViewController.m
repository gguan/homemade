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

static CGFloat PageControlHeight = 40.0f;

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
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:238.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
   
    
    //initialzie the pagedFlowView
    _pagedFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - PageControlHeight - 20.0f)];
     NSLog(@"pagedFlowView frame: %@", NSStringFromCGRect(_pagedFlowView.frame));
    _pagedFlowView.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagedFlowView.dataSource = self;
    _pagedFlowView.delegate = self;
    _pagedFlowView.minimumPageAlpha = 0.8;
    _pagedFlowView.minimumPageScale = 0.9;
    [self.view addSubview:self.pagedFlowView];
    
    //initialzie the pageControll
    if (DEVICE_VERSION_7) {
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - PageControlHeight - 64.0f, self.view.frame.size.width, PageControlHeight)];
    } else {
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - PageControlHeight - 44.0f, self.view.frame.size.width, PageControlHeight)];
    }
    
    _pageControll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_pageControll addTarget:self action:@selector(pageControlValueDidChange:) forControlEvents:UIControlEventAllTouchEvents];
    [_pageControll setCurrentPageIndicatorTintColor:[UIColor colorWithRed:118.0f/255.0f green:132.0f/255.0f blue:138.0f/255.0f alpha:1.0f]];
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
        y = -68.0f;
    }
    return CGSizeMake(PageFlowViewWidth, PageFlowViewHeight + y);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView {
    NSLog(@"Scrolled to page # %ld", (long)pageNumber);
}


#pragma mark -
#pragma mark PagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView{
    return [self.items count];
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    CGFloat y = 0;
    if ([[UIScreen mainScreen] bounds].size.height < 548) {
        y = -68;
    }
    HMStepsView *view = [[HMStepsView alloc] initWithFrame:CGRectMake(0, 0, PageFlowViewWidth, PageFlowViewHeight + y)];
    NSDictionary *step = [self.items objectAtIndex:index];
    NSString *description = [step objectForKey:kHMRecipeStepsContentKey];
    PFFile *stepPhoto = [step objectForKey:kHMRecipeStepsPhotoKey];
    
    view.stepDescriptionText = description;
    [view.stepDescrptionLabel setText:description];
    [view.stepNumberLabel setText:[NSString stringWithFormat:@"%li", index + 1]];
    [view setLayout];
    
    if (stepPhoto) {
        [view.stepImageView setFile:stepPhoto];
        [view.stepImageView setContentMode:UIViewContentModeScaleAspectFill];
        [view.stepImageView loadInBackground:^(UIImage *image, NSError *error) {
            [view setLayout];
        }];
    }
    
    
    
    return view;
}

- (void)pageControlValueDidChange:(id)sender {
    UIPageControl *pageControl = sender;
    [_pagedFlowView scrollToPage:pageControl.currentPage];
    
}
@end
