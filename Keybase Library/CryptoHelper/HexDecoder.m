//
//  HexDecoder.m
//  Keybase Library
//
//  Created by Zach Malinowski on 4/14/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import "HexDecoder.h"
#import <stdio.h>
#import <stdlib.h>
#import <string.h>

@implementation HexDecoder

unsigned char strToChar (char a, char b)
{
    char encoder[3] = {'\0','\0','\0'};
    encoder[0] = a;
    encoder[1] = b;
    return (char) strtol(encoder,NULL,16);
}

NSString* hmac(unsigned int size, unsigned char cHMAC[size])
{
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < size; i++)
    {
        [result appendFormat:@"%02hhx", cHMAC[i]];
    }
    
    return result;
}
@end

@implementation NSString (NSStringExtensions)

- (NSData *) decodeFromHexidecimal;
{
    const char * bytes = [self cStringUsingEncoding: NSUTF8StringEncoding];
    NSUInteger length = strlen(bytes);
    unsigned char * r = (unsigned char *) malloc(length / 2 + 1);
    unsigned char * index = r;
    
    while ((*bytes) && (*(bytes +1))) {
        *index = strToChar(*bytes, *(bytes +1));
        index++;
        bytes+=2;
    }
    *index = '\0';
    
    NSData * result = [NSData dataWithBytes: r length: length / 2];
    free(r);
    
    return result;
}
@end