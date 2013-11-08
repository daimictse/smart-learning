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
    menuView.hidden = true;
    alphabetView.hidden = true;
    colorView.hidden = true;
    
    // initial alphabet page starts with 'A'
    lastAlphabet = 'A';
    
    // initial colors are green and red, and answer is the 'question marks'
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
    // index of result color
    ColorMatrix initialMatrix = { {1, 19, 14, 20, 15, 9},
        {19, 2, 8, 18, 7, 6},
        {14, 8, 3, 16, 17, 13},
        {20, 18, 16, 4 , 10, 11},
        {15, 7, 17, 10, 5, 12},
        {9, 6, 13, 11, 12, 21}
    };
    memcpy(colorMatrix, initialMatrix, sizeof(colorMatrix));
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
    NSLog(@"%@",username);
}

- (IBAction)switchToMenu {
    menuView.hidden = false;
    homeView.hidden = true;
    alphabetView.hidden = true;
    colorView.hidden = true;
    alphabetAnimationView.hidden = true;
    
    if (username) {
        [userNameButton setTitleColor:[UIColor redColor] forState:0];
        userNameButton.titleLabel.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:40];//systemFontOfSize:40];
        [userNameButton setTitle:username forState:0];
    }
}

- (IBAction)processLogin {
    NSLog(@"%@",username);
    // log in for existing user or create user
    
    // collect score history if it's an existing user
    
    [self switchToMenu];
}

-(IBAction)ReturnKeyButton: (id) sender {
    [sender resignFirstResponder];
}

- (IBAction)switchToHome {
    homeView.hidden = false;
    menuView.hidden = true;
    alphabetView.hidden = true;
    colorView.hidden = true;
    alphabetAnimationView.hidden = true;
}

- (IBAction)showAlphabetPg {
    alphabetView.hidden = false;
    homeView.hidden = true;
    menuView.hidden = true;
    colorView.hidden = true;
    alphabetAnimationView.hidden = true;
}

- (IBAction)showColorPg {
    colorView.hidden = false;
    homeView.hidden = true;
    menuView.hidden = true;
    [self setImages:lastAlphabet];
    alphabetView.hidden = true;
    alphabetAnimationView.hidden = true;
}

// determine which color by the swipe gesture
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

// set images according to the alphabet letter
- (void) setImages:(char) letter {
    lastAlphabet = letter;
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

- (IBAction) watchAlphabetAnimation {
    alphabetAnimationView.hidden = false;
    NSString *name = [NSString stringWithFormat:@"animation%c/",lastAlphabet];
    UIImage *image = [UIImage animatedImageNamed:name duration:0.5];
    [animation setImage:image];
}

- (IBAction) closeAnimation {
    alphabetAnimationView.hidden = true;
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

- (IBAction)loadE {
    [self setImages:'E'];
}
- (IBAction)loadF {
    [self setImages:'F'];
}
- (IBAction)loadG {
    [self setImages:'G'];
}
- (IBAction)loadH {
    [self setImages:'H'];
}
- (IBAction)loadI {
    [self setImages:'I'];
}
- (IBAction)loadJ {
    [self setImages:'J'];
}
- (IBAction)loadK {
    [self setImages:'K'];
}
- (IBAction)loadL {
    [self setImages:'L'];
}
- (IBAction)loadM {
    [self setImages:'M'];
}
- (IBAction)loadN {
    [self setImages:'N'];
}
- (IBAction)loadO {
    [self setImages:'O'];
}
- (IBAction)loadP {
    [self setImages:'P'];
}
- (IBAction)loadQ {
    [self setImages:'Q'];
}
- (IBAction)loadR {
    [self setImages:'R'];
}
- (IBAction)loadS {
    [self setImages:'S'];
}
- (IBAction)loadT {
    [self setImages:'T'];
}
- (IBAction)loadU {
    [self setImages:'U'];
}
- (IBAction)loadV {
    [self setImages:'V'];
}
- (IBAction)loadW {
    [self setImages:'W'];
}
- (IBAction)loadX {
    [self setImages:'X'];
}
- (IBAction)loadY {
    [self setImages:'Y'];
}
- (IBAction)loadZ {
    [self setImages:'Z'];
}
@end
