//
//  showInforView.m
//  ScrollView
//
//  Created by LaptopKoom on 24/10/12.
//  Copyright (c) 2012 LaptopKoom. All rights reserved.
//

#import "showInforView.h"

@interface showInforView ()

@end

@implementation showInforView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _shoEmail.text = [NSString stringWithFormat:@"email: %@", _txt];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setShoEmailText:(NSString *)txt{
    _txt = txt;
}

@end
