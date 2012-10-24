//
//  ViewController.m
//  ScrollView
//
//  Created by LaptopKoom on 23/10/12.
//  Copyright (c) 2012 LaptopKoom. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "showInforView.h"
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
        [self.txtfb setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",appDelegate.session.accessToken]];
        
       
    } else {
        // login-needed account UI is shown whenever the session is closed
        [self.fbutton setTitle:@"Log in" forState:UIControlStateNormal];
        [self.txtfb setText:@"Login to create a link to fetch account data"];
    }


}

-(void)getFriendFb:(NSString*)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
    NSLog(@"get friends",);

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
	
        NSMutableURLRequest *request = [self LoginLocal:postData :postLength];
        [self getResponseData:request];
        [self performSegueWithIdentifier:@"local" sender:sender];
    }
    @catch (NSException *exception) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:exception.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(NSMutableURLRequest*)LoginLocal:(NSData*)postData:(NSString*)postLength{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:@"http:/test:test@trainingtest.herokuapp.com/api/v1/users/sign_in"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
    return request;

}

-(void)getResponseData:(NSMutableURLRequest*)request{
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (responseData) {
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&err];
       
        NSLog(@"responseData: %@", res);
        
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
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier]
         isEqualToString:@"local"]){
        
        showInforView *viewController = [segue destinationViewController];
        [viewController setShoEmailText:_email.text ];
       
        
    }
    
}


@end
