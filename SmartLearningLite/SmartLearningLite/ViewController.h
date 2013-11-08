//
//  ViewController.h
//  SmartLearningLite
//
//  Created by Doris Shum on 11/7/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UIView *homeView;
    IBOutlet UIView *menuView;
}

- (IBAction) switchToMenu;
- (IBAction) switchToHome;

@end
