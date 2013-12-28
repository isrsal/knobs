//
//  EKNSourceManager.m
//  Knobs
//
//  Created by Akiva Leffert on 12/27/13.
//  Copyright (c) 2013 Akiva Leffert. All rights reserved.
//

#import "EKNSourceManager.h"

#import "EKNPropertyDescription+EKNCodeConstruction.h"

@implementation EKNSourceManager

+ (EKNSourceManager*)sharedManager {
    static dispatch_once_t onceToken;
    static EKNSourceManager* manager;
    dispatch_once(&onceToken, ^{
        manager = [[EKNSourceManager alloc] init];
    });
    return manager;
}

// This code is dumb as bricks.
// Long term we should consider picking up libclang
// Or at least write a slightly less dumb lexer
// Though it may not be worth the dependency/potential integration issues
- (BOOL)saveCode:(NSString*)code withKnobName:(NSString*)name toFileAtPath:(NSString*)path error:(__autoreleasing NSError**)error {
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:error];
    if(error && *error) {
        return YES;
    }
    
    NSString* pattern = [NSString stringWithFormat:@"EKNMake([a-zA-Z0-9_]+)\\(([ :a-zA-Z.0-9_]+),\\s(%@)\\sEKNBreak", name];
    
    NSRegularExpression* expression = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:error];
    if(error && *error) {
        return YES;
    }
    NSString* template = [NSString stringWithFormat:@"EKNMake$1($2, %@ EKNBreak", code];
    NSString* outContents = [expression stringByReplacingMatchesInString:fileContents options:0 range:NSMakeRange(0, fileContents.length) withTemplate:template];
    [outContents writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:error];
    if(error && *error) {
        return YES;
    }
    return NO;
}

- (BOOL)saveValue:(id)value withDescription:(EKNPropertyDescription*)description toFileAtPath:(NSString*)path error:(__autoreleasing NSError**)error {
    NSString* code = [description constructorCodeForValue:value];
    return [self saveCode:code withKnobName:description.name toFileAtPath:path error:error];
}

@end
