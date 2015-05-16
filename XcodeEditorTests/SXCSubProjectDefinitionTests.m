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

#import "SXCSubProjectDefinition.h"

#import <XCTest/XCTest.h>

#import "SXCProject.h"

@interface SXCSubProjectDefinitionTests : XCTestCase
@end

@implementation SXCSubProjectDefinitionTests
{
    SXCProject* _project;
}

- (void)setUp
{
    _project = [SXCProject projectWithFilePath:@"/tmp/XcodeEditorTests/expanz-iOS-SDK/expanz-iOS-SDK.xcodeproj"];
}

#pragma mark - object creation

- (void)test_allows_initialization_with_name_and_path
{
    SXCSubProjectDefinition
        * subProjectDefinition = [SXCSubProjectDefinition subProjectDefinitionWithName:@"HelloBoxy"
                                                                                 path:@"/tmp/XcodeEditorTests/HelloBoxy"
                                                                        parentProject:_project];

    XCTAssertNotNil(subProjectDefinition);
    XCTAssertEqualObjects(subProjectDefinition.projectFileName, @"HelloBoxy.xcodeproj");
}

@end
