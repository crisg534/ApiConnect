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
-(void)setShoEmailText:(NSString *)txt;
@end
