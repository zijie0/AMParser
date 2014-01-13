//
//  PFTTrackSegment.m
//  AMParser
//
//  Created by Zhou, Yuan on 1/10/14.
//  Copyright (c) 2014 Zhou, Yuan. All rights reserved.
//

#import "PFTTrackSegment.h"

@implementation PFTTrackSegment

- (id)initWithCoder:(NSCoder *)decoder
{
	if((self = [super init]))
	{
		[decoder decodeObject];
		[decoder decodeObject];
        [decoder decodeObject];
		
		// In seconds
		durationTime = [[decoder decodeObject] doubleValue];
		
		[decoder decodeObject];
	}
	
	return self;
}

@end

@implementation XRTrackSegment

- (id)initWithCoder:(NSCoder *)decoder
{
	if((self = [super initWithCoder:decoder]))
	{
	}
	
	return self;
}

@end

