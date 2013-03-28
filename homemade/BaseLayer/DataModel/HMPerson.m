//
//  HMPerson.m
//  homemade
//
//  Created by Guan Guan on 3/28/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMPerson.h"

@implementation HMPerson

- (id)initForTest {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.sid = @"1";
    self.firstName = @"Guan";
    self.lastName = @"Guan";
    self.displayName = @"Guan Guan";
    self.bio = @"xxxxxxxxxxxxxxx";
    self.avatar = @"http://www.gravatar.com/avatar/08526bee8fbe17f6447d0f2f0cca807c.png";
    
    return self;
}

@end
