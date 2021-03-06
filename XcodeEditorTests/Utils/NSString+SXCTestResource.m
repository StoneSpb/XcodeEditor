////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSString+SXCTestResource.h"

@implementation NSString (SXCTestResource)

+ (NSString*)sxc_stringWithTestResource:(NSString*)resourceName
{
    NSString* filePath = [@"/tmp/XcodeEditorTests" stringByAppendingPathComponent:resourceName];
    NSError* error = nil;
    NSString* contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (!contents)
    {
        [NSException raise:NSInvalidArgumentException format:@"No test resource named '%@'", filePath];
    }
    return contents;
}

@end
