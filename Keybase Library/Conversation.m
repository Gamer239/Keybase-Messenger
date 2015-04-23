//
//  Conversation.m
//  Keybase Library
//
//  Created by Zach Malinowski on 4/17/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import "Conversation.h"

@implementation Conversation

+ (instancetype)newItem
{
    NSArray* adjectives = @[@"Kit", @"Ryan", @"Zach", @"Dylan", @"AJ"];
    NSArray* nouns = @[@"the Slayer", @"the Slow", @"the Fast", @"the Latte"];
    
    NSInteger adjectiveIndex = arc4random() % adjectives.count;
    NSInteger nounIndex = arc4random() % nouns.count;
    
    NSString* randomItemName = [NSString stringWithFormat:@"%@ %@",
                                adjectives[adjectiveIndex],
                                nouns[nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString* randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", '0'+ arc4random() % 10, 'A' + arc4random() % 26, '0' + arc4random() % 10, 'A' + arc4random() % 26, '0' + arc4random() % 10];
    
    Conversation* newItem = [[self alloc] initWithItemName:randomItemName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    
    return newItem;
}

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)serial
{
    // First, call the superclass's init
    self = [super init];
    
    if (self)
    {
        _itemName = name;
        //_serialNumber = serial;
        //_valueInDollars = value;
        //NSDate* now = [NSDate date];
        //_dateCreated = now;
        
        NSUUID* uuid = [[NSUUID alloc] init];
        _itemKey = [uuid UUIDString];
        self.messages = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

- (instancetype)init
{
    return [self initWithItemName:@"Thing"
                   valueInDollars:0
                     serialNumber:@""];
}

@end
