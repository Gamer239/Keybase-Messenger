//
//  HexDecoder.h
//  Keybase Library
//
//  Created by Zach Malinowski on 4/14/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HexDecoder : NSObject
NSString* hmac(unsigned int size, unsigned char cHMAC[size]);
@end

@interface NSString (NSStringExtensions)
- (NSData *) decodeFromHexidecimal;
@end