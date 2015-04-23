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
    
    [[Keybase KeybaseLib] keybase_getsalt:@"gamer239" completed:^(NSData* data){
    }];
    
    self.messages = self.currentItem.messages;
    self.results = [[NSMutableArray alloc] initWithCapacity:10];
    self.searchBar.text = self.currentItem.itemName;
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
        //[tableView insertRowsAtIndexPaths:self.results withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"%lu", (unsigned long)[self.results count]);
        return [self.results count];
    }
    //return 3;
}

-(IBAction)sendMessage:(id)sender
{
    [self.currentItem.messages insertObject:self.textBox.text atIndex:self.currentItem.messages.count];
    self.textBox.text = @"";
    
    NSArray* adjectives = @[@"This is a very quip remark.", @"I love your hair cut.", @"You're so funny. Why didn't I think of that?", @"You look like a potato.", @"Let's play hide and go seek!"];
    NSInteger adjectiveIndex = arc4random() % adjectives.count;
    NSString* randomItemName = [NSString stringWithFormat:@"%@",
                                adjectives[adjectiveIndex]];
    [self.currentItem.messages insertObject:randomItemName atIndex:self.currentItem.messages.count];
    
    
    [self.localTableView reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UIBarButtonItem* bbl = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.leftBarButtonItem = bbl;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.localTableView)
    {
        self.currentItem.itemName = [self.results objectAtIndex:indexPath.row];
        
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    self.currentItem.itemName = searchText;
    
    [[Keybase KeybaseLib] keybase_autocomplete:searchText completed:^(NSData* data){ NSDictionary* jsonData = [[Keybase KeybaseLib] convertJsonData:data]; NSLog(@"%@", jsonData);
        [self.results removeAllObjects];
        NSArray* results2 = [jsonData objectForKey:@"completions"];
        NSLog(@"%@", results2);
        for( int i = 0; i < results2.count; i++)
        {
            NSString* components = [[[[results2 objectAtIndex:i] objectForKey:@"components"] objectForKey:@"username"] objectForKey:@"val"];
            NSLog(@"username %@", components);
            [self.results insertObject:components atIndex:self.results.count ];
            
            //[self.results addObject:components];
            
            //searchBar.delegate = self;
            
            //components = [[[[results objectAtIndex:i] objectForKey:@"components"] objectForKey:@"full_name"] objectForKey:@"val"];
            //NSLog(@"full name %@", components);
            
        }
        //self.label.text = [[[[results objectAtIndex:0] objectForKey:@"components"] objectForKey:@"username"] objectForKey:@"val"];
        
    }];
    NSString* addthis = @"addThis";
    //[self.results insertObject:addthis atIndex:self.results.count];
    
    //self.results = [[NSMutableArray alloc] initWithObjects:searchText, nil];
    //self.searchController.searchResultsDataSource
    //[self.results insertObject:searchText atIndex:0];
    //[self.searchController.searchContentsController.searchDisplayController.searchResultsDataSource
    //[self.searchController.searchResultsTableView reloadData];
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView;
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    footer.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:footer];
}

-(IBAction)textEdit:(id)sender
{
    self.currentItem.itemName = self.searchBar.text;
    //[self.results removeAllObjects];
    [[Keybase KeybaseLib] keybase_autocomplete:self.searchBar.text
            completed:^(NSData* data){ NSDictionary* jsonData = [[Keybase KeybaseLib] convertJsonData:data]; NSLog(@"%@", jsonData);
        
        NSArray* results = [jsonData objectForKey:@"completions"];
        NSLog(@"%@", results);
        for( int i = 0; i < results.count; i++)
        {
            NSArray* components = [[[[results objectAtIndex:i] objectForKey:@"components"] objectForKey:@"username"] objectForKey:@"val"];
            NSLog(@"username %@", components);
            
            //searchBar.delegate = self;
            
            //components = [[[[results objectAtIndex:i] objectForKey:@"components"] objectForKey:@"full_name"] objectForKey:@"val"];
            //NSLog(@"full name %@", components);
            
        }
        self.label.text = [[[[results objectAtIndex:0] objectForKey:@"components"] objectForKey:@"username"] objectForKey:@"val"];
        
    }];
    //self.results = [[NSMutableArray alloc] initWithObjects:searchText, nil];
    //self.searchController.searchResultsDataSource
    //[self.results insertObject:searchText atIndex:0];
    //[self.searchController.searchContentsController.searchDisplayController.searchResultsDataSource
    //[self.searchController.searchResultsTableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView != self.localTableView)
    {
        return 40.0f;
    }
    CGSize messageSize = [PTSMessagingCell messageSize:[self.messages objectAtIndex:indexPath.row]];
    return messageSize.height  + 40.0f;
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
    currCell.text = [self.results objectAtIndex:indexPath.row];
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
        //self.currentItem.itemName = self.searchBar.text;
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
