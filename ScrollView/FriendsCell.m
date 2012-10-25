//
//  FriendsCell.m
//  ScrollView
//
//  Created by LaptopKoom on 25/10/12.
//  Copyright (c) 2012 LaptopKoom. All rights reserved.
//

#import "FriendsCell.h"

@implementation FriendsCell
@synthesize picture = _picture;
@synthesize name = _name;
@synthesize uid = _uid;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
