//
//  ConversationStore.m
//  Keybase Library
//
//  Created by Zach Malinowski on 4/17/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import "ConversationStore.h"

@interface ConversationStore()

@property (nonatomic) NSMutableArray* privateItems;

@end

@implementation ConversationStore

+ (instancetype)sharedStore
{
    static ConversationStore* sharedStore;
    
    if (!sharedStore)
    {
        sharedStore = [[ConversationStore alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self)
    {
        //NSString* path = [self itemArchivePath];
        //_privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_privateItems)
        {
            _privateItems = [NSMutableArray array];
        }
    }
    return self;
}

- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[ConversationStore sharedStore]"];
    
    return nil;
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (void)removeItem:(Conversation *)item
{
    
    //[[ConversationStore sharedStore] deleteImageForKey:item.itemKey];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex)
    {
        return;
    }
    
    Conversation* temp = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:temp atIndex:toIndex];
}

- (NSString *)itemArchivePath
{
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (Conversation *)createItem
{
    Conversation* randomItem = [Conversation newItem];
    //randomItem.itemName = @"Test";
    [self.privateItems addObject:randomItem];
    
    return randomItem;
}

-(BOOL)saveChanges
{
    NSString* path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

@end
