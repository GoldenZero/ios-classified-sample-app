//
//  Configuration.m
//  CustomDropDownList
//
//  Created by Nick Marchenko on 21.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

@synthesize buttonActiveBG;
@synthesize buttonNoActiveBG;
@synthesize itemBGHoved;
@synthesize itemBG;
@synthesize openBGTop;
@synthesize openBGMiddle;
@synthesize openBGBottom;

- (id) init
{
	if (self = [super init])
	{
		self.buttonActiveBG = [UIImage imageNamed:@"location_whiteButton_01.png"];
		self.buttonNoActiveBG = [UIImage imageNamed:@"location_whiteButton_01.png"];
		self.itemBGHoved = [UIImage imageNamed:@"location_whiteButton_02.png"];
		self.itemBG = [UIImage imageNamed:@"open-dropdown-bg-inner.png"];
		self.openBGTop = [UIImage imageNamed:@""];
		self.openBGMiddle = [UIImage imageNamed:@""];
		self.openBGBottom = [UIImage imageNamed:@""];

	}
	return self;
}

- (void) dealloc
{
	[buttonActiveBG release];
	[buttonNoActiveBG release];
	[itemBGHoved release];
	[itemBG release];
	[openBGTop release];
	[openBGMiddle release];
	[openBGBottom release];
	
	[super dealloc];
}
@end
