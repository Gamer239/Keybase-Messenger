//
//  ConversationStore.h
//  Keybase Library
//
//  Created by Zach Malinowski on 4/17/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"

@interface ConversationStore : NSObject

@property (nonatomic, readonly, copy) NSArray* allItems;

+ (instancetype)sharedStore;
- (Conversation *)createItem;
- (void) removeItem:(Conversation *) item;
- (void) moveItemAtIndex:(NSUInteger)fromIndex
                 toIndex:(NSUInteger)toIndex;

@end
