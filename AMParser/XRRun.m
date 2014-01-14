//
//  XRRun.m
//  AMParser
//
//  Created by Zhou, Yuan on 1/10/14.
//  Copyright (c) 2014 Zhou, Yuan. All rights reserved.
//

#import "XRRun.h"

#define targetProcess @"MicroStrategy"

@implementation XRRun

- (id)initWithCoder:(NSCoder *)decoder
{
	if((self = [super init]))
	{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
		startTime = [[decoder decodeObject] doubleValue];
		endTime   = [[decoder decodeObject] doubleValue];
		runNumber = [[decoder decodeObject] unsignedIntegerValue];
		
        // retain?
		trackSegments = [decoder decodeObject];
		
		// Totally not sure about these
		envVals = [[decoder decodeObject] boolValue];
		execname = [[decoder decodeObject] boolValue];
		terminateTaskAtStop = [[decoder decodeObject] boolValue];
        pid = [decoder decodeObject][@"_pid"];
        launchControlProperties = [[decoder decodeObject] boolValue];
		args = [[decoder decodeObject] boolValue];
	}
	
	return self;
}

- (void)dealloc
{
}


@end

@implementation XRActivityInstrumentRun


- (NSString *)formattedSample:(NSUInteger)index
{
	NSDictionary *data = sampleData[index];
    NSMutableString *result = [NSMutableString string];
    double relativeTimestamp = [data[@"XRActivityClientTraceRelativeTimestamp"] doubleValue];
	double seconds = relativeTimestamp / 1000.0 / 1000.0 / 1000.0;
    NSTimeInterval timestamp = startTime + seconds;
    [result appendFormat:@"Process: %@ ", targetProcess];
    
    NSArray *processData = data[@"Processes"];
    for (NSDictionary *process in processData) {
        if ([process[@"Command"] isEqualToString:targetProcess]) {
            double cpuUsage = [process[@"CPUUsage"] doubleValue];
            double residentSize = [process[@"ResidentSize"] doubleValue] / 1024;
            double virtualSize = [process[@"VirtualSize"] doubleValue] / 1024;
            [result appendFormat:@"CPU Usage: %.2f%% ", cpuUsage];
            [result appendFormat:@"Res Size: %.2f KiB ", residentSize];
            [result appendFormat:@"Virt Size: %.2f KiB ", virtualSize];
            break;
        }
    }
	[result appendFormat:@"Timestamp: %@ ", [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]]];
	
	return result;
}

- (NSString *)description
{
	NSString *start = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startTime]];
	NSString *end = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endTime]];
	
	NSMutableString *result = [NSMutableString stringWithFormat:@"Run %u, starting at %@, running until %@\n", (unsigned int)runNumber, start, end];
	
	for(NSUInteger i=0; i<[sampleData count]; i++)
	{
		[result appendFormat:@"Sample %u: %@\n", (unsigned int)i, [self formattedSample:i]];
	}
	
	return result;
}



- (id)initWithCoder:(NSCoder *)decoder
{
	if((self = [super initWithCoder:decoder]))
	{
		// retain?
		sampleData = [decoder decodeObject];
		
		// One more object...
		[decoder decodeObject];
	}
	
	return self;
}

- (void)dealloc
{
}

@end
