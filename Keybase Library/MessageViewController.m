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
    // Do any additional setup after loading the view from its nib.
    [self.messages reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UIBarButtonItem* bbl = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.leftBarButtonItem = bbl;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.messages)
    {
        NSLog(@"tableView");
    }
    else
    {
        NSLog(@"searchbar");
    }
    /*    UITableViewCell* currCell = [[UITableViewCell alloc]
     initWithStyle:UITableViewCellStyleDefault
     reuseIdentifier:@"UITableViewCell"]; */
    //    UITableViewCell* currCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    //UserCell* currCell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    UITableViewCell* currCell = [[UITableViewCell alloc] init];
    
    //NSArray* items = [[ConversationStore sharedStore] allItems];
    
    //Conversation* item = items[indexPath.row];
    
    //currCell.textLabel.text = [item description];
    //currCell.nameLabel.text = item.itemName;
    //currCell.serialNumberLabel.text = item.serialNumber;
    //currCell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    //currCell.thumbnailView.image = item.thumbnail;
    
    //__weak UserCell* weakCellReference = currCell;
    

    
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
