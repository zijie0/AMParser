//
//  main.m
//  AMParser
//
//  Created by Zhou, Yuan on 1/10/14.
//  Copyright (c) 2014 Zhou, Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XRRun.h"
#import "Utils.h"

//#define templateUDID @"E3BF39BB-8DCB-4D12-BDC7-DC7D678EB5F3"
#define templateUDID @"2DFBB7CF-2B32-41D6-9FA6-73CF813DFC24"


int main(int argc, const char *argv[])
{
	@autoreleasepool
	{
        if (argc < 2)
        {
            printf("Please specify the trace file!\n");
            exit(1);
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *workihngDic = [fileManager currentDirectoryPath];
        
        NSString *inputTraceFile = [[NSString stringWithUTF8String:argv[1]] stringByExpandingTildeInPath];
        NSString *resultZipDirectory = [NSString stringWithFormat:@"%@/instrument_data/%@/run_data", inputTraceFile, templateUDID];
        
        NSError *error;
        NSArray * directoryContents = [fileManager contentsOfDirectoryAtPath:resultZipDirectory error:&error];
        
        if (error) {
            printf("No Activity Manager trace result found!\n");
            exit(1);
        }
        
        for (NSString *zipFile in directoryContents) {
            NSString *unzipedFile = [Utils unzipFile:[NSString stringWithFormat:@"%@/%@",resultZipDirectory, zipFile]];
            if (![unzipedFile isEqualToString:ZIP_FAILED]) {
                NSString *resultUnzippedFile = [NSString stringWithFormat:@"%@/%@",workihngDic, unzipedFile];
                
                // Read the trace file into memory
                NSURL *traceFile = [NSURL fileURLWithPath:[resultUnzippedFile stringByExpandingTildeInPath]];
                NSData *traceData = [NSData dataWithContentsOfURL:traceFile];
                
                // Deserialize the data and dump its content
                XRActivityInstrumentRun *run = [NSUnarchiver unarchiveObjectWithData:traceData];
                printf("\n%s\n", [[run description] UTF8String]);
            }
        }
	}
	
    return 0;
}