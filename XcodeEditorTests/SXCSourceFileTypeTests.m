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

#import "SXCXcodeFileType.h"

#import <XCTest/XCTest.h>

@interface SXCXcodeFileTypeTests : XCTestCase
@end

@implementation SXCXcodeFileTypeTests

- (void)test_return_a_file_reference_type_from_a_string
{
    XCTAssertTrue(SXCXcodeFileTypeFromStringRepresentation(@"sourcecode.c.h") == SXCXcodeFileTypeSourceCodeHeader);
    XCTAssertTrue(SXCXcodeFileTypeFromStringRepresentation(@"sourcecode.c.objc") == SXCXcodeFileTypeSourceCodeObjC);
}

- (void)test_creates_a_string_from_a_file_reference_type
{
    XCTAssertEqualObjects(SXCNSStringFromSXCXcodeFileType(SXCXcodeFileTypeSourceCodeHeader), @"sourcecode.c.h");
    XCTAssertEqualObjects(SXCNSStringFromSXCXcodeFileType(SXCXcodeFileTypeSourceCodeObjC), @"sourcecode.c.objc");
}

- (void)test_returns_file_type_from_file_name
{
    XCTAssertEqual(SXCXcodeFileTypeFromFileName(@"foobar.c"), SXCXcodeFileTypeSourceCodeObjC);
    XCTAssertEqual(SXCXcodeFileTypeFromFileName(@"foobar.m"), SXCXcodeFileTypeSourceCodeObjC);
    XCTAssertEqual(SXCXcodeFileTypeFromFileName(@"foobar.mm"), SXCXcodeFileTypeSourceCodeObjCPlusPlus);
    XCTAssertEqual(SXCXcodeFileTypeFromFileName(@"foobar.cpp"), SXCXcodeFileTypeSourceCodeCPlusPlus);
}

@end