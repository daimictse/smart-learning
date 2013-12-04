//
//  ViewController.m
//  Smart Learning
//
//  Created by Doris Shum on 11/4/13.
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
    username = nil;
    password = nil;
    userLogin = false;
    pwView.hidden = true;
    menuView.hidden = true;
    alphabetView.hidden = true;
    colorView.hidden = true;
    
    alphabetAnimationView.layer.borderColor = [[UIColor grayColor] CGColor];
    alphabetAnimationView.layer.borderWidth = 2;
    alphabetScoreView.layer.borderColor = [[UIColor grayColor] CGColor];
    alphabetScoreView.layer.borderWidth = 2;
    colorScoreView.layer.borderColor = [[UIColor grayColor] CGColor];
    colorScoreView.layer.borderWidth = 2;
    
    // initial alphabet page starts with 'A'
    lastAlphabet = 'A';

    [self setDefaultPoints];
    
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

- (IBAction)resetPwField {
    pwField.text = @"";
    pwField.textColor = [UIColor blackColor];
}

- (IBAction)savePw {
    password = [pwField text];
    NSLog(@"%@",password);
    if (![password  isEqual: @""]) {
        pwField.text = @"";
        pwView.hidden = true;
        [self switchToMenu];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)switchToMenu {
    menuView.hidden = false;
    homeView.hidden = true;
    alphabetView.hidden = true;
    colorView.hidden = true;
    
    if (username) {
        [userNameButton setTitleColor:[UIColor magentaColor] forState:0];
        userNameButton.titleLabel.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:40];//systemFontOfSize:40];
        [userNameButton setTitle:username forState:0];
        [self resetNameField];
    }
}

- (IBAction)processLogin {
    NSLog(@"%@",username);
    if (username) {
        pwView.hidden = false;
        [pwField becomeFirstResponder];
        userLogin = true;
        [self resetNameField];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)ReturnKeyButton: (id) sender {
    [sender resignFirstResponder];
}

- (IBAction)switchToHome {
    username = nil;
    homeView.hidden = false;
    menuView.hidden = true;
    alphabetView.hidden = true;
    colorView.hidden = true;
}

- (IBAction)showAlphabetPg {
    if ([upperLetterTracingView getStrokeCount] > 0) {
        [upperLetterTracingView resetDrawingPad];
    }
    if ([lowerLetterTracingView getStrokeCount] > 0) {
        [lowerLetterTracingView resetDrawingPad];
    }
    alphabetView.hidden = false;
    homeView.hidden = true;
    menuView.hidden = true;
    colorView.hidden = true;
    alphabetAnimationView.hidden = true;
    alphabetScoreView.hidden = true;
}

- (IBAction)showColorPg {
    colorView.hidden = false;
    homeView.hidden = true;
    menuView.hidden = true;
    alphabetView.hidden = true;
    colorScoreView.hidden = true;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.message hasSuffix:@"Name"]) {
        [self resetNameField];
        [usernameField becomeFirstResponder];
    } else {
        [self resetPwField];
        [pwField becomeFirstResponder];
    }
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
    UIImage *image;
    NSLog(@"color1: %d, color2: %d, mixed: %d",color1Index, color2Index, mixedColorIndex);
    if (colorMatrix[color1Index][color2Index] == mixedColorIndex) {
        image = [UIImage imageNamed:@"welldone.png"];
    } else {
        image = [UIImage imageNamed:@"tryagain.png"];
    }
    [colorScoreImageView setImage:image];
    colorScoreView.hidden = false;
}

- (IBAction)closeColorScore {
    colorScoreView.hidden = true;
}

// set images according to the alphabet letter
- (void) setImages:(char) letter {    
    lastAlphabet = letter;
    [self showAlphabetPg];
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

- (NSString *)scoreRating:(char)letter scorePt:(float)scorePt {
    NSString *score;
    if (scorePt > 80.0)
        score = [NSString stringWithFormat:@"'%c': **EXCELLENT**", letter];
    else if (scorePt > 70.0)
        score = [NSString stringWithFormat:@"'%c': *Good Job*", letter];
    else if (scorePt == 0)
        score = [NSString stringWithFormat:@"'%c': Try Again", letter];
    else
        score = [NSString stringWithFormat:@"'%c': You can do better!", letter];
    return score;
}

- (IBAction)storeScore:(NSString *)data {
    // log in for existing user or create user
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:5000/"]];
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
//    NSData *requestBodyData = [data dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody = requestBodyData;
    
    //    [request setValue:[NSString stringWithFormat:@"%d", [stringData length]] forHTTPHeaderField:@"Content-length"];
    //    [request setHTTPBody:[stringData dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (!conn) {
        NSLog(@"Error connecting to URL for posting");
    } else
        [conn start];
}

