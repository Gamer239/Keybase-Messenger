//
//  MessageViewController.m
//  Keybase Library
//
//  Created by Zach Malinowski on 4/22/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController () <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchDisplayDelegate>

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messages = [[NSArray alloc] initWithObjects:
                     @"Hello, how are you.",
                     @"I'm great, how are you?",
                     @"I'm fine, thanks. Up for dinner tonight?",
                     @"Glad to hear. No sorry, I have to work.",
                     @"Oh that sucks. A pitty, well then - have a nice day.."
                     @"Thanks! You too. Cuu soon.",
                     nil];
    // Do any additional setup after loading the view from its nib.
    [self.localTableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.localTableView == tableView)
    {
        //NSLog(@"good");
        return [self.messages count];
    }
    else
    {
        //NSLog(@"um");
        return 4;
    }
    //return 3;
}

-(void)awakeFromNib {
    
    
    
    [super awakeFromNib];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UIBarButtonItem* bbl = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.leftBarButtonItem = bbl;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize messageSize = [PTSMessagingCell messageSize:[self.messages objectAtIndex:indexPath.row]];
    return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
}

-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
    
    if (indexPath.row % 2 == 0) {
        ccell.sent = YES;
        //ccell.avatarImageView.image = [UIImage imageNamed:@"person1"];
    } else {
        ccell.sent = NO;
        //ccell.avatarImageView.image = [UIImage imageNamed:@"person2"];
    }
    
    ccell.messageLabel.text = [_messages objectAtIndex:indexPath.row];
    //ccell.timeLabel.text = @"2012-08-29";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.localTableView)
    {
        //NSLog(@"tableView");
        static NSString* cellIdentifier = @"messagingCell";
        
        PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
        
    }
    else
    {
        NSLog(@"searchbar");
    }

    
    UITableViewCell* currCell = [[UITableViewCell alloc] init];
    return currCell;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Relinquish First Responder status -- but WHY?
    [self.view endEditing:YES];
    
    Conversation* item = self.currentItem;
    //item.itemName = self.nameField.text;
    //item.serialNumber = self.serialField.text;
    //item.valueInDollars = [self.valueField.text intValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        if (isNew)
        {
            UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    
    return self;
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
    if (self.searchBar.text.length > 0)
    {
        self.currentItem.itemName = self.searchBar.text;
    }
}

- (void)cancel:(id)sender
{
    //[[ECEImageStore sharedStore] deleteImageForKey:self.currentItem.itemKey];
    [[ConversationStore sharedStore] removeItem:self.currentItem];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
