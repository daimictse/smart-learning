//
//  MixingColors.m
//  Smart Learning
//
//  Created by Doris Shum on 11/5/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import "MixingColors.h"

@interface MixingColors ()

@end

@implementation MixingColors

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        color1Index = 0;
        color2Index = 0;
        mixedColorIndex = 0;
        colorImages = [[NSArray alloc] initWithObjects:
                       @"red.jpg",
                       @"blue.jpg",
                       @"yellow.jpg",
                       @"white.png",
                       @"green.jpg", nil];
        mixedColorImages = [[NSArray alloc] initWithObjects:
                            @"questionMark.jpg",
                            @"red.jpg",
                            @"green.jpg", nil];
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

- (int)getNewImageIndex:(UISwipeGestureRecognizer *)sender
        origImageIndex:(int)origImageIndex
        imageArrayCount:(int)imageArrayCount {
    int imageIndex = origImageIndex;
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *) sender direction];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            imageIndex++;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            imageIndex--;
            break;
        default:
            break;
            
    }
    imageIndex = (imageIndex < 0) ? (imageArrayCount -1) : imageIndex % imageArrayCount;
    return imageIndex;
}

- (IBAction)swipeColor1: (UISwipeGestureRecognizer *) sender {
    NSLog(@"Swipe1");
    color1Index = [self getNewImageIndex:sender origImageIndex:color1Index imageArrayCount:5];
    color1View.image = [UIImage imageNamed:[colorImages objectAtIndex:color1Index]];
}

- (IBAction)swipeColor2: (UISwipeGestureRecognizer *) sender {
    NSLog(@"Swipe2");
    color2Index = [self getNewImageIndex:sender origImageIndex:color2Index imageArrayCount:5];
    color2View.image = [UIImage imageNamed:[colorImages objectAtIndex:color2Index]];
}

- (IBAction)swipeMixedColor:(UISwipeGestureRecognizer *) sender {
    NSLog(@"Swipe");
    mixedColorIndex = [self getNewImageIndex:sender origImageIndex:mixedColorIndex imageArrayCount:3];
    mixedColorView.image = [UIImage imageNamed:[mixedColorImages objectAtIndex:mixedColorIndex]];
}

- (IBAction)mixedColorIsCorrect {
    NSLog(@"color1: %d, color2: %d, mixed: %d",color1Index, color2Index, mixedColorIndex);
}
@end
