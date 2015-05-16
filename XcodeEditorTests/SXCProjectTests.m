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

#import "SXCProject.h"

#import <XCTest/XCTest.h>

#import "SXCSourceFile.h"
#import "SXCTarget.h"
#import "SXCGroup.h"

@interface SXCProjectTests : XCTestCase

@end

@implementation SXCProjectTests
{
    __block SXCProject* project;
}

/* ================================================================================================================== */
- (void)setUp
{
    project = [SXCProject projectWithFilePath:@"/tmp/XcodeEditorTests"];
}

/* ================================================================================================================== */
#pragma mark - Listing files

- (void)test_able_to_list_all_the_header_files_in_a_project
{
    NSArray* headerFiles = [project headerFiles];
    NSLog(@"Headers: %@", headerFiles);

    XCTAssertTrue([headerFiles count] == 18);
    for (SXCSourceFile* file in headerFiles)
    {
        NSLog(@"File: %@", [file description]);
    }
}

- (void)test_able_to_list_all_the_obj_c_files_in_a_project
{
    NSArray* objcFiles = [project objectiveCFiles];
    NSLog(@"Implementation Files: %@", objcFiles);

    XCTAssertTrue([objcFiles count] == 21);
}

- (void)test_able_to_list_all_the_obj_cPlusPlus_files_in_a_project
{
    NSArray* objcPlusPlusFiles = [project objectiveCPlusPlusFiles];
    NSLog(@"Implementation Files: %@", objcPlusPlusFiles);

    //TODO: Put an obj-c++ file in the test project.
    XCTAssertTrue([objcPlusPlusFiles count] == 0);
}

- (void)test_be_able_to_list_all_the_xib_files_in_a_project
{
    NSArray* xibFiles = [project xibFiles];
    NSLog(@"Xib Files: %@", xibFiles);
    XCTAssertTrue([xibFiles count] == 2);
}

/* ================================================================================================================== */
#pragma mark - Groups

- (void)test_able_to_list_all_of_the_groups_in_a_project
{
    NSArray* groups = [project groups];

    for (SXCGroup* group in groups)
    {
        NSLog(@"Name: %@, full path: %@", [group displayName], [group pathRelativeToProjectRoot]);
        for (id <SXCXcodeGroupMember> member  in [group members])
        {
            NSLog(@"\t%@", [member displayName]);
        }
    }

    XCTAssertNotNil(groups);
    XCTAssertFalse([groups count] == 0);
}

- (void)test_provides_access_to_the_root_top_level_group
{
    SXCGroup* rootGroup = [project rootGroup];
    NSLog(@"Here the group: %@", rootGroup);
    XCTAssertFalse([rootGroup.members count] == 0);
}

- (void)test_provides_a_way_to_locate_a_group_from_its_path_to_the_root_group
{
    SXCGroup* group = [project groupWithPathFromRoot:@"Source/Main/Assembly"];
    XCTAssertNotNil(group);
    NSLog(@"Group: %@", group);
}

/* ================================================================================================================== */
#pragma mark - Targets

- (void)test_able_to_list_the_targets_in_an_xcode_project
{
    NSArray* targets = [project targets];
    for (SXCTarget* target in [project targets])
    {
        NSLog(@"%@", target);
    }
    XCTAssertNotNil(targets);
    XCTAssertFalse([targets count] == 0);

    for (SXCTarget* target in targets)
    {
        NSArray* members = [target members];
        NSLog(@"Members: %@", members);
    }
}

@end
