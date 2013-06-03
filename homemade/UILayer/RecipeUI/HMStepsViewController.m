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

#define TABBARHEIGHT 44
#define TopImageViewHeight 88
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, TopImageViewHeight + TABBARHEIGHT, self.view.frame.size.width, self.view.frame.size.height - TABBARHEIGHT -TopImageViewHeight)];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    [self.view setBackgroundColor:[UIColor colorWithRed:162.0/255.0 green:73.0/255.0 blue:43.0/255.0 alpha:1.0]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //initialzie the pagedFlowView
    _pagedFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _pagedFlowView.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagedFlowView.dataSource = self;
    _pagedFlowView.delegate = self;
   
    _pagedFlowView.minimumPageAlpha = 0.3;
    _pagedFlowView.minimumPageScale = 0.75;
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
    return CGSizeMake(220, 340);
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
    HMStepsView *view = (HMStepsView*)[flowView dequeueReusableCell];
    if (!view) {
        view = [[HMStepsView alloc] initWithFrame:CGRectMake(0, 0, 220, 340)];
      //  view.autoresizesSubviews = YES;
      //  view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
       // [view setBackgroundColor:[UIColor whiteColor]];
        NSArray *temp = [self.items objectAtIndex:index];
        NSString *description = [temp objectAtIndex:0];
        
        [view.stepDescrptionLabel setText:description];
        UIGraphicsBeginImageContextWithOptions(view.stepDescrptionLabel.bounds.size, NO, self.view.window.screen.scale);
        [view.stepDescrptionLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
        CGImageRef viewImage = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
        UIGraphicsEndImageContext();
        UIImage *snapshot = [UIImage imageWithCGImage:viewImage];
        [view.stepDescriptionLabelSnapShot setImage:snapshot];
        
        
        [view.stepImageView setImage:[UIImage imageNamed:@"pic_4.jpg"]];
        
        [view.stepImageView setContentMode:UIViewContentModeScaleToFill];
        //download image in background
        if([temp count]>1){
            view.stepImageView.file = [temp objectAtIndex:1];
            if([view.stepImageView.file isDataAvailable]){
                NSData * data = [view.stepImageView.file getData];
                [view.stepImageView setImage:[UIImage imageWithData:data]];
                
            }
            else{
                [view.stepImageView loadInBackground:^(UIImage *image,NSError *error){
                    if (!error) {
                        [view.stepImageView setImage:image];
                    }
                    else
                        NSLog(@"error:%@",[error userInfo]);
                }];
            }
        }
        
        
        
        
    }
  
    return view;
}

- (void)pageControlValueDidChange:(id)sender {
    UIPageControl *pageControl = sender;
    [_pagedFlowView scrollToPage:pageControl.currentPage];
   
}
@end
