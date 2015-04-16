//
//  ViewController.m
//  Keybase Library
//
//  Created by Zach Malinowski on 3/31/15.
//  Copyright (c) 2015 Zach Malinowski. All rights reserved.
//

#import "ViewController.h"
#import "Keybase.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextView* mainLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[Keybase KeybaseLib] keybase_getsalt:@"gamer239" completed:^(NSData* data){ NSDictionary* jsonData = [[Keybase KeybaseLib] convertJsonData:data]; NSLog(@"%@", jsonData);}];
    [[Keybase KeybaseLib] keybase_login:@"gamer239" password:@"" completed:^(NSData* data){ NSDictionary* jsonData = [[Keybase KeybaseLib] convertJsonData:data]; NSLog(@"%@", jsonData);}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)fetch:(id)sender
{
    //self.mainLabel.text = [[Keybase KeybaseLib] getReturnStatement];
    [[Keybase KeybaseLib] keybase_autocomplete:@"gamer" completed:^(NSData* data){ NSDictionary* jsonData = [[Keybase KeybaseLib] convertJsonData:data]; self.mainLabel.text = [jsonData[@"completions"] componentsJoinedByString:@""]; NSLog(@"%@", jsonData);}];
}



@end
