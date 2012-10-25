//
//  showInforView.h
//  ScrollView
//
//  Created by LaptopKoom on 24/10/12.
//  Copyright (c) 2012 LaptopKoom. All rights reserved.
//

#import "ViewController.h"
#import "UserClass.h"
@interface showInforView : ViewController
@property (weak, nonatomic) IBOutlet UILabel *shoEmail;
@property (strong, nonatomic) UserClass* dataObject;
@property (strong, nonatomic) NSString*txt;
@property (strong, nonatomic) NSString*user_name;
@property (nonatomic, assign) id delegate;
-(void)setShoEmailText:(NSString *)txt;
@property (weak, nonatomic) IBOutlet UILabel *showUsername;
@end
