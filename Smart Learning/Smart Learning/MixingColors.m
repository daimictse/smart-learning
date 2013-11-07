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
        color1Index = 5;
        color2Index = 0;
        mixedColorIndex = 0;
        colorImages = [[NSArray alloc] initWithObjects:
                       @"red.png",
                       @"blue.png",
                       @"yellow.png",
                       @"cyan.png",
                       @"magenta.png",
                       @"green.png", nil];
        mixedColorImages = [[NSArray alloc] initWithObjects:
                            @"questionMark.jpg",
                            @"red.png", // 1
                            @"blue.png", // 2
                            @"yellow.png", // 3
                            @"cyan.png", // 4
                            @"magenta.png", // 5
                            @"blueGreen.png", // 6
                            @"blueMagenta.png", // 7
                            @"blueYellow.png", // 8
                            @"brown.png", // 9
                            @"cyanMagenta.png", // 10
                            @"greenCyan.png", // 11
                            @"greenMagenta.png", // 12
                            @"greenYellow.png", // 13
                            @"orange.jpg", // 14
                            @"redMagenta.png", // 15
                            @"yellowCyan.png", // 16
                            @"yellowMagenta.png", // 17
                            @"blueCyan.png", // 18
                            @"purple.png", // 19
                            @"redCyan.png", // 20
                            @"green.png", nil]; // 21
        
        ColorMatrix initialMatrix = { {1, 19, 14, 20, 15, 9},
            {19, 2, 8, 18, 7, 6},
            {14, 8, 3, 16, 17, 13},
            {20, 18, 16, 4 , 10, 11},
            {15, 7, 17, 10, 5, 12},
            {9, 6, 13, 11, 12, 21}
        };
        memcpy(colorMatrix, initialMatrix, sizeof(colorMatrix));
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
    color1Index = [self getNewImageIndex:sender origImageIndex:color1Index imageArrayCount:6];
    color1View.image = [UIImage imageNamed:[colorImages objectAtIndex:color1Index]];
}

- (IBAction)swipeColor2: (UISwipeGestureRecognizer *) sender {
    NSLog(@"Swipe2");
    color2Index = [self getNewImageIndex:sender origImageIndex:color2Index imageArrayCount:6];
    color2View.image = [UIImage imageNamed:[colorImages objectAtIndex:color2Index]];
}

- (IBAction)swipeMixedColor:(UISwipeGestureRecognizer *) sender {
    NSLog(@"Swipe");
    mixedColorIndex = [self getNewImageIndex:sender origImageIndex:mixedColorIndex imageArrayCount:22];
    mixedColorView.image = [UIImage imageNamed:[mixedColorImages objectAtIndex:mixedColorIndex]];
}

- (IBAction)checkMixedColorIsCorrect {
    NSLog(@"color1: %d, color2: %d, mixed: %d",color1Index, color2Index, mixedColorIndex);
    if (colorMatrix[color1Index][color2Index] == mixedColorIndex) {
        NSLog(@"Correct");
    } else {
        NSLog(@"Incorrect");
    }
}
@end
