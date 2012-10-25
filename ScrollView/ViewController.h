//
//  ViewController.h
//  ScrollView
//
//  Created by LaptopKoom on 23/10/12.
//  Copyright (c) 2012 LaptopKoom. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController<UITextFieldDelegate>
- (IBAction)doBasicLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *fbutton;
@property (weak, nonatomic) IBOutlet UILabel *txtfb;
@property (strong, nonatomic) NSString*username;
- (IBAction)doLoginFB:(id)sender;


@end
