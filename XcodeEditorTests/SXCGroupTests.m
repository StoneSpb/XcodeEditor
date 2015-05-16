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

#import "SXCGroup.h"

#import <XCTest/XCTest.h>

#import "NSString+SXCTestResource.h"
#import "SXCClassDefinition.h"
#import "SXCFrameworkDefinition.h"
#import "SXCProject.h"
#import "SXCSourceFile.h"
#import "SXCSourceFileDefinition.h"
#import "SXCSubProjectDefinition.h"
#import "SXCTarget.h"
#import "SXCXibDefinition.h"

@interface SXCFrameworkPath : NSObject
@end

@implementation SXCFrameworkPath

static const NSString* SDK_PATH =
    @"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.3.sdk";

+ (NSString*)eventKitUIPath
{
    return [SDK_PATH stringByAppendingPathComponent:@"/System/Library/Frameworks/EventKitUI.framework"];
}

+ (NSString*)coreMidiPath
{
    return [SDK_PATH stringByAppendingPathComponent:@"/System/Library/Frameworks/CoreMIDI.framework"];
}

@end

@interface SXCGroupTests : XCTestCase
@end

@implementation SXCGroupTests
{
    SXCProject* project;
    SXCGroup* group;
}

- (void)setUp
{
    project = [SXCProject projectWithFilePath:@"/tmp/XcodeEditorTests/expanz-iOS-SDK/expanz-iOS-SDK.xcodeproj"];
    group = [project groupWithPathFromRoot:@"Source/Main"];
    XCTAssertNotNil(group);
}

/* ================================================================================================================== */
#pragma mark - Object creation

- (void)test_allows_initialization_with
{
    SXCGroup* aGroup = [SXCGroup groupWithProject:project key:@"abcd1234" alias:@"Main" path:@"Source/Main" children:nil];

    XCTAssertNotNil(aGroup);
    XCTAssertEqualObjects([aGroup key], @"abcd1234");
    XCTAssertEqualObjects([aGroup alias], @"Main");
    XCTAssertEqualObjects([aGroup pathRelativeToParent], @"Source/Main");
    XCTAssertTrue([[aGroup members] count] == 0);
}

/* ================================================================================================================== */
#pragma mark - Properties . . . 

- (void)test_able_to_describe_itself
{
    XCTAssertEqualObjects([group description], @"Group: displayName = Main, key=6B469FE914EF875900ED659C");
}

- (void)test_able_to_return_its_full_path_relative_to_the_project_base_directory
{
    NSLog(@"############Path: %@", [group pathRelativeToProjectRoot]);
}

/* ================================================================================================================== */
#pragma mark - Adding obj-c source files.

- (void)test_allows_adding_a_source_file
{
    SXCClassDefinition* classDefinition = [SXCClassDefinition classDefinitionWithName:@"MyViewController"];

    [classDefinition setHeader:[NSString sxc_stringWithTestResource:@"ESA_Sales_Foobar_ViewController.header"]];
    [classDefinition setSource:[NSString sxc_stringWithTestResource:@"ESA_Sales_Foobar_ViewController.impl"]];

    NSLog(@"Class definition: %@", classDefinition);

    [group addClass:classDefinition];
    [project save];

    SXCSourceFile* fileResource = [project fileWithName:@"MyViewController.m"];
    XCTAssertNotNil(fileResource);
    XCTAssertEqualObjects([fileResource pathRelativeToProjectRoot], @"Source/Main/MyViewController.m");

    SXCTarget* examples = [project targetWithName:@"Examples"];
    XCTAssertNotNil(examples);
    [examples addMember:fileResource];

    fileResource = [project fileWithName:@"MyViewController.m"];
    XCTAssertTrue([fileResource isBuildFile]);

    [project save];
    NSLog(@"Done adding source file.");
}

- (void)test_provides_a_convenience_method_to_add_a_source_file_and_specify_targets
{
    SXCClassDefinition* classDefinition = [SXCClassDefinition classDefinitionWithName:@"AnotherClassAdded"];

    [classDefinition setHeader:[NSString sxc_stringWithTestResource:@"ESA_Sales_Foobar_ViewController.header"]];
    [classDefinition setSource:[NSString sxc_stringWithTestResource:@"ESA_Sales_Foobar_ViewController.impl"]];

    [group addClass:classDefinition toTargets:[project targets]];
    [project save];
}

- (void)test_returns_a_warning_if_an_existing_class_is_overwritten
{
    SXCClassDefinition* classDefinition = [SXCClassDefinition classDefinitionWithName:@"AddedTwice"];
    [classDefinition setHeader:[NSString sxc_stringWithTestResource:@"ESA_Sales_Foobar_ViewController.header"]];
    [classDefinition setSource:[NSString sxc_stringWithTestResource:@"ESA_Sales_Foobar_ViewController.impl"]];
    [group addClass:classDefinition toTargets:[project targets]];
    [project save];

    classDefinition = [SXCClassDefinition classDefinitionWithName:@"AddedTwice"];
    [classDefinition setHeader:[NSString sxc_stringWithTestResource:@"ESA_Sales_Foobar_ViewController.header"]];
    [classDefinition setSource:[NSString sxc_stringWithTestResource:@"ESA_Sales_Foobar_ViewController.impl"]];
    [group addClass:classDefinition toTargets:[project targets]];
    [project save];
}

