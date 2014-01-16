//
//  main.m
//  AMParser
//
//  Created by Zhou, Yuan on 1/10/14.
//  Copyright (c) 2014 Zhou, Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XRRun.h"

#define templateUDID @"E3BF39BB-8DCB-4D12-BDC7-DC7D678EB5F3"

@implementation NSString (TrimmingAdditions)

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (location; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (length; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

@end

int main(int argc, const char *argv[])
{
	@autoreleasepool
	{
        if (argc < 2)
        {
            printf("Please specify the trace file!\n");
            exit(1);
        }
        
        NSString *workihngDic = [[NSBundle mainBundle] bundlePath];
        
        NSString *inputTraceFile = [[NSString stringWithUTF8String:argv[1]] stringByExpandingTildeInPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *resultZipFile = [NSString stringWithFormat:@"%@/instrument_data/%@/run_data/1.run.zip", inputTraceFile, templateUDID];
        NSString *resultUnzippedFile = [NSString stringWithFormat:@"%@%@/instrument_data/%@/run_data/1.run",workihngDic, inputTraceFile, templateUDID];
        
        if (![fileManager fileExistsAtPath:resultZipFile])
        {
            printf("No Activity Manager trace result found!\n");
            exit(1);
        }
        
        // Unzip file
        NSTask *task;
        task = [[NSTask alloc] init];
        [task setLaunchPath: @"/usr/bin/unzip"];
        
        NSArray *arguments;
        arguments = @[@"-o", resultZipFile];
        [task setArguments: arguments];
        
        NSPipe *pipe;
        pipe = [NSPipe pipe];
        [task setStandardOutput: pipe];
        
        NSFileHandle *file;
        file = [pipe fileHandleForReading];
        
        [task launch];
        
        NSData *data;
        data = [file readDataToEndOfFile];
        
        NSString *string;
        string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        
//        NSRange startRange = [string rangeOfString:@"inflating: "];
//        NSString *unzipedFile = [[string substringFromIndex:(startRange.location + startRange.length)] stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        printf ("\nunzip trace file:\n%s\n", [string UTF8String]);
        
		// Read the trace file into memory
		NSURL *traceFile = [NSURL fileURLWithPath:[resultUnzippedFile stringByExpandingTildeInPath]];
		NSData *traceData = [NSData dataWithContentsOfURL:traceFile];
		
		// Deserialize the data and dump its content
		XRActivityInstrumentRun *run = [NSUnarchiver unarchiveObjectWithData:traceData];
		printf("\n%s\n", [[run description] UTF8String]);
	}
	
    return 0;
}