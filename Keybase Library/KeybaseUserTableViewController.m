//
//  ECEItemsViewController.m
//  Homepwner
//
//  Created by Kit Cischke -ADM on 2/12/15.
//  Copyright (c) 2015 Michigan Technological University. All rights reserved.
//

#import "KeybaseUserTableViewController.h"



@interface KeybaseUserTableViewController()<UIPopoverControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView* headerView;
@property (strong, nonatomic) UIPopoverController* imagePopover;
@end

@implementation KeybaseUserTableViewController
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        UINavigationItem* navItem = self.navigationItem;
        navItem.title = @"Keybase Messenger";
        
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        
        UIBarButtonItem* bbl = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(keybaseLogin:)];
        
        navItem.leftBarButtonItem = bbl;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ConversationStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*    UITableViewCell* currCell = [[UITableViewCell alloc]
     initWithStyle:UITableViewCellStyleDefault
     reuseIdentifier:@"UITableViewCell"]; */
    //    UITableViewCell* currCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    UserCell* currCell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    NSArray* items = [[ConversationStore sharedStore] allItems];
    
    Conversation* item = items[indexPath.row];
    
    //currCell.textLabel.text = [item description];
    currCell.nameLabel.text = item.itemName;
    //currCell.serialNumberLabel.text = item.serialNumber;
    //currCell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    //currCell.thumbnailView.image = item.thumbnail;
    
    __weak UserCell* weakCellReference = currCell;
    
    currCell.actionBlock = ^{
        NSLog(@"Going to show the image for %@", item);
        /*ECEItemCell* strongReference = weakCellReference;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            NSString* itemKey = item.itemKey;
            UIImage* itemImage = [[ECEImageStore sharedStore] imageForKey:itemKey];
            
            if (!itemImage)
            {
                return;
            }
            
            CGRect rect = [self.view convertRect: strongReference.thumbnailView.bounds fromView:strongReference.thumbnailView];
            ECEImageViewController* ivc = [[ECEImageViewController alloc] init];
            ivc.itemImage = itemImage;
            
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }*/
    };
    
    return currCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray* currentItems = [[ConversationStore sharedStore] allItems];
        Conversation* victim = currentItems[indexPath.row];
        
        [[ConversationStore sharedStore] removeItem:victim];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[ConversationStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UINib* nib = [UINib nibWithNibName:@"UserCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"UserCell"];
}

- (IBAction)addNewItem:(id)sender
{
    Conversation* newItem = [[ConversationStore sharedStore] createItem];
    
    //    NSInteger lastRow = [[[ECEItemStore sharedStore] allItems] indexOfObject:newItem];
    
    //    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    //    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    MessageViewController* detailViewController = [[MessageViewController alloc] initForNewItem:YES];
    
    detailViewController.currentItem = newItem;
    detailViewController.dismissBlock = ^{[self.tableView reloadData];};
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navController animated:YES completion:NULL];
}

- (IBAction)keybaseLogin:(id)sender
{
    [[Keybase KeybaseLib] keybase_getsalt:@"gamer239" completed:^(NSData* data){ NSDictionary* jsonData = [[Keybase KeybaseLib] convertJsonData:data]; NSLog(@"%@", jsonData);
    self.navigationItem.leftBarButtonItem.title = @"Logout";    
        [[Keybase KeybaseLib] keybase_login:@"gamer239" password:@"password" completed:^(NSData* data)
         {
             NSDictionary* jsonData = [[Keybase KeybaseLib] convertJsonData:data];
             //NSLog(@"%@", jsonData);
             //if ([[[Keybase KeybaseLib] keybase_status]  isEqual: @"0"])
             //{
             
             //}
             NSArray* status = jsonData[@"status"];
             NSLog(@"%@", status);
             
         }];
    
    }];
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageViewController* detailViewController = [[MessageViewController alloc] initForNewItem:NO];
    
    NSArray* items = [[ConversationStore sharedStore] allItems];
    Conversation* itemToPass = items[indexPath.row];
    
    detailViewController.currentItem = itemToPass;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}
@end
