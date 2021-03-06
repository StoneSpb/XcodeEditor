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

#import <Foundation/Foundation.h>

#import "SXCAbstractDefinition.h"

@interface SXCXibDefinition : SXCAbstractDefinition
{
    NSString* _name;
    NSString* _content;
}

@property(nonatomic, strong, readonly) NSString* name;
@property(nonatomic, strong) NSString* content;

+ (instancetype)xibDefinitionWithName:(NSString*)name;
+ (instancetype)xibDefinitionWithName:(NSString*)name content:(NSString*)content;

- (NSString*)xibFileName;

@end
