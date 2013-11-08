//
//  ViewController.m
//  SmartLearningLite
//
//  Created by Doris Shum on 11/7/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import "ViewController.h"

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

- (IBAction) switchToMenu {
    menuView.hidden = false;
}

- (IBAction) switchToHome {
    homeView.hidden = false;
}
@end
