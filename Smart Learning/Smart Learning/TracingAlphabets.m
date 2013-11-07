//
//  TracingAlphabets.m
//  Smart Learning
//
//  Created by Doris Shum on 11/5/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import "TracingAlphabets.h"

@interface TracingAlphabets ()

@end

@implementation TracingAlphabets

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

- (IBAction)Back {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) setImages:(char) letter {
    NSString *name = [NSString stringWithFormat:@"pic%c.png",letter];
    UIImage *image = [UIImage imageNamed:name];
    [pic setImage:image];
    name = [NSString stringWithFormat:@"upper%c.png", letter];
    image = [UIImage imageNamed:name];
    [upperLetter setImage:image];
    name = [NSString stringWithFormat:@"lower%c.png", letter];
    image = [UIImage imageNamed:name];
    [lowerLetter setImage:image];
}

- (IBAction)loadA {
    [self setImages:'A'];
}

- (IBAction)loadB {
    [self setImages:'B'];
}

- (IBAction)loadC {
    [self setImages:'C'];
}

- (IBAction)loadD {
    [self setImages:'D'];
}

@end
