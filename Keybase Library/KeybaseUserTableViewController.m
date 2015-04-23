//
//  KeybaseUserTableViewController.m
//  Keybase Library
//
//  Created by Zach Malinowski on 4/16/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import "KeybaseUserTableViewController.h"

@interface KeybaseUserTableViewController ()

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
        
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUInteger value = [[[ConversationStore sharedStore] allItems] count];
    NSLog(@"%lu", (unsigned long)value);
    [self.tableView reloadData];
    
    NSLog(@"[self.assignments count] = %lu", [self.tableView numberOfRowsInSection:0]);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;
    
    UINib* nib = [UINib nibWithNibName:@"UserCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"UserCell"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ConversationStore sharedStore] allItems] count];
}

- (IBAction)addNewItem:(id)sender
{
    Conversation* newItem = [[ConversationStore sharedStore] createItem];
    
        //NSInteger lastRow = [[[ConversationStore sharedStore] allItems] indexOfObject:newItem];
    
        //NSIndexPath* indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
        //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    MessageViewController* detailViewController = [[MessageViewController alloc] initForNewItem:YES];
    
    detailViewController.currentItem = newItem;
    detailViewController.dismissBlock = ^{[self.tableView reloadData];};
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navController animated:YES completion:NULL];
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
    
    /*currCell.actionBlock = ^{
        NSLog(@"Going to show the image for %@", item);
        ECEItemCell* strongReference = weakCellReference;
        
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
        }
    };*/
    
    return currCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageViewController* detailViewController = [[MessageViewController alloc] initForNewItem:NO];
    
    NSArray* items = [[ConversationStore sharedStore] allItems];
    Conversation* itemToPass = items[indexPath.row];
    
    detailViewController.currentItem = itemToPass;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
