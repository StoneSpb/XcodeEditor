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

#import "SXCTarget.h"

#import <XCTest/XCTest.h>

#import "SXCProject.h"
#import "SXCProjectBuildConfig.h"

@interface SXCTargetTests : XCTestCase
@end

@implementation SXCTargetTests
{
    SXCProject* _project;
}

- (void)setUp
{
    _project = [SXCProject projectWithFilePath:@"/tmp/XcodeEditorTests/expanz-iOS-SDK/expanz-iOS-SDK.xcodeproj"];
    NSLog(@"Targets: %@", [_project targets]);
}

- (void)test_allows_setting_name_and_product_name_target_properties
{
    SXCTarget* target = [_project targetWithName:@"expanzCore"];
    [target setName:@"foobar"];
    [target setProductName:@"foobar"];

    [_project save];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Build configuration. . .

- (void)test_allows_setting_build_configurations
{
    SXCProject* project = [SXCProject projectWithFilePath:@"/tmp/XcodeEditorTests/HelloBoxy/HelloBoxy.xcodeproj"];
    SXCTarget* target = [project targetWithName:@"HelloBoxy"];

    SXCProjectBuildConfig * configuration = [target configurationWithName:@"Debug"];
    NSLog(@"Here's the configuration: %@", configuration);
    id ldFlags = [configuration valueForKey:@"OTHER_LDFLAGS"];
    NSLog(@"ldflags: %@, %@", ldFlags, [ldFlags class]);
    [configuration addOrReplaceSetting:@"-lz -lxml2" forKey:@"OTHER_LDFLAGS"];
    [configuration addOrReplaceSetting:@[@"foo", @"bar"] forKey:@"HEADER_SEARCH_PATHS"];

    configuration = [target configurationWithName:@"Release"];
    NSLog(@"Here's the configuration: %@", configuration);
    ldFlags = [configuration valueForKey:@"OTHER_LDFLAGS"];
    NSLog(@"ldflags: %@, %@", ldFlags, [ldFlags class]);
    [configuration addOrReplaceSetting:@"-lz -lxml2" forKey:@"OTHER_LDFLAGS"];
    [configuration addOrReplaceSetting:@[@"foo", @"bar"] forKey:@"HEADER_SEARCH_PATHS"];

    [project save];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Duplication

- (void)test_allows_duplicating_a_target
{
    SXCProject* project = [SXCProject projectWithFilePath:@"/tmp/XcodeEditorTests/HelloBoxy/HelloBoxy.xcodeproj"];
    SXCTarget* target = [project targetWithName:@"HelloBoxy"];

    [target duplicateWithTargetName:@"DuplicatedTarget" productName:@"NewProduct"];
    [project save];
}

@end
