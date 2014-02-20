//
//  Utils.m
//  AMParser
//
//  Created by Zhou, Yuan on 2/20/14.
//  Copyright (c) 2014 Zhou, Yuan. All rights reserved.
//

#import "Utils.h"

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

@implementation Utils

+ (NSString *)unzipFile:(NSString *)filePath {
    // Unzip file
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/unzip"];
    
    NSArray *arguments;
    arguments = @[@"-o", filePath];
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
    
    NSRange startRange = [string rangeOfString:@"inflating: "];
    if (startRange.location == NSNotFound) {
        return ZIP_FAILED;
    }
    NSString *unzipedFile = [[string substringFromIndex:(startRange.location + startRange.length)] stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    printf ("\nunzip trace file:\n%s\n", [string UTF8String]);
    return unzipedFile;
}

@end
