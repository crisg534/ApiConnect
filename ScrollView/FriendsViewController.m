//
//  FriendsViewController.m
//  ScrollView
//
//  Created by LaptopKoom on 25/10/12.
//  Copyright (c) 2012 LaptopKoom. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCell.h"
@interface FriendsViewController ()

@end

@implementation FriendsViewController
//@synthesize friends;
@synthesize friendslist;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    name = [[NSMutableArray alloc] init];
	picture = [[NSMutableArray alloc] init];
	uid = [[NSMutableArray alloc] init];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [name count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FriendsCell *cell = (FriendsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[FriendsCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    cell.name.text = [name objectAtIndex:[indexPath row]];
    cell.uid.text = [uid objectAtIndex:[indexPath row]];
    NSLog(@"test aa %@",[name objectAtIndex:[indexPath row]]);
    cell.picture.image =[self get_image:[picture objectAtIndex:[indexPath row]]];
    
    // Configure the cell...
    
    return cell;
}

-(UIImage*)get_image:(NSString*)url{
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage*image = [UIImage imageWithData:data ];
    return image;
}

-(IBAction)GetFriendsList:(NSDictionary *)friends_list{
    friends = friends_list;
    NSLog(@"testt %@",friends);

  
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)getData

{
     NSLog(@"test aa %@",friendslist);
    NSLog(@"test aa %@",friends);
    for (id data in  friends) {
        [name addObject:[data objectForKey:@"data"][@"name"]];
        [uid addObject:[data objectForKey:@"data"][@"id"]];
        [picture addObject:[data objectForKey:@"data"][@"picture"][@"data"][@"url"]];
    }
        
    [self.tableView reloadData];
    
    
}

@end
