//
//  FriendsViewController.h
//  ScrollView
//
//  Created by LaptopKoom on 25/10/12.
//  Copyright (c) 2012 LaptopKoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UITableViewController{
    NSMutableArray *name;
	NSMutableArray *uid;
	NSMutableArray *picture;
    NSDictionary*friends;

}
@property (strong, nonatomic) NSDictionary*friends;
@property (strong, nonatomic) NSDictionary*friendslist;

-(IBAction)GetFriendsList:(NSDictionary*)friends;
@end