- (void)test_allows_creating_a_reference_only_without_writing_to_disk
{
    SXCClassDefinition* classDefinition = [SXCClassDefinition classDefinitionWithName:@"ClassWithoutSourceFileYet"];
    [classDefinition setFileOperationType:SXCFileOperationTypeReferenceOnly];
    [group addClass:classDefinition toTargets:[project targets]];
    [project save];
}

/* ================================================================================================================== */
#pragma mark - adding objective-c++ files

- (void)test_allows_adding_files_of_type_obc_cPlusPlus
{
    SXCProject* anotherProject = [SXCProject projectWithFilePath:@"/tmp/XcodeEditorTests/HelloBoxy/HelloBoxy.xcodeproj"];
    SXCGroup* anotherGroup = [anotherProject groupWithPathFromRoot:@"Source"];

    SXCClassDefinition* classDefinition =
        [SXCClassDefinition classDefinitionWithName:@"HelloWorldLayer"
                                           language:SXCClassDefinitionLanguageObjectiveCPlusPlus];

    [classDefinition setHeader:[NSString sxc_stringWithTestResource:@"HelloWorldLayer.header"]];
    [classDefinition setSource:[NSString sxc_stringWithTestResource:@"HelloWorldLayer.impl"]];

    [anotherGroup addClass:classDefinition toTargets:[anotherProject targets]];
    [anotherProject save];
}

/* ================================================================================================================== */
#pragma mark - Adding CPP files

- (void)test__allows_using_a_class_definition_to_add_cpp_files
{
    SXCProject* anotherProject = [SXCProject projectWithFilePath:@"/tmp/XcodeEditorTests/HelloBoxy/HelloBoxy.xcodeproj"];
    SXCGroup* anotherGroup = [anotherProject groupWithPathFromRoot:@"Source"];

    SXCClassDefinition* definition =
        [SXCClassDefinition classDefinitionWithName:@"Person" language:SXCClassDefinitionLanguageCPlusPlus];
    [definition setSource:[NSString sxc_stringWithTestResource:@"Person.impl"]];

    [anotherGroup addClass:definition toTargets:[anotherProject targets]];
    [anotherProject save];
}

/* ================================================================================================================== */
#pragma mark - adding xib files.

- (void)test_should_allow_adding_a_xib_file
{
    NSString* xibText = [NSString sxc_stringWithTestResource:@"ESA.Sales.Foobar.xib"];
    SXCXibDefinition* xibDefinition = [SXCXibDefinition xibDefinitionWithName:@"AddedXibFile" content:xibText];

    [group addXib:xibDefinition];
    [project save];

    SXCSourceFile* xibFile = [project fileWithName:@"AddedXibFile.xib"];
    XCTAssertNotNil(xibFile);

    SXCTarget* examples = [project targetWithName:@"Examples"];
    XCTAssertNotNil(examples);
    [examples addMember:xibFile];

    xibFile = [project fileWithName:@"AddedXibFile.xib"];
    XCTAssertTrue([xibFile isBuildFile]);

    [project save];
    NSLog(@"Done adding xib file.");
}

- (void)test_provides_a_convenience_method_to_add_a_xib_file_and_specify_targets
{
    NSString* xibText = [NSString sxc_stringWithTestResource:@"ESA.Sales.Foobar.xib"];
    SXCXibDefinition* xibDefinition = [SXCXibDefinition xibDefinitionWithName:@"AnotherAddedXibFile" content:xibText];

    [group addXib:xibDefinition toTargets:[project targets]];
    [project save];
}

- (void)test_provides_an_option_to_accept_the_existing_file_if_it_exists
{
    NSString* newXibText = @"Don't blow away my contents if I already exists";
    SXCXibDefinition* xibDefinition = [SXCXibDefinition xibDefinitionWithName:@"AddedXibFile" content:newXibText];
    [xibDefinition setFileOperationType:SXCFileOperationTypeAcceptExisting];

    [group addXib:xibDefinition toTargets:[project targets]];
    [project save];

    NSString* xibContent = [NSString sxc_stringWithTestResource:@"expanz-iOS-SDK/Source/Main/AddedXibFile.xib"];
    NSLog(@"Xib content: %@", xibContent);
    XCTAssertNotEqualObjects(xibContent, newXibText);
}

/* ================================================================================================================== */
#pragma mark - adding frameworks

- (void)test_allows_adding_a_framework_on_the_system_volume
{
    SXCFrameworkDefinition* frameworkDefinition =
        [SXCFrameworkDefinition frameworkDefinitionWithFilePath:[SXCFrameworkPath eventKitUIPath] copyToDestination:NO];
    [group addFramework:frameworkDefinition toTargets:[project targets]];
    [project save];
}

