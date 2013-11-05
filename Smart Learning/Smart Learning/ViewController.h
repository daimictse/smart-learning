//
//  ViewController.h
//  Smart Learning
//
//  Created by Doris Shum on 11/4/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UITextField *usernameField;
    
    NSString *username;
}

- (IBAction)saveUser;
- (IBAction)resetNameField;
- (IBAction)switchToMenu;
- (IBAction)processLogin;
- (IBAction)ReturnKeyButton:(id)sender;

@end
