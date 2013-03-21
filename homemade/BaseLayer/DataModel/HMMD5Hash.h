//
//  HMMD5Hash.h
//  homemade
//
//  Created by Sai Luo on 3/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMMD5Hash : NSObject

+ (NSString *) getMD5HashFromString:(NSString*)str;
+ (NSString *) getMD5FromData:(NSData *)data;
+ (NSString *) getMD5HashFromTimeStamp;
+ (BOOL) isDataOK:(NSData*)data with:(NSString*)correctMD5;

@end
