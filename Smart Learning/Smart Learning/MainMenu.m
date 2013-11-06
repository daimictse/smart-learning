//
//  MainMenu.m
//  Smart Learning
//
//  Created by Doris Shum on 11/4/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import "MainMenu.h"
#import "TracingAlphabets.h"
#import "MixingColors.h"

@interface MainMenu ()

@end

@implementation MainMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)alphabelPg {
    TracingAlphabets *tracingPg = [[TracingAlphabets alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:tracingPg animated:YES completion:NULL];
}

- (IBAction)colorPg {
    MixingColors *mixingPg = [[MixingColors alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:mixingPg animated:YES completion:NULL];

}

@end
