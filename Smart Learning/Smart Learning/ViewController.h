//
//  ViewController.h
//  Smart Learning
//
//  Created by Doris Shum on 11/4/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef int ColorMatrix[6][6];

@interface ViewController : UIViewController {
    IBOutlet UIView *homeView;
    IBOutlet UIView *menuView;
    IBOutlet UIView *alphabetView;
    IBOutlet UIView *colorView;
    IBOutlet UIView *alphabetAnimationView;
    
    // inside home
    IBOutlet UITextField *usernameField;
    NSString *username;

    // inside menu
    IBOutlet UIButton *userNameButton;
    
    // inside alphabet page
    IBOutlet UIImageView *pic;
    IBOutlet UIImageView *upperLetter;
    IBOutlet UIImageView *lowerLetter;
    IBOutlet UIImageView *animation;
    char lastAlphabet;
    
    // inside color page
    IBOutlet UIImageView *color1View;
    IBOutlet UIImageView *color2View;
    IBOutlet UIImageView *mixedColorView;
    int color1Index;
    int color2Index;
    int mixedColorIndex;
    NSArray *colorImages;
    NSArray *mixedColorImages;    
    ColorMatrix colorMatrix;
}

- (IBAction)saveUser;
- (IBAction)resetNameField;
- (IBAction)switchToMenu;
- (IBAction)processLogin;
- (IBAction)ReturnKeyButton: (id)sender;
- (IBAction)switchToHome;

// inside menu page
- (IBAction)showAlphabetPg;
- (IBAction)showColorPg;

// inside color page
- (int)getNewImageIndex:(UISwipeGestureRecognizer *)sender
         origImageIndex:(int)origImageIndex
        imageArrayCount:(int)imageArrayCount;
- (IBAction)checkMixedColorIsCorrect;
- (IBAction)swipeColor1: (UISwipeGestureRecognizer *) recognizer;
- (IBAction)swipeColor2: (UISwipeGestureRecognizer *) recognizer;
- (IBAction)swipeMixedColor: (UISwipeGestureRecognizer *) recognizer;

// inside alphabet page
- (void) setImages:(char) letter;
- (IBAction) watchAlphabetAnimation;
- (IBAction) closeAnimation;
- (IBAction)loadA;
- (IBAction)loadB;
- (IBAction)loadC;
- (IBAction)loadD;
- (IBAction)loadE;
- (IBAction)loadF;
- (IBAction)loadG;
- (IBAction)loadH;
- (IBAction)loadI;
- (IBAction)loadJ;
- (IBAction)loadK;
- (IBAction)loadL;
- (IBAction)loadM;
- (IBAction)loadN;
- (IBAction)loadO;
- (IBAction)loadP;
- (IBAction)loadQ;
- (IBAction)loadR;
- (IBAction)loadS;
- (IBAction)loadT;
- (IBAction)loadU;
- (IBAction)loadV;
- (IBAction)loadW;
- (IBAction)loadX;
- (IBAction)loadY;
- (IBAction)loadZ;

@end