- (IBAction)RateAlphabetTracing {
    float upperLetterScore=0;
    float lowerLetterScore=0;
    
    NSString *highestLetter1 = nil;
    NSString *highestLetter2 = nil;
    NSString *highestLetter3 = nil;
    float highest1=0.0;
    float highest2=0.0;
    float highest3=0.0;

    alphabetScoreView.hidden = false;
    
    int strokeCount = [upperLetterTracingView getStrokeCount];
    if (strokeCount > 0) {
        upperLetterScore = [upperLetterTracingView rateItWithTemplate:lastAlphabet];
    }
    strokeCount = [lowerLetterTracingView getStrokeCount];
    if (strokeCount > 0) {
        lowerLetterScore = [lowerLetterTracingView rateItWithTemplate:lastAlphabet];
    }
    
    // show score
    NSString *score = [self scoreRating:lastAlphabet scorePt:upperLetterScore];
    [upperScoreButton setTitle:score forState:0];
    
    score = [self scoreRating:tolower(lastAlphabet) scorePt:lowerLetterScore];
    [lowerScoreButton setTitle:score forState:0];

    if (!userLogin) {
        [highestButton1 setTitle:@"" forState:0];
        [highestButton2 setTitle:@"" forState:0];
        [highestButton3 setTitle:@"" forState:0];
    } else {
        // collect score history if it's an existing user
        // first handle the current scores
        if (upperLetterScore) {
            highest1 = upperLetterScore;
            highestLetter1 = [NSString stringWithFormat:@"%c", lastAlphabet];
        }
        if (lowerLetterScore) {
            if (upperLetterScore > lowerLetterScore) {
                highest2 = lowerLetterScore;
                highestLetter2 = [NSString stringWithFormat:@"%c", tolower(lastAlphabet)];
            } else {
                highest2 = highest1;
                highestLetter2 = highestLetter1;
                highest1 = lowerLetterScore;
                highestLetter1 = [NSString stringWithFormat:@"%c", tolower(lastAlphabet)];
            }
        }

        // insert current scores
        if (upperLetterScore > 0)
            [self storeScore:[NSString stringWithFormat:@"user=%@&password=%@&letter=%c&score=%0.2f", username, password, lastAlphabet, upperLetterScore]];
        if (lowerLetterScore > 0)
            [self storeScore:[NSString stringWithFormat:@"user=%@&password=%@&letter=%c&score=%0.2f", username, password, tolower(lastAlphabet), lowerLetterScore]];
        
        // read the recorded scores
        NSURL *url = [NSURL URLWithString:@"http://localhost:5000/"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"ret=%@", ret);
        
        NSScanner *scanner = [NSScanner scannerWithString:ret];
        NSString *thisUser;
        NSString *thisPW;
        NSString *thisLetter;
        float thisScore;
        
        while ([scanner isAtEnd] == NO) {
            [scanner scanUpToString:@"/" intoString:&thisUser];
            [scanner scanString:@"/" intoString:nil];
            [scanner scanUpToString:@"/" intoString:&thisPW];
            //NSLog(@"%@ %@", thisUser, thisPW);
            if ([thisUser isEqualToString:username] && [thisPW isEqualToString:password]) {
                [scanner scanString:@"/" intoString:nil];
                [scanner scanUpToString:@"/" intoString:&thisLetter];
                [scanner scanString:@"/" intoString:nil];
                [scanner scanFloat:&thisScore];
                char firstLetter = [thisLetter characterAtIndex:0];
                if (((firstLetter != lastAlphabet) && (firstLetter != tolower(lastAlphabet))) ||
                    (firstLetter == lastAlphabet && abs(thisScore-upperLetterScore)>1) ||
                    (firstLetter == tolower(lastAlphabet) && abs(thisScore-lowerLetterScore)>1)) {
                    // find out the 3 highest scores
                    if (thisScore > highest1) {
                        highest3 = highest2;
                        highest2 = highest1;
                        highest1 = thisScore;
                        highestLetter3 = highestLetter2;
                        highestLetter2 = highestLetter1;
                        highestLetter1 = thisLetter;
                    } else if (thisScore > highest2) {
                        highest3 = highest2;
                        highest2 = thisScore;
                        highestLetter3 = highestLetter2;
                        highestLetter2 = thisLetter;
                    } else if (thisScore > highest3) {
                        highest3 = thisScore;
                        highestLetter3 = thisLetter;
                    }
                }
            } else
                [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:nil];
        }
        // display the 3 highest scores
        NSLog(@"%f %f %f", highest1, highest2, highest3);
        if (highest1 != 0.0) {
            score = [self scoreRating:[highestLetter1 characterAtIndex:0] scorePt:highest1];
            [highestButton1 setTitle:score forState:0];
        } else
            [highestButton1 setTitle:@"NO 1st highest score" forState:0];
        if (highest2 != 0.0) {
            score = [self scoreRating:[highestLetter2 characterAtIndex:0] scorePt:highest2];
            [highestButton2 setTitle:score forState:0];
        } else
            [highestButton2 setTitle:@"NO 2nd highest score" forState:0];
        if (highest3 != 0.0) {
            score = [self scoreRating:[highestLetter3 characterAtIndex:0] scorePt:highest3];
            [highestButton3 setTitle:score forState:0];
        } else
            [highestButton3 setTitle:@"NO 3rd highest score" forState:0];
    }
}

