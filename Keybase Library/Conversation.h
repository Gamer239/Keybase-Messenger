//
//  Conversation.h
//  Keybase Library
//
//  Created by Zach Malinowski on 4/17/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conversation : NSObject

@property (nonatomic, copy) NSString* itemKey;
@property (nonatomic, copy) NSString* itemName;
@property (nonatomic) NSMutableArray* messages;

- (instancetype)initWithItemName:(NSString*)name
                  valueInDollars:(int)value
                    serialNumber:(NSString*) serial;

- (instancetype)initWithItemName:(NSString*)name;
+ (instancetype)newItem;
@end
