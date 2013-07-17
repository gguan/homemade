//
//  HMCommentViewController.m
//  homemade
//
//  Created by Guan Guan on 6/9/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TTTTimeIntervalFormatter.h"
#import "HMCommentCell.h"

#define CommentTextWidth 250
#define CommentTextFontSize 13.0f

@interface HMCommentViewController () {
    BOOL isSaving;
    BOOL isKeyboardShown;
    BOOL isAnimating;
}
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) HMCommentBar *commentTextField;
@property (nonatomic, strong) PFImageView *photoView;
@property (nonatomic, assign) UIBackgroundTaskIdentifier commentPostBackgroundTaskId;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@end

@implementation HMCommentViewController

- (id)initWithPFObject:(PFObject *)object andType:(NSString *)type {
    self = [super init];
    if (self) {
        if (!object) {
            return nil;
        }
        
        self.object = object;
        self.type = [NSString stringWithString:type];
        
        // The className to query on
        self.parseClassName = kHMCommentClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 20;
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        isSaving = NO;
        isKeyboardShown = NO;
        isAnimating = NO;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    // Add a left navBarItem
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonClicked)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    NSString *title;
    if ([self.type isEqualToString:kHMCommentTypeRecipe]) {
        title = [NSString stringWithFormat:@"%@", [self.object objectForKey:kHMRecipeTitleKey]];
    } else {
        PFUser *user = [self.object objectForKey:kHMDrinkPhotoUserKey];
        title = [NSString stringWithFormat:@"Drink by %@", [user objectForKey:kHMUserFirstNameKey]];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor],UITextAttributeTextColor,
                                                          [UIColor colorWithWhite:0.0f alpha:0.750f],
                                                          UITextAttributeTextShadowColor,
                                                          [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],
                                                          UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Helvetica-Oblique" size:15.0f], UITextAttributeFont,
                                                          nil]];
    [self.navigationItem setTitle:title];
    
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    // Custom initialization
    [self.tableView setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:238.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
//    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    // photo as table header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 326)];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 325, 320, 1)];
    [divider setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f]];
    [headerView addSubview:divider];
    self.photoView = [[PFImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, 310.0f)];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoView.layer.shadowRadius = kShadowRadius;
    self.photoView.layer.shadowOpacity = kShadowOpacity;
    self.photoView.layer.shadowOffset = kShadowOffset;
    self.photoView.layer.cornerRadius = 3.0f;
    self.photoView.layer.masksToBounds = YES;

    if ([self.type isEqualToString:kHMCommentTypeRecipe]) {
        [self.photoView setFile:[self.object objectForKey:kHMRecipePhotoKey]];
    } else {
        [self.photoView setFile:[self.object objectForKey:kHMDrinkPhotoPictureKey]];
    }
    [self.photoView loadInBackground];
    [headerView addSubview:self.photoView];
    self.tableView.tableHeaderView = headerView;
    
    // empty table footer
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 51.0f)];
    [self.tableView.tableFooterView setBackgroundColor:[UIColor whiteColor]];
    
    // comment tool bar
    CGRect commentFrame = [HMCommentBar rectForView:self.view.frame navBarHidden:self.navigationController.isNavigationBarHidden];
    if (!self.navigationController.isNavigationBarHidden) {
        commentFrame.origin.y += 44.0f;
    }
    self.commentTextField = [[HMCommentBar alloc] initWithFrame:commentFrame];
    
    self.commentTextField.commentField.delegate = self;
    self.commentTextField.textFieldDelegate = self;
    // make so the toolbar stays to the bottom and keep the width matching the device's screen width
    self.commentTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    [self.view addSubview:self.commentTextField];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    if (!self.object) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
    }
    
    [query whereKey:kHMCommentTypeKey equalTo:self.type];
    if ([self.type isEqualToString:kHMCommentTypeRecipe]) {
        [query whereKey:kHMCommentRecipeKey equalTo:self.object];
    } else {
        [query whereKey:kHMCommentPhotoKey equalTo:self.object];
    }

    [query includeKey:kHMCommentFromUserKey];
    [query orderByAscending:@"createdAt"];

    return query;
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [self.objects objectAtIndex:indexPath.row];
    }
    
    return nil;
}


- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"CommentCell";
    
    HMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HMCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *text = [object objectForKey:kHMCommentContentKey];
    PFUser *user = [object objectForKey:kHMCommentFromUserKey];
    
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            return;
        }
        [cell.avatar setFile:[user objectForKey:kHMUserProfilePicSmallKey]];
        [cell.avatar loadInBackground];
        
        NSString *content = [NSString stringWithFormat:@"%@ : %@", [user objectForKey:kHMUserFirstNameKey], text];
        CGFloat height = [HMUtility textHeight:content fontSize:CommentTextFontSize width:CommentTextWidth];
        [cell.commentLabel setFrame:CGRectMake( 55.0f, 7.0f, CommentTextWidth, height)];
        [cell.commentLabel setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange boldRange = [[mutableAttributedString string] rangeOfString:[user objectForKey:kHMUserFirstNameKey] options:NSLiteralSearch];
            // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
            UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:13.0f];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                CFRelease(font);
            }
            
            return mutableAttributedString;
        }];
        [cell.commentLabel sizeToFit];
    }];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    PFUser *user = [object objectForKey:kHMDrinkPhotoUserKey];
   
    NSString *content = [NSString stringWithFormat:@"%@: %@", [user objectForKey:kHMUserDisplayNameKey], [object objectForKey:kHMCommentContentKey]];
    CGFloat height = [HMUtility textHeight:content fontSize:CommentTextFontSize width:CommentTextWidth];
    if (height + 25.0f > 50.0f) {
        return height + 25.0f;
    } else {
        return 50.0f;
    }
}

- (void)keyboardWillShow:(NSNotification *)note {
    if (isKeyboardShown) {
        return;
    }
    isKeyboardShown = YES;
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double animationDuration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    isAnimating = YES;
    

    [UIView animateWithDuration:animationDuration animations:^{
        // When keyboard popup, the tableview size decrease!
        CGRect viewFrame = self.tableView.frame;
        viewFrame.origin.y -= keyboardFrameEnd.size.height;
        [self.tableView setFrame:viewFrame];
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height) animated:YES];
            }
        }
    }];
    isAnimating = NO;
}

- (void)keyboardWillHide:(NSNotification *)note {
    if (!isKeyboardShown) {
        return;
    }
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double animationDuration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:animationDuration animations:^{
        CGRect viewFrame = self.tableView.frame;
        viewFrame.origin.y += keyboardFrameEnd.size.height;
        [self.tableView setFrame:viewFrame];
    }];
    isKeyboardShown = NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doneButtonAction:textField];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.commentTextField.commentField resignFirstResponder];
}

// Need keep menu button fix position on the view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isAnimating) {
        return;
    }
    CGRect fixedFrame = [HMCommentBar rectForView:self.view.frame navBarHidden:self.navigationController.isNavigationBarHidden];
    fixedFrame.origin.y += scrollView.contentOffset.y;
    if (!self.navigationController.isNavigationBarHidden) {
        fixedFrame.origin.y += 44.0f;
    }
    [self.commentTextField setFrame:fixedFrame];
}


#pragma mark -
- (void)doneButtonAction:(id)sender {
    if (isSaving == YES) {
        return;
    }
    
    isSaving = YES;
    
    if (!self.object) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your comment" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    NSString *trimmedComment = [self.commentTextField.commentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length == 0) {
        return;
    }
    
    // create a comment object
    PFObject *comment = [PFObject objectWithClassName:kHMCommentClassKey];
    [comment setObject:trimmedComment forKey:kHMCommentContentKey];
    [comment setObject:[PFUser currentUser] forKey:kHMCommentFromUserKey];
    
    if ([self.type isEqualToString:kHMCommentTypeRecipe]) {
        [comment setObject:self.object forKey:kHMCommentRecipeKey];
        [comment setObject:kHMCommentTypeRecipe forKey:kHMCommentTypeKey];
    } else {
        [comment setObject:self.object forKey:kHMCommentPhotoKey];
        [comment setObject:kHMCommentTypePhoto forKey:kHMCommentTypeKey];
    }

    // photos are public, but may only be modified by the user who uploaded them
    PFACL *commentACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [commentACL setPublicReadAccess:YES];
    comment.ACL = commentACL;
    
    
    // save
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"comment saved");
            isSaving = NO;
            [self.commentTextField.commentField setText:@""];
            [self.commentTextField.commentField resignFirstResponder];
            
            if (self.objects.count > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.objects.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            [self loadObjects];
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height) animated:YES];
        } else {
            NSLog(@"Comment failed to save: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your comment" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
    }];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - HMCommentTextFieldDelegate

- (void) postButtonAction {
    [self doneButtonAction:self.commentTextField.postButton];
}

- (void)leftDrawerButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
