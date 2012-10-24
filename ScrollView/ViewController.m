//
//  ViewController.m
//  ScrollView
//
//  Created by LaptopKoom on 23/10/12.
//  Copyright (c) 2012 LaptopKoom. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _email.delegate = self;
    _password.delegate = self;
    [self getfacebook];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)getfacebook{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self updateView];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
            if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }

}
-(void)updateView{
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        [self.fbutton setTitle:@"Log out" forState:UIControlStateNormal];
        [self.txtfb setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
                                      appDelegate.session.accessToken]];
    } else {
        // login-needed account UI is shown whenever the session is closed
        [self.fbutton setTitle:@"Log in" forState:UIControlStateNormal];
        [self.txtfb setText:@"Login to create a link to fetch account data"];
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)doBasicLogin:(id)sender {
    @try {
        
    NSString *post = [NSString stringWithFormat:@"user[email]=%@&user[password]=%@", _email.text, _password.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
	
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:@"http:/test:test@trainingtest.herokuapp.com/api/v1/users/sign_in"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"get data %@",responseData);
    }
    @catch (NSException *exception) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Oops Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)viewDidUnload
{
    self.fbutton = nil;
    self.txtfb = nil;
    
    [super viewDidUnload];
}
- (IBAction)doLoginFB:(id)sender {
        
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        
           if (appDelegate.session.isOpen) {
            // if a user logs out explicitly, we delete any cached token information, and next
            // time they run the applicaiton they will be presented with log in UX again; most
            // users will simply close the app or switch away, without logging out; this will
            // cause the implicit cached-token login to occur on next launch of the application
            [appDelegate.session closeAndClearTokenInformation];
            
        } else {
            if (appDelegate.session.state != FBSessionStateCreated) {
                // Create a new, logged out session.
                appDelegate.session = [[FBSession alloc] init];
            }
            
            // if the session isn't open, let's open it now and present the login UX to the user
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // and here we make sure to update our UX according to the new session state
                [self updateView];
            }];
        } 

}
@end
