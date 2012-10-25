//
//  showInforView.m
//  ScrollView
//
//  Created by LaptopKoom on 24/10/12.
//  Copyright (c) 2012 LaptopKoom. All rights reserved.
//

#import "showInforView.h"
#import "AppDelegate.h"
#import "FriendsViewController.h"
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
    _showUsername.text = [NSString stringWithFormat:@"username: %@", _user_name];
    _my_picture.image = [self get_image:_user_picture];
    
	// Do any additional setup after loading the view.
}

-(UIImage*)get_image:(NSString*)url{
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage*image = [UIImage imageWithData:data ];
    return image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setShoEmailText:(NSString *)txt:(NSString *)username:(NSString*)picture{
    _txt = txt;
    _user_name = username;
    _user_picture = picture;
}

- (IBAction)doShowFriends:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        [[[FBRequest alloc] initWithSession:appDelegate.session graphPath:@"me?fields=friends"] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 _friends = [[NSDictionary alloc]initWithDictionary:[user objectForKey:@"friends"][@"data"]];
                 [self performSegueWithIdentifier:@"friendslist" sender:self];
                 // self.userProfileImage.profileID = [user objectForKey:@"id"];
             }
         }];
        
    }

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier]
         isEqualToString:@"friendslist"]){
        
        FriendsViewController *viewController = [segue destinationViewController];
        [viewController GetFriendsList:_friends];
        //[viewController setShoEmailText:_email.text:_username:@"" ];
        
        
    }
    
}
@end
