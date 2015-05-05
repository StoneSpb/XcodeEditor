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


#import <XCTest/XCTest.h>
#import "XCProject.h"
#import "XCSubProjectDefinition.h"

@interface XCSubProjectDefinitionTests : XCTestCase
@end

@implementation XCSubProjectDefinitionTests
{
    XCProject* _project;
}


- (void)setUp
{
    _project = [XCProject projectWithFilePath:@"/tmp/expanz-iOS-SDK/expanz-iOS-SDK.xcodeproj"];
}

#pragma mark - object creation

- (void)test_allows_initialization_with_name_and_path
{

    XCSubProjectDefinition
        * subProjectDefinition = [XCSubProjectDefinition subProjectDefinitionWithName:@"HelloBoxy"
                                                                                 path:@"/tmp/HelloBoxy"
                                                                        parentProject:_project];

    XCTAssertNotNil(subProjectDefinition);
    XCTAssertEqualObjects(subProjectDefinition.projectFileName, @"HelloBoxy.xcodeproj");


}


@end