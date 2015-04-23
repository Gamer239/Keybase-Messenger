//
//  Keybase.m
//  Keybase Library
//
//  Created by Zach Malinowski on 3/31/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import "Keybase.h"

@interface Keybase()
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, copy) NSString* csrf_token;
@property (nonatomic, copy) NSString* login_session;
@property (nonatomic, copy) NSString* salt;
@property (nonatomic) NSDictionary* user;
@end

@implementation Keybase

+ (instancetype) KeybaseLib
{
    static Keybase* KeybaseLib;
    if (!KeybaseLib)
    {
        KeybaseLib = [[Keybase alloc] initPrivate];
    }
    return KeybaseLib;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        _keybase_base_url = @"https://keybase.io/_/api/1.0/";
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    }
    return self;
}

- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[Keybase KeybaseLib]"];
    
    return nil;
    
}

- (BOOL)keybase_lookup:(NSString *)usernames fields:(NSString *)fields completed:(void (^)(NSData* data))completed
{
    NSString* urlString = [NSString stringWithFormat:@"%@user/lookup.json?usernames=%@&fields=%@",_keybase_base_url, usernames, fields];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [self fetchFeed:request completed:completed];
    return YES;
}

- (BOOL)keybase_key:(NSString*)user completed:(void (^)(NSData *))completed
{
    NSString* urlString = [NSString stringWithFormat:@"https://keybase.io/%@/key.asc", user];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [self fetchFeed:request completed:completed];
    return YES;
}

- (BOOL)keybase_autocomplete:(NSString *)q completed:(void (^)(NSData *))completed
{
    if ([self.csrf_token length] <= 0)
    {
        return NO;
    }
    NSString* urlString = [NSString stringWithFormat:@"%@user/autocomplete.json",_keybase_base_url];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString* myRequestString = [NSString stringWithFormat:@"csrf_token=%@&q=%@", self.csrf_token, q];
    NSLog(@"%@", myRequestString);
    NSData* requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
    [request setHTTPBody:requestData];
    [self fetchFeed:request completed:completed];
    return YES;
}

- (BOOL)keybase_login:(NSString*)email_or_username password:(NSString*)password completed:(void (^)(NSData *))completed
{
    if ([self.csrf_token length] <= 0 || [self.login_session length] <= 0 || [self.salt length] <= 0)
    {
        return NO;
    }
    
    //step 1
    uint8_t *passphrase = (uint8_t *)[password dataUsingEncoding:NSASCIIStringEncoding].bytes;
    uint8_t *salt = (uint8_t *)self.salt.decodeFromHexidecimal.bytes;
    uint8_t buffer[224];
    
    crypto_scrypt(passphrase, 20, salt, 24, pow(2, 15), 8, 1, buffer, 224);
    uint8_t *pwh = buffer + 192;
    
    //step2
    NSData *decodedData = [NSData dataWithBase64EncodedString:self.login_session];
    uint8_t *decodedCString = (uint8_t *)decodedData.bytes;
    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, pwh, 224 - 192, decodedCString, 108, cHMAC);
    
    //get result string
    NSString *hmac_pwh = hmac(CC_SHA512_DIGEST_LENGTH, cHMAC);
    
    NSLog(@"hmac_pwh %@", hmac_pwh);
    
    
    NSString* urlString = [NSString stringWithFormat:@"%@login.json",_keybase_base_url];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString* myRequestString = [NSString stringWithFormat:@"email_or_username=%@&hmac_pwh=%@&login_session=%@", email_or_username, hmac_pwh, self.login_session];
    NSData* requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
    [request setHTTPBody:requestData];
    [self fetchFeed:request completed:completed];
    return YES;
}

- (BOOL)keybase_getsalt:(NSString*)email_or_username completed:(void (^)(NSData *))completed
{
    NSString* urlString = [NSString stringWithFormat:@"%@getsalt.json",_keybase_base_url];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString* myRequestString = [NSString stringWithFormat:@"email_or_username=%@", email_or_username];
    NSData* requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
    [request setHTTPBody:requestData];
    [self fetchFeed:request completed:completed];
    return YES;
}

- (void)fetchFeed:(NSURLRequest *)request completed:(void (^)(NSData* data))completed
{
    NSURLSessionDataTask* dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([NSJSONSerialization JSONObjectWithData:data options:0 error:nil] != nil)
        {
            NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.csrf_token = [jsonData objectForKey:@"csrf_token"];
            if ([jsonData objectForKey:@"salt"] != nil)
            {
                self.salt = [jsonData objectForKey:@"salt"];
            }
            if ([jsonData objectForKey:@"login_session"] != nil)
            {
                self.login_session = [jsonData objectForKey:@"login_session"];
            }
            //if ([jsonData objectForKey:@"status"]  != nil && [jsonData[@"status"] //objectForKey:@"code"] != nil)
            //{
              //  _keybase_status = [jsonData[@"status"] objectForKey:@"code"];
            //}
            //NSLog(@" fetch feed %@", jsonData);
        }
        dispatch_async(dispatch_get_main_queue(), ^{completed(data);});
    }];
    
    [dataTask resume];
}

- (NSDictionary*)convertJsonData:(NSData*)data
{
    NSDictionary* dictionary = [[NSDictionary alloc] init];
    if ([NSJSONSerialization JSONObjectWithData:data options:0 error:nil] != nil)
    {
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    return dictionary;
}

- (NSString*)convertStringData:(NSData*)data
{
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

@end
