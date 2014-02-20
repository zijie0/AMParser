//
//  Utils.h
//  AMParser
//
//  Created by Zhou, Yuan on 2/20/14.
//  Copyright (c) 2014 Zhou, Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ZIP_FAILED @"Unzip Failed"

@interface Utils : NSObject
+ (NSString *)unzipFile:(NSString *)filePath;
@end
