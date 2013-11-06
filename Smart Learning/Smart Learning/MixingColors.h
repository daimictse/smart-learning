//
//  MixingColors.h
//  Smart Learning
//
//  Created by Doris Shum on 11/5/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixingColors : UIViewController {
    IBOutlet UIImageView *color1View;
    IBOutlet UIImageView *color2View;
    IBOutlet UIImageView *mixedColorView;
    
    int color1Index;
    int color2Index;
    int mixedColorIndex;
    
    NSArray *colorImages;
    NSArray *mixedColorImages;
 }

- (int)getNewImageIndex:(UISwipeGestureRecognizer *)sender
        origImageIndex:(int)origImageIndex
        imageArrayCount:(int)imageArrayCount;
- (IBAction)Back;
- (IBAction)mixedColorIsCorrect;
- (IBAction)swipeColor1: (UISwipeGestureRecognizer *) recognizer;
- (IBAction)swipeColor2: (UISwipeGestureRecognizer *) recognizer;
- (IBAction)swipeMixedColor: (UISwipeGestureRecognizer *) recognizer;

@end
