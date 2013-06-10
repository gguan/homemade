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
#import "HMCommentTextField.h"

@interface HMCommentViewController () {
    BOOL isSaving;
}
@property (nonatomic, strong) HMCommentTextField *commentTextField;
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
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    // Custom initialization
    [self.tableView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    
    // photo as table header
    self.photoView = [[PFImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
    if ([self.type isEqualToString:kHMCommentTypeRecipe]) {
        [self.photoView setFile:[self.object objectForKey:kHMRecipePhotoKey]];
    } else {
        [self.photoView setFile:[self.object objectForKey:kHMDrinkPhotoPictureKey]];
    }
    [self.photoView loadInBackground];
    self.tableView.tableHeaderView = self.photoView;
    
    // empty table footer
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    self.commentTextField = [[HMCommentTextField alloc] initWithFrame:[HMCommentTextField rectForView]];
    self.commentTextField.commentField.delegate = self;
    [self.view addSubview:self.commentTextField];
    [self.commentTextField.postButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
    NSLog(@"Height: %f Table: %f Content:%f", [UIScreen mainScreen].bounds.size.height, self.tableView.frame.size.height, self.tableView.contentSize.height);
    


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
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    
    }
    
    [cell.textLabel setText:[object objectForKey:kHMCommentContentKey]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    NSString *content = [object objectForKey:kHMDrinkPhotoNoteKey];
    return 50;
}

- (void)keyboardWillShow:(NSNotification *)note {
    
    NSLog(@"Display keyboard");
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrameEnd.size.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
      
    [UIView animateWithDuration:0.200f animations:^{
        CGRect textFrame = [HMCommentTextField rectForView];
        NSLog(@"Height: %f Table: %f Content:%f", textFrame.origin.y, self.tableView.bounds.size.height, self.tableView.contentSize.height);
        NSLog(@"Frame %f", keyboardFrameEnd.size.height);
        textFrame.origin.y -= keyboardFrameEnd.size.height;
        [self.commentTextField setFrame:textFrame];
        
    }];
    NSLog(@"Height: %f Content: %f", self.tableView.bounds.size.height, [UIScreen mainScreen].bounds.size.height);

}

- (void)keyboardWillHide:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.tableView.bounds.size;
    scrollViewContentSize.height -= keyboardFrameEnd.size.height;
    [UIView animateWithDuration:0.200f animations:^{
        [self.commentTextField setFrame:[HMCommentTextField rectForView]];
        [self.tableView setContentSize:scrollViewContentSize];
    }];
    NSLog(@"Height: %f Table: %f Content:%f", self.view.bounds.size.height, self.tableView.bounds.size.height, self.tableView.contentSize.height);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
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
    CGRect fixedFrame = [HMCommentTextField rectForView];
    fixedFrame.origin.y += scrollView.contentOffset.y;
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
            
        } else {
            NSLog(@"Comment failed to save: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your comment" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
    }];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