- (void)test_allows_adding_a_framework_copying_it_to_the_destination_folder
{
    SXCFrameworkDefinition* frameworkDefinition =
        [SXCFrameworkDefinition frameworkDefinitionWithFilePath:[SXCFrameworkPath coreMidiPath] copyToDestination:YES];
    [group addFramework:frameworkDefinition toTargets:[project targets]];
    [project save];
}

/* ================================================================================================================== */
#pragma mark - adding xcodeproj files

- (void)test_allows_adding_a_xcodeproj_file
{
    SXCSubProjectDefinition* projectDefinition =
        [SXCSubProjectDefinition subProjectDefinitionWithName:@"HelloBoxy"
                                                        path:@"/tmp/XcodeEditorTests/HelloBoxy"
                                               parentProject:project];

    [group addSubProject:projectDefinition];
    [project save];

}

- (void)test_provides_a_convenience_method_to_add_a_xcodeproj_file_and_specify_targets
{
    SXCSubProjectDefinition* xcodeprojDefinition =
        [SXCSubProjectDefinition subProjectDefinitionWithName:@"ArchiveProj"
                                                        path:@"/tmp/XcodeEditorTests/ArchiveProj"
                                               parentProject:project];

    [group addSubProject:xcodeprojDefinition toTargets:[project targets]];
    [project save];
}

#pragma mark - removing xcodeproj files

- (void)test_allows_removing_an_xcodeproj_file
{
//    XCSubProjectDefinition* xcodeprojDefinition =
//        [XCSubProjectDefinition withName:@"HelloBoxy" path:@"/tmp/XcodeEditorTests/HelloBoxy" parentProject:project];
//
//    [group removeSubProject:xcodeprojDefinition];
//    [project save];
}

- (void)test_allows_removing_an_xcodeproj_file_and_specify_targets
{
//    XCSubProjectDefinition* xcodeprojDefinition =
//        [XCSubProjectDefinition withName:@"ArchiveProj"
//                                    path:@"/tmp/XcodeEditorTests/ArchiveProj"
//                           parentProject:project];
//
//    [group addSubProject:xcodeprojDefinition toTargets:[project targets]];
//    [project save];
//
//    xcodeprojDefinition = [XCSubProjectDefinition withName:@"ArchiveProj"
//                                                      path:@"/tmp/XcodeEditorTests/ArchiveProj"
//                                             parentProject:project];
//
//    [group removeSubProject:xcodeprojDefinition fromTargets:[project targets]];
//
//    [project save];
}

/* ================================================================================================================== */
#pragma mark - Adding other types

- (void)test_allows_adding_a_group
{
    [group addGroupWithPath:@"TestGroup"];
    [project save];
}

- (void)test_should_allows_adding_a_header
{
    SXCSourceFileDefinition* header =
        [SXCSourceFileDefinition sourceDefinitionWithName:@"SomeHeader.h"
                                                    text:@"@protocol Foobar<NSObject> @end"
                                                    type:SXCXcodeFileTypeSourceCodeHeader];
    [group addSourceFile:header];
    [project save];
}

- (void)test_allows_adding_an_image_file
{
    NSData* data = [NSData dataWithContentsOfFile:@"/tmp/XcodeEditorTests/goat-funny.png"];
    SXCSourceFileDefinition* sourceFileDefinition =
        [SXCSourceFileDefinition sourceDefinitionWithName:@"MyImageFile.png"
                                                    data:data
                                                    type:SXCXcodeFileTypeImageResourcePNG];
    [group addSourceFile:sourceFileDefinition];
    [project save];
}

/* ================================================================================================================== */
#pragma mark - Listing members
- (void)test_able_to_provide_a_sorted_list_of_its_children
{
    NSArray* children = [group members];
    NSLog(@"Group children: %@", children);
    XCTAssertFalse([children count] == 0);
}

- (void)test_able_to_return_a_member_by_its_name
{
    SXCGroup* anotherGroup = [project groupWithPathFromRoot:@"Source/Main/Core/Model"];
    SXCSourceFile* member = [anotherGroup memberWithDisplayName:@"expanz_model_AppSite.m"];
    XCTAssertNotNil(member);
}

- (void)test_able_to_list_all_of_its_members_recursively
{
    NSLog(@"Let's get recursive members!!!!");
    NSArray* recursiveMembers = [group recursiveMembers];
    NSLog(@"$$$$$$$$$$$$$$$**********$*$*$*$*$*$* recursive members: %@", recursiveMembers);
}

/* ================================================================================================================== */
#pragma mark - Deleting

- (void)test_allows_deleting_a_group_optionally_removing_also_the_contents
{
    SXCGroup* aGroup = [project groupWithPathFromRoot:@"Source/Main/UserInterface/Components"];

    NSArray* groups = [project groups];
    NSLog(@"Groups now: %@", groups);

    [aGroup removeFromParentDeletingChildren:YES];
    [project save];

    groups = [project groups];
    NSLog(@"Groups now: %@", groups);

    SXCGroup* deleted = [project groupWithPathFromRoot:@"Source/Main/UserInterface/Components"];
    XCTAssertNil(deleted);
}

@end
