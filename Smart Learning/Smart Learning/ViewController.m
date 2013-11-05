//
//  ViewController.m
//  Smart Learning
//
//  Created by Doris Shum on 11/4/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import "ViewController.h"
#import "MainMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetNameField {
    usernameField.text = @"";
    usernameField.textColor = [UIColor blackColor];
}

- (IBAction)saveUser {
    username = [usernameField text];
}

- (IBAction)switchToMenu {
    MainMenu *menu = [[MainMenu alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:menu animated:YES completion:NULL];
}

- (IBAction)processLogin {
    NSLog(@"%@",username);
    // log in for existing user or create user
    
    // collect score history if it's an existing user
    
    MainMenu *menu = [[MainMenu alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:menu animated:YES completion:NULL];
}

-(IBAction)ReturnKeyButton:(id)sender {
    [sender resignFirstResponder];
}
@end