- (IBAction)closeAlphabetScore {
    alphabetScoreView.hidden = true;
}

- (IBAction) watchAlphabetAnimation {
    alphabetAnimationView.hidden = false;

    NSString *filename = [NSString stringWithFormat:@"big%c", lastAlphabet];
    [animation setImage:[UIImage animatedImageNamed:filename duration:6]];
    
    NSString *filename2 = [NSString stringWithFormat:@"small%c", lastAlphabet];
    [animation2 setImage:[UIImage animatedImageNamed:filename2 duration:6]];
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

-(void) setDefaultPoints {
    // A
    NSMutableArray *points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.00, 31.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 28.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 30.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 35.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 41.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 50.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 59.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 68.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 79.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.00, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.00, 109.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.00, 118.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.00, 129.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.50, 142.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 154.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 138.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 127.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.50, 113.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 31.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 120.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.50, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 151.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.50, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.50, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.00, 142.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.00, 136.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.00, 136.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.00, 121.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.50, 105.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(122.50, 93.00)]];
    [upperLetterTracingView setDefaultPoints:'A' points:points];
    
    // B
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(12.00, 91.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 84.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 81.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 75.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.00, 67.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 62.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 39.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 63.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.00, 85.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 104.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 104.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.00, 142.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.50, 128.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 110.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 86.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 67.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.00, 53.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 46.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.00, 41.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.50, 42.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.50, 46.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(120.00, 52.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.50, 62.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.50, 71.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.50, 72.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(121.50, 78.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(119.00, 84.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.00, 90.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(106.50, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 95.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 86.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 83.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.00, 84.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(98.00, 90.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.50, 98.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.00, 106.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 114.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.00, 122.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.00, 131.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.00, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.00, 141.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 143.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 139.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 139.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 138.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 130.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 114.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 119.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.00, 122.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.50, 124.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.00, 124.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 118.50)]];
    [upperLetterTracingView setDefaultPoints:'B' points:points];

    // C
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(118.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.50, 37.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.50, 49.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.50, 57.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(114.00, 49.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(115.00, 42.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.50, 32.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 30.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 55.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.00, 67.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.50, 83.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.50, 98.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.00, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 131.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 140.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 145.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 145.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.00, 133.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.50, 125.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.50, 118.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(114.50, 107.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(119.00, 96.50)]];
    [upperLetterTracingView setDefaultPoints:'C' points:points];
    
    // D
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.00, 40.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 135.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.50, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.50, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(12.50, 144.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.50, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.50, 123.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 120.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.00, 126.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.00, 126.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.50, 138.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.00, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 144.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.00, 132.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.00, 119.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.00, 106.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.50, 90.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.00, 72.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.00, 42.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 31.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 27.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 32.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 35.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 42.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 50.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 56.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.00, 60.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(98.00, 58.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(115.50, 48.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(121.00, 40.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(125.00, 33.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(128.50, 26.50)]];
    [upperLetterTracingView setDefaultPoints:'D' points:points];
    
    // E
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(106.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.00, 33.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.50, 43.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(106.50, 44.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.00, 36.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.50, 28.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.50, 26.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 26.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 30.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 39.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 46.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 56.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 67.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 74.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 85.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 95.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.00, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 81.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 80.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 82.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 87.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.00, 95.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 104.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.50, 115.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.50, 126.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.50, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 150.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 152.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.50, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 144.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 135.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(106.50, 119.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(122.00, 93.50)]];
    [upperLetterTracingView setDefaultPoints:'E' points:points];
    
    // F
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 28.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 39.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 52.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 62.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 66.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 62.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 32.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 27.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.00, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 30.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.00, 36.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.00, 35.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.00, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(129.00, 25.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.00, 34.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 57.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 81.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 99.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.50, 143.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 149.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 149.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 145.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(9.00, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.50, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 97.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 102.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 96.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 88.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 105.00)]];
    [upperLetterTracingView setDefaultPoints:'F' points:points];
    
    // G
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(12.00, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.50, 105.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 85.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 60.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.50, 50.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.00, 38.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.00, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 23.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 23.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 33.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.50, 48.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 58.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 68.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 81.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 88.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 91.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.00, 78.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(128.00, 52.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.00, 118.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 138.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.50, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.00, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.50, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 151.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 138.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 126.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 90.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 101.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 110.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 116.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.50, 117.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 118.00)]];
    [upperLetterTracingView setDefaultPoints:'G' points:points];
    
    // H
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 23.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(39.00, 37.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 48.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 58.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.00, 63.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.00, 55.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.00, 39.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.50, 28.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 22.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 38.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 54.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 67.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.00, 159.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(127.50, 28.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.50, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.50, 23.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.00, 28.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.50, 34.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.00, 44.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.00, 54.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 160.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 119.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 108.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 88.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 103.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 112.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.00, 119.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.50, 123.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 122.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 122.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.50, 114.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.50, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.50, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.50, 96.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.50, 89.50)]];
    [upperLetterTracingView setDefaultPoints:'H' points:points];
 
    // I
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.00, 156.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 145.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.00, 126.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.00, 106.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.50, 85.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.50, 70.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 55.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.50, 43.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(107.50, 32.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(114.00, 29.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(122.00, 29.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(127.00, 34.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(129.00, 45.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(126.00, 56.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(121.50, 69.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(115.50, 85.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.50, 101.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.50, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 130.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 139.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.50, 155.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.00, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.00, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.00, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(14.50, 108.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.50, 99.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.50, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.00, 102.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.50, 108.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.50, 108.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 116.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 116.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 116.00)]];
    [upperLetterTracingView setDefaultPoints:'I' points:points];
    
    // J
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 125.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.50, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 85.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 67.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 51.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 39.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 18.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 15.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 18.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.00, 22.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 30.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.00, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 74.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 133.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 152.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.50, 160.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 166.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 166.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.50, 163.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.50, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.00, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(128.50, 64.50)]];
    [upperLetterTracingView setDefaultPoints:'J' points:points];

    // K
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 24.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 38.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.50, 54.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 61.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.00, 65.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.00, 55.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.50, 43.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 30.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 23.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.00, 28.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 40.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 59.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 81.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.50, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(118.00, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.00, 31.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 41.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.50, 52.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 64.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 76.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 87.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 91.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 92.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 85.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.00, 82.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.00, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 98.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 114.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 131.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 142.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 148.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 150.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 145.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(126.50, 87.50)]];
    [upperLetterTracingView setDefaultPoints:'K' points:points];
    
    // L
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.00, 74.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.50, 79.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.00, 79.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 74.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.00, 65.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.50, 56.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.00, 45.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(113.00, 34.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.00, 30.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.00, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.00, 23.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.50, 22.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.50, 23.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.50, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 47.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.00, 75.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 122.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 129.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 134.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.00, 137.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.50, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(14.50, 134.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(12.50, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(14.50, 127.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.50, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.00, 122.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.00, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.50, 128.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 134.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.00, 141.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.00, 157.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.50, 158.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(119.00, 157.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(128.00, 154.00)]];
    [upperLetterTracingView setDefaultPoints:'L' points:points];
    
    // M
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.50, 21.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 33.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 49.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 60.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.00, 63.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.50, 63.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.50, 55.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 47.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.50, 34.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.50, 20.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.00, 22.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 28.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 35.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 42.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.00, 51.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.00, 56.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 69.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.50, 79.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 155.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 156.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 68.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 59.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.00, 52.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 48.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.00, 44.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 46.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 52.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.00, 62.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.00, 71.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 79.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 80.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 70.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 63.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 59.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 57.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.50, 58.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.00, 61.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.00, 61.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(98.00, 66.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.00, 72.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.50, 79.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.50, 79.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 84.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.50, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.00, 141.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.00, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 154.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 156.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 156.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.50, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(110.50, 137.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(130.50, 89.50)]];
    [upperLetterTracingView setDefaultPoints:'M' points:points];

    // N
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.00, 20.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 39.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 49.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 57.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.50, 61.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.00, 61.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(12.00, 55.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.00, 46.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 32.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.50, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.50, 22.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 23.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.50, 25.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 31.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.50, 37.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.50, 48.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 58.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.50, 73.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.50, 81.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.00, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(12.50, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 72.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 61.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 53.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 53.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 49.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 44.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 41.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.00, 45.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 51.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.50, 58.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 65.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.50, 74.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.50, 95.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.50, 139.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 148.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 157.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.00, 151.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.50, 137.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.50, 118.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(129.50, 88.50)]];
    [upperLetterTracingView setDefaultPoints:'N' points:points];
    
    // O
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 24.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.50, 23.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 31.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.00, 39.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.50, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.00, 68.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.50, 78.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 86.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 120.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.00, 134.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.00, 144.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 157.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 155.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.00, 150.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 138.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.00, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.00, 94.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.00, 74.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.50, 62.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.00, 50.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.00, 44.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.50, 35.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.00, 28.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.00, 24.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 22.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 23.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 24.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 29.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 35.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 44.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 49.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 52.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 56.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.00, 56.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.50, 53.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.00, 47.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.50, 38.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(129.50, 22.00)]];
    [upperLetterTracingView setDefaultPoints:'O' points:points];
    
    // P
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.50, 88.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.00, 74.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 56.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.50, 45.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 35.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 22.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 160.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 48.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.00, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.00, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.00, 22.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.50, 23.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.50, 24.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.00, 27.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(122.00, 34.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(126.00, 44.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(127.50, 60.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.00, 71.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(118.00, 81.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(110.00, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.00, 99.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 103.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 105.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 102.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 88.00)]];
    [upperLetterTracingView setDefaultPoints:'P' points:points];

    // Q
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.50, 19.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.50, 32.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.00, 46.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 52.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 56.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.00, 55.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 48.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.00, 36.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.00, 30.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 21.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 19.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 18.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 18.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 20.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.50, 30.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 41.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.00, 53.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 67.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 77.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.00, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.00, 110.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 119.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 127.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 127.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 134.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.00, 138.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.00, 136.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(10.00, 132.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8.00, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(9.00, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.00, 123.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.00, 120.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.00, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.00, 128.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 134.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 142.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 149.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 149.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.50, 160.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.50, 161.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.00, 160.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.50, 157.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(124.50, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(132.50, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(134.50, 145.00)]];
    [upperLetterTracingView setDefaultPoints:'Q' points:points];

    // R
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(12.50, 86.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.50, 75.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 65.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.00, 33.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 17.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 162.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.00, 44.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 32.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 23.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 18.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.50, 20.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.50, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.00, 36.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(114.00, 50.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.00, 63.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.00, 73.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.00, 83.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.50, 92.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.00, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.00, 100.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 100.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 94.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 84.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.00, 74.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.00, 97.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 125.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 134.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.00, 159.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 159.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.50, 161.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.00, 155.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.50, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(110.50, 138.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.00, 128.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.00, 116.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(127.50, 104.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(131.00, 90.00)]];
    [upperLetterTracingView setDefaultPoints:'R' points:points];

    // S
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.00, 157.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.00, 137.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.00, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 108.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.50, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.00, 72.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(120.00, 55.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(128.50, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(130.00, 31.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(126.50, 24.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(127.50, 24.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(125.50, 19.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(120.50, 20.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.00, 23.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(113.00, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.00, 35.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.00, 41.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 52.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.00, 71.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 95.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.50, 120.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.00, 126.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.50, 132.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 141.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.00, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.00, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.50, 154.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 157.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 156.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.50, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.00, 142.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 132.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 123.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 111.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.50, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.50, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 105.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.50, 109.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.50, 111.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 113.00)]];
    [upperLetterTracingView setDefaultPoints:'S' points:points];
    
    // T
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 44.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.00, 55.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 63.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 68.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 68.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 66.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 64.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 58.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.50, 58.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.50, 49.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.50, 48.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 39.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.00, 28.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 26.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.50, 32.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.50, 31.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.50, 32.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.00, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.00, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.50, 32.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(122.00, 30.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(131.50, 25.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.00, 30.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.50, 39.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 68.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 88.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 111.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 134.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 142.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.50, 143.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.50, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.00, 114.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(10.50, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(10.50, 99.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(11.00, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.00, 104.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.50, 110.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.00, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 114.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 114.00)]];
    [upperLetterTracingView setDefaultPoints:'T' points:points];

    // U
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 19.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.00, 34.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 34.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 44.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 55.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.00, 59.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 58.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.50, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.50, 42.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.50, 32.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.00, 24.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.00, 20.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 21.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 34.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 41.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.50, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 61.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 75.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.00, 114.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.50, 137.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.00, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.00, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.50, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.00, 19.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 110.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 122.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 133.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 133.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 140.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 151.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 151.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 145.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.00, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.00, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(115.50, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(126.00, 87.50)]];
    [upperLetterTracingView setDefaultPoints:'U' points:points];

    // V
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 21.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 21.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 37.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 47.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.00, 47.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 58.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.50, 61.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.50, 60.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.50, 53.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.50, 44.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.50, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.50, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 21.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 24.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 38.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.50, 52.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 59.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 69.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 81.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.50, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.50, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.50, 118.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.00, 141.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.50, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.00, 155.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.00, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 140.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.50, 128.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.00, 89.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.50, 73.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.00, 57.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 46.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 37.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.50, 31.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.50, 25.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(125.00, 21.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(130.50, 22.00)]];
    [upperLetterTracingView setDefaultPoints:'V' points:points];

    // W
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 17.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.00, 35.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.50, 45.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.00, 57.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.00, 61.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.00, 58.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.00, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.00, 40.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 30.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.00, 24.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.00, 18.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.00, 18.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.00, 19.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.00, 36.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 51.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(39.50, 65.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 80.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 102.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 157.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.50, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.00, 101.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 78.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 17.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 78.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.50, 116.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.50, 159.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 134.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 115.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.00, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 76.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.50, 62.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(98.00, 49.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.50, 36.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.50, 22.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.00, 19.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(131.00, 18.50)]];
    [upperLetterTracingView setDefaultPoints:'W' points:points];

    // X
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 27.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 43.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 43.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 64.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.00, 66.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.00, 64.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 60.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.00, 48.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 37.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.00, 29.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 27.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 28.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.50, 44.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 74.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 112.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 134.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 140.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 149.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 156.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 160.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.00, 161.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.00, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.50, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.50, 138.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.50, 130.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.00, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.00, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 123.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 133.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.00, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.00, 158.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(127.50, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.00, 161.50)]];
    [upperLetterTracingView setDefaultPoints:'X' points:points];

    // Y
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 13.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 24.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 40.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.50, 43.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.00, 43.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(11.50, 37.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(11.50, 29.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.50, 21.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.50, 16.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.50, 13.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.00, 15.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 24.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 34.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 40.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 47.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.50, 86.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.50, 98.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 109.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.00, 114.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 115.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 112.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(39.50, 105.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 95.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 83.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 66.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.00, 14.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 151.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 159.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.50, 163.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.00, 165.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.00, 162.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(14.00, 154.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.50, 139.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 129.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(129.00, 64.50)]];
    [upperLetterTracingView setDefaultPoints:'Y' points:points];

    // Z
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 18.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 27.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 34.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.50, 42.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 47.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 48.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 42.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(39.50, 33.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.50, 19.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 15.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 17.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 18.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 36.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.50, 43.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 60.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.50, 69.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.00, 82.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.00, 104.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 104.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 105.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 112.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 114.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 112.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 107.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 102.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 102.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 107.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.50, 118.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 129.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 144.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.00, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.50, 160.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 163.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.00, 158.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.00, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.00, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 127.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(127.00, 65.00)]];
    [upperLetterTracingView setDefaultPoints:'Z' points:points];
    
    // a
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.00, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 101.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.00, 110.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.00, 127.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.00, 140.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 154.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 149.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.00, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.50, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 107.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 122.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.50, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.50, 140.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.00, 155.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.00, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.50, 125.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(118.00, 113.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.50, 94.50)]];
    [lowerLetterTracingView setDefaultPoints:'A' points:points];
    
    // b
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.00, 142.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 119.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 101.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 89.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.00, 71.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.00, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.50, 36.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 39.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 63.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 80.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 96.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 123.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 145.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 151.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.50, 151.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 145.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.00, 132.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.00, 90.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.50, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(120.50, 91.00)]];
    [lowerLetterTracingView setDefaultPoints:'B' points:points];
    
    // c
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 111.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 102.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 92.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 108.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.50, 127.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 140.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.00, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 158.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 157.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 155.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 151.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.00, 143.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.00, 137.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.00, 123.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(120.50, 92.50)]];
    [lowerLetterTracingView setDefaultPoints:'C' points:points];
    
    // d
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 92.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 91.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.50, 94.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.00, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.50, 109.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.00, 121.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.50, 128.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.50, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.50, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.50, 145.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.00, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.00, 136.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 107.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.00, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.00, 66.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 31.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 56.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 86.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 111.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 126.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.50, 134.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.50, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.50, 148.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 148.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.00, 134.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(110.50, 116.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(125.00, 90.00)]];
    [lowerLetterTracingView setDefaultPoints:'D' points:points];
    
    // e
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.00, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.00, 143.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.50, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.00, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 88.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 88.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.00, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 112.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 128.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.00, 138.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 144.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.50, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.00, 143.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(98.00, 131.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.50, 125.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(110.00, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(119.50, 101.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(126.00, 88.00)]];
    [lowerLetterTracingView setDefaultPoints:'E' points:points];
    
    // f
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.50, 115.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 109.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(39.00, 99.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 77.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 59.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.00, 47.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.50, 35.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(107.00, 27.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(107.00, 21.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.00, 18.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.00, 17.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.00, 24.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 39.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 59.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.00, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 131.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.50, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.00, 157.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 163.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.50, 165.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 160.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 135.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 128.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 119.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 116.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.00, 115.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.50, 111.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 103.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.00, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.00, 89.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(113.00, 81.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.50, 68.00)]];
    [lowerLetterTracingView setDefaultPoints:'F' points:points];
    
    // g
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 68.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.00, 68.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.50, 70.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.50, 72.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 77.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.50, 80.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.50, 84.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.50, 89.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.00, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.50, 104.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.50, 109.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 115.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.00, 118.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.50, 103.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 91.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 80.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 71.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 85.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 104.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 121.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.00, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 148.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(39.50, 159.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 165.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.00, 165.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.50, 163.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 142.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 134.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.00, 99.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(110.50, 81.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(129.00, 68.50)]];
    [lowerLetterTracingView setDefaultPoints:'G' points:points];
    
    // h
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(14.50, 158.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.00, 114.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 99.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 82.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 65.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 48.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.50, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.00, 26.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 18.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.50, 18.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.00, 24.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 34.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 54.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.00, 75.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.00, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 116.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 131.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.00, 157.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.00, 140.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 122.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 108.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 95.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 85.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.00, 86.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.50, 103.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.50, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.00, 138.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.00, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.00, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.00, 157.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 160.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.00, 143.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.50, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(118.50, 111.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(130.00, 90.00)]];
    [lowerLetterTracingView setDefaultPoints:'H' points:points];
    
    // i
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.00, 150.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 143.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.50, 126.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 109.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.00, 85.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 97.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 112.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.00, 122.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 137.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.50, 143.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.50, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.50, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.00, 132.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.50, 122.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.50, 106.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.50, 106.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(121.00, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 54.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.50, 65.50)]];
    [lowerLetterTracingView setDefaultPoints:'I' points:points];
    
    // j
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.50, 118.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.00, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 115.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 79.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 67.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 87.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.00, 108.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 159.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 166.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.00, 166.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.00, 160.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.00, 144.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 134.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 126.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.00, 117.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 108.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.00, 91.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(107.50, 80.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(118.50, 73.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(128.00, 68.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 43.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 53.50)]];
    [lowerLetterTracingView setDefaultPoints:'J' points:points];
    
    // k
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.00, 155.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.50, 140.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 123.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.00, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 83.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 63.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.50, 43.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.50, 34.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.50, 26.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 21.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.50, 20.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 27.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 46.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 59.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 75.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 88.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.00, 102.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 120.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 137.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.50, 144.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 128.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.50, 112.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 100.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 92.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 85.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 86.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 95.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.00, 102.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 107.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 113.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.00, 115.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.00, 116.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 114.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 122.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 135.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 144.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.00, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.50, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.50, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.00, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(119.50, 110.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(132.00, 87.50)]];
    [lowerLetterTracingView setDefaultPoints:'K' points:points];
    
    // l
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.50, 158.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 144.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 129.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 107.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.00, 84.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.00, 69.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.50, 55.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(107.00, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.50, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.50, 23.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 31.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 78.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 103.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.00, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.00, 141.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.00, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 157.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.50, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.50, 138.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.00, 123.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(114.00, 106.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.00, 91.00)]];
    [lowerLetterTracingView setDefaultPoints:'L' points:points];
    
    // m
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(9.00, 160.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.00, 135.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 119.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 106.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 101.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 108.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 116.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 158.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.00, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 124.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.00, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 92.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.00, 99.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 108.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 114.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.50, 125.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 135.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.50, 160.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 144.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 127.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.00, 112.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.00, 103.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 92.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 92.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 99.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 109.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.00, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 137.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.50, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 158.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 158.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 151.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(110.50, 143.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(118.50, 125.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(124.50, 111.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(130.50, 92.00)]];
    [lowerLetterTracingView setDefaultPoints:'M' points:points];
    
    // n
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.00, 158.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.50, 133.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 114.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 99.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 88.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.00, 90.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 95.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 103.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 112.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.50, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 134.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 157.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.50, 143.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 109.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.00, 99.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.50, 89.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 91.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 106.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 120.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.00, 143.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 157.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.00, 155.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.50, 150.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.50, 140.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.50, 118.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.00, 105.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(130.00, 89.00)]];
    [lowerLetterTracingView setDefaultPoints:'N' points:points];
    
    // o
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 95.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 105.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 112.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.50, 129.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 142.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.00, 150.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 155.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 159.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 158.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.00, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.00, 142.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.50, 133.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.50, 119.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.00, 108.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 99.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.50, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.50, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.00, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(113.50, 97.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(121.50, 93.50)]];
    [lowerLetterTracingView setDefaultPoints:'O' points:points];
    
    // p
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.50, 92.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 74.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 63.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.00, 45.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 23.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 47.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 66.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 84.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 110.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 123.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 141.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.00, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.00, 161.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(14.00, 163.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(14.50, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.00, 126.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 102.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 87.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 72.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 57.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 42.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.00, 21.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 21.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.00, 25.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.50, 30.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.00, 41.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 55.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 65.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 73.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.50, 81.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 92.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.50, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 78.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 86.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.50, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.00, 82.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.50, 67.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.00, 52.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.50, 38.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(130.50, 21.50)]];
    [lowerLetterTracingView setDefaultPoints:'P' points:points];
    
    // q
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.50, 63.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 63.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 61.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.50, 64.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 66.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 75.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 83.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 97.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(21.00, 111.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.00, 114.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 106.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 80.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 61.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 72.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.00, 89.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 99.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 112.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 123.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 138.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 164.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 165.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 163.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.00, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.00, 141.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 126.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 109.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 104.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.50, 94.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.50, 79.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(130.00, 63.00)]];
    [lowerLetterTracingView setDefaultPoints:'Q' points:points];
    
    // r
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 159.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.00, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.50, 140.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.50, 108.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 83.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 92.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 96.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 98.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 109.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 123.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 137.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 145.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 160.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 159.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.50, 137.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(113.50, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(131.00, 89.50)]];
    [lowerLetterTracingView setDefaultPoints:'R' points:points];
    
    // s
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.00, 143.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 109.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.00, 85.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.50, 101.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 111.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 123.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.50, 136.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 143.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 154.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 154.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 154.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.00, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.00, 144.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(107.50, 132.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(118.00, 120.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(122.00, 108.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(130.50, 89.00)]];
    [lowerLetterTracingView setDefaultPoints:'S' points:points];
    
    // t
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.50, 159.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 130.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 109.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 109.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.00, 92.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 72.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.50, 57.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.00, 35.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.00, 52.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.50, 78.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.00, 102.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.50, 121.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.50, 134.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 157.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 158.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 158.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.00, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.00, 127.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(114.00, 108.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.00, 108.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(126.50, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.50, 71.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.00, 71.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.50, 72.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(106.00, 72.50)]];
    [lowerLetterTracingView setDefaultPoints:'T' points:points];
    
    // u
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(14.00, 158.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.50, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.00, 134.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 112.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 88.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.50, 100.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 119.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.50, 145.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(51.00, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 144.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 119.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.50, 107.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 88.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 97.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 114.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.00, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 140.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 154.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.50, 145.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(110.00, 135.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(121.50, 122.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(132.50, 98.00)]];
    [lowerLetterTracingView setDefaultPoints:'U' points:points];
    
    // v
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.00, 159.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 134.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.50, 116.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(39.00, 105.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 97.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.00, 86.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 105.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.00, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.00, 144.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.00, 152.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 158.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 159.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 151.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 129.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.00, 113.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(98.00, 88.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.00, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.50, 96.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.00, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(132.00, 90.00)]];
    [lowerLetterTracingView setDefaultPoints:'V' points:points];
    
    // w
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(11.50, 161.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.00, 120.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.50, 110.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 141.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.00, 159.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 158.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 149.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 108.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 86.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.00, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 118.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 130.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 144.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.00, 158.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 149.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 129.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.50, 108.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.50, 107.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.00, 88.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.00, 96.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.00, 97.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(124.00, 98.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(133.00, 89.50)]];
    [lowerLetterTracingView setDefaultPoints:'W' points:points];
    
    // x
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.50, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.50, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 118.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.50, 91.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 84.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 82.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 90.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.00, 101.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 114.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 125.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.50, 137.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.50, 148.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 156.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 151.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(98.50, 140.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(113.50, 121.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(129.00, 96.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.00, 84.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 102.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 118.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 137.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.00, 137.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.50, 156.00)]];
    [lowerLetterTracingView setDefaultPoints:'X' points:points];
    
    // y
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(10.50, 111.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.50, 99.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.00, 88.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.00, 78.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 68.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.00, 62.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 63.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.00, 69.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 81.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.50, 105.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 112.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.50, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 106.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.00, 96.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 84.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 70.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.00, 61.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 79.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 105.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.50, 123.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 134.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.00, 147.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 158.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 162.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 162.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 155.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 132.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 120.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(78.00, 105.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.50, 81.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.00, 72.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(130.00, 62.50)]];
    [lowerLetterTracingView setDefaultPoints:'Y' points:points];

    // z
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.50, 116.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.50, 102.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 88.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 79.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(52.50, 68.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.50, 60.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 60.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.00, 66.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 73.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 84.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 94.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.00, 105.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.00, 115.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 102.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.50, 102.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 115.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 129.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(58.50, 144.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.50, 158.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.50, 164.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(39.50, 166.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.00, 166.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 161.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.50, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 128.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 120.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 107.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.00, 93.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.50, 78.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(125.50, 66.00)]];
    [lowerLetterTracingView setDefaultPoints:'Z' points:points];
}
@end
