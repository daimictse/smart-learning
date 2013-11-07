//
//  TracingAlphabets.h
//  Smart Learning
//
//  Created by Doris Shum on 11/5/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TracingAlphabets : UIViewController {
    IBOutlet UIImageView *pic;
    IBOutlet UIImageView *upperLetter;
    IBOutlet UIImageView *lowerLetter;
}

- (IBAction)Back;
- (void) setImages:(char) letter;
- (IBAction)loadA;
- (IBAction)loadB;
- (IBAction)loadC;
- (IBAction)loadD;
- (IBAction)loadE;

@end
