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


#define PageControlHeight 30

@interface HMStepsViewController ()<PagedFlowViewDelegate,PagedFlowViewDataSource>

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) PagedFlowView *pagedFlowView;
@property (nonatomic, retain) UIPageControl *pageControll;

@end

@implementation HMStepsViewController

@synthesize items = _items;
@synthesize pagedFlowView = _pagedFlowView;
@synthesize pageControll = _pageControll;

- (id)initWithRecipe:(PFObject*)recipeObject{
    self = [super init];
    if (self) {
        
        NSArray *result = [recipeObject objectForKey:@"steps"];
       	self.items = [NSMutableArray arrayWithArray:result];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, TabBarHeight, self.view.frame.size.width, self.view.frame.size.height - TabBarHeight)];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //initialzie the pagedFlowView
    _pagedFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _pagedFlowView.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagedFlowView.dataSource = self;
    _pagedFlowView.delegate = self;
    
    _pagedFlowView.minimumPageAlpha = 0.8;
    _pagedFlowView.minimumPageScale = 0.8;
    [self.view addSubview:self.pagedFlowView];
    
    //initialzie the pageControll
    _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - PageControlHeight , self.view.frame.size.width, PageControlHeight)];
    _pageControll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_pageControll addTarget:self action:@selector(pageControlValueDidChange:) forControlEvents:UIControlEventAllTouchEvents];
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
    return CGSizeMake(PageFlowViewWidth, PageFlowViewHeight);
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
    
    NSArray *step = [self.items objectAtIndex:index];
    NSString *description = [step objectAtIndex:0];
    
    view.stepDescriptionText = [description copy];
    [view.stepDescrptionLabel setText:description];
    [view.stepNumberLabel setText:[NSString stringWithFormat:@"%i", index + 1]];
    [view setLayout];
    
    if ([step count] > 1) {
        [view.stepImageView setFile:[step objectAtIndex:1]];
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
