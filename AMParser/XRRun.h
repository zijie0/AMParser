//
//  XRRun.h
//  AMParser
//
//  Created by Zhou, Yuan on 1/10/14.
//  Copyright (c) 2014 Zhou, Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XRRun : NSObject
{
    NSDateFormatter *dateFormatter;
	NSUInteger runNumber;
	NSTimeInterval startTime;
	NSTimeInterval endTime;
	
	NSMutableArray *trackSegments;
	NSMutableDictionary *runData;
	
    NSNumber *pid;
    BOOL launchControlProperties;
    BOOL args;
	BOOL envVals;
	BOOL execname;
	BOOL terminateTaskAtStop;
}

@end

@interface XRActivityInstrumentRun : XRRun
{
	NSMutableArray *sampleData;
}

@end
