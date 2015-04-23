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
#import "PTSMessagingCell.h"

@interface MessageViewController : UIViewController
{
    UITableView* localTableView;
    
    NSArray* messages;
}
- (instancetype)initForNewItem:(BOOL)isNew;
@property (nonatomic, strong) Conversation* currentItem;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic) IBOutlet UITableView* localTableView;
@property (nonatomic) IBOutlet UISearchBar* searchBar;

@property (nonatomic) NSArray* messages;

@end
