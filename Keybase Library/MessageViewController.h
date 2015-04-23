//
//  MessageViewController.h
//  Keybase Library
//
//  Created by Zach Malinowski on 4/22/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"
#import "ConversationStore.h"
#import "UserCell.h"

@interface MessageViewController : UIViewController
- (instancetype)initForNewItem:(BOOL)isNew;
@property (nonatomic, strong) Conversation* currentItem;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic) IBOutlet UITableView* messages;

@end
