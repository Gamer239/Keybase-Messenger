//
//  Keybase.h
//  Keybase Library
//
//  Created by Zach Malinowski on 3/31/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import "crypto/crypto_scrypt.h"
#import "CryptoHelper/HexDecoder.h"
#import "CryptoHelper/Base64/Base64.h"

@interface Keybase : NSObject

@property (nonatomic, readonly) NSString* keybase_base_url;
@property (nonatomic, readonly) NSURL* keybase_request_url;

+(instancetype) KeybaseLib;

- (BOOL)keybase_lookup:(NSString *)usernames fields:(NSString *)fields completed:(void (^)(NSData* data))completed;
- (BOOL)keybase_key:(NSString*)user completed:(void (^)(NSData* data))completed;
- (BOOL)keybase_autocomplete:(NSString *)q completed:(void (^)(NSData* data))completed;
- (BOOL)keybase_login:(NSString*)email_or_username password:(NSString*)password completed:(void (^)(NSData *))completed;
- (BOOL)keybase_getsalt:(NSString*)email_or_username completed:(void (^)(NSData* data))completed;
- (void)fetchFeed:(NSURLRequest *)request completed:(void (^)(NSData* data))completed;
- (NSDictionary*)convertJsonData:(NSData*)data;
- (NSString*)convertStringData:(NSData*)data;


@end
