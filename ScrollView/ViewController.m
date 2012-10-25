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
                
                [[[FBRequest alloc] initWithSession:session graphPath:@"me?fields=id,name,email"] startWithCompletionHandler:
                 ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                     if (!error) {
                         self.txtfb.text = user.name;
                         
                         NSLog(@"%@",user);
                         NSLog(@"%@", [user objectForKey:@"email"]);
                         [self authentication:appDelegate.session.accessToken :user.id :[user objectForKey:@"email"] :user.name];
                         // self.userProfileImage.profileID = [user objectForKey:@"id"];
                     }
                 }];
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

-(void)authentication:(NSString*)token:(NSString*)uid:(NSString*)email:(NSString*)username{
    NSString *post = [NSString stringWithFormat:@"user[email]=%@&user[oauth_token]=%@&user[provider]=facebook&user[uid]=%@&user[username]=%@", email,token,uid,username];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
	
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSString*url= @"http:/test:test@trainingtest.herokuapp.com/api/v1/users/authentications";
    NSMutableURLRequest *request = [self LoginLocal:postData :postLength: url:@"POST"];
    [self getResponseData:request ];


}

- (IBAction)doBasicLogin:(id)sender {
    @try {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
        spinner.center = CGPointMake(160, 240);
        spinner.hidesWhenStopped = YES;
    
        [self.view addSubview:spinner];
    
        [spinner startAnimating];

        NSString *post = [NSString stringWithFormat:@"user[email]=%@&user[password]=%@", _email.text, _password.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
	
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSString*url= @"http:/test:test@trainingtest.herokuapp.com/api/v1/users/sign_in";
        NSMutableURLRequest *request = [self LoginLocal:postData :postLength: url:@"POST"];
        [self getResponseData:request ];
        [spinner stopAnimating];

        
    }
    @catch (NSException *exception) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:exception.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(NSMutableURLRequest*)LoginLocal:(NSData*)postData:(NSString*)postLength:(NSString*)url:(NSString*)method{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:method];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
    return request;

}

-(void)getResponseData:(NSMutableURLRequest*)request {
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (responseData) {
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&err];
         NSLog(@"responseData: %@", [res objectForKey:@"code"]);
        if ([[res objectForKey:@"code"] isEqualToString: @"API_SUCCESS" ]) {
            //[self performSegueWithIdentifier:@"local" sender:sender];
            showInforView *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showInforView"];
            [viewController setShoEmailText:_email.text ];
            [self presentModalViewController:viewController animated:YES];
        }
        else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"Opps Error %@", [res objectForKey:@"code"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        
        }
             
        
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

-(void)dismissPopover:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    //or better yet

}


@end
