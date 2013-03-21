//
//  HMMD5Hash.m
//  homemade
//
//  Created by Sai Luo on 3/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMMD5Hash.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HMMD5Hash

+ (NSString *) getMD5HashFromString:(NSString*)str {
	const char *concat_str = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, strlen(concat_str), result);
	
	NSMutableString *hash = [NSMutableString string];
	
	for (int i = 0; i < 16; i++)
		[hash appendFormat:@"%02X", result[i]];
	
	return hash;
}

+ (NSString *)getMD5FromData:(NSData *)data
{
    void *cData = malloc([data length]);
    
    if (cData==NULL) {
        return nil;
    }
    
    unsigned char resultCString[16];
    [data getBytes:cData length:[data length]];
    
    CC_MD5(cData, [data length], resultCString);
    free(cData);
    
    NSMutableString *hash = [NSMutableString string];
	
	for (int i = 0; i < 16; i++)
		[hash appendFormat:@"%02X", resultCString[i]];
	
	return hash;
    
}

+ (BOOL)isDataOK:(NSData*)data with:(NSString*)correctMD5 {
    
    NSString* MD5OfDataString = [self getMD5FromData:data];
    
    NSLog(@"MD5OfData = %@",MD5OfDataString);
    NSLog(@"CorrectMD5 = %@",correctMD5);
    
    if ([MD5OfDataString caseInsensitiveCompare:correctMD5]==NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *) getMD5HashFromTimeStamp {
    NSString* timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    //NSLog(@"current time stamp: %@", timeStamp);
    return [self getMD5HashFromString:timeStamp];
}


@end
