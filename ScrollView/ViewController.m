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
@synthesize username =_username;
@synthesize user_email = _user_email;
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
                
                [[[FBRequest alloc] initWithSession:session graphPath:@"me?fields=id,name,email,picture"] startWithCompletionHandler:
                 ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                     if (!error) {
                         self.txtfb.text = user.name;
                         [self authentication:appDelegate.session.accessToken :user.id :[user objectForKey:@"email"] :user.name:[user objectForKey:@"picture"][@"data"][@"url"]];
                         // self.userProfileImage.profileID = [user objectForKey:@"id"];
                     }
                 }];
                [self updateView];
            }];
        }
    }

}

-(void)setUser_email:(NSString *)user_email{
    _user_email=user_email;
}

-(void)setUsername:(NSString *)username{
    _username = username;
}

-(void)updateView{
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        UIImage *img = [UIImage imageNamed:@"BlueButton.png"];
        [self.fbutton setTitle:@"Log out" forState:UIControlStateNormal];
        
        [self.fbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.fbutton setBackgroundImage:img forState:UIControlStateNormal];
        
        [self.txtfb setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",appDelegate.session.accessToken]];
        

    } else {
        // login-needed account UI is shown whenever the session is closed
        UIImage *img = [UIImage imageNamed:@"X-Large_278x44_glowy.png"];
        [self.fbutton setBackgroundImage:img forState:UIControlStateNormal];
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

-(void)authentication:(NSString*)token:(NSString*)uid:(NSString*)email:(NSString*)username:(NSString*)picture{
    NSString *post = [NSString stringWithFormat:@"user[email]=%@&user[oauth_token]=%@&user[provider]=facebook&user[uid]=%@&user[username]=%@", email,token,uid,username];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
	
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSString*url= @"http:/test:test@trainingtest.herokuapp.com/api/v1/users/authentications";
    NSMutableURLRequest *request = [self LoginLocal:postData :postLength: url:@"POST"];
    [self getResponseData:request:email:username:picture ];


}

- (IBAction)doBasicLogin:(id)sender {
    @try {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
        
        [spinner setCenter:CGPointMake(160, 240)];
        [self.view addSubview:spinner];
    
        [spinner startAnimating];

        NSString *post = [NSString stringWithFormat:@"user[email]=%@&user[password]=%@", _email.text, _password.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
	
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSString*url= @"http:/test:test@trainingtest.herokuapp.com/api/v1/users/sign_in";
        NSMutableURLRequest *request = [self LoginLocal:postData :postLength: url:@"POST"];
        [self getResponseData:request:_email.text:_username:@"" ];
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
	_user_email = _email.text;
    return request;

}

-(void)getResponseData:(NSMutableURLRequest*)request:(NSString*)email:(NSString*)usename:(NSString*)picture {
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (responseData) {
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&err];
         NSLog(@"responseData: %@", [res objectForKey:@"code"]);
        if ([[res objectForKey:@"code"] isEqualToString: @"API_SUCCESS" ] || [[res objectForKey:@"code"] isEqualToString: @"API_USER_SIGNED_IN" ]  || [[res objectForKey:@"code"] isEqualToString: @"API_USER_CREATED" ] )
        {

       
            //[self performSegueWithIdentifier:@"local" sender:sender];
            showInforView *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showInforView"];
            
            [viewController setShoEmailText:email:usename:picture ];
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
        //[viewController setShoEmailText:_email.text:_username:@"" ];
       
        
    }
    
}

-(void)dismissPopover:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    //or better yet

}


@end
