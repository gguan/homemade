//
//  HMCommonUIUtility.m
//  homemade
//
//  Created by Y.CORP.YAHOO.COM\gguan on 5/3/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCommonUIUtility.h"

@implementation HMCommonUIUtility

+ (void)showAlert:(NSString *) alertMsg {
    if (![alertMsg isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Result"
                                    message:alertMsg
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

+ (NSString *) checkPostId:(NSDictionary *)results {
    NSString *message = @"Posted successfully.";
    // Share dialog
    NSString *postId = results[@"postId"];
    if (postId) {
        message = [NSString stringWithFormat:@"Posted story, id: %@", postId];
    }
    return message;
}

- (NSString *)checkErrorMessage:(NSError *)error {
    NSString *errorMessage = @"";
    if (error.fberrorUserMessage) {
        errorMessage = error.fberrorUserMessage;
    } else {
        errorMessage = @"Operation failed due to a connection problem, retry later.";
    }
    return errorMessage;
}

@end
