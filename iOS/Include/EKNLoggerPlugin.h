//
//  EKNLoggerPlugin.h
//  Knobs-iOS
//
//  Created by Akiva Leffert on 5/14/13.
//  Copyright (c) 2013 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EKNDevicePlugin.h"

@interface EKNLoggerPlugin : NSObject <EKNDevicePlugin>

+ (EKNLoggerPlugin*)sharedLogger;

// params can be anything that implements NSCoding, but be careful about Desktop vs Device mismatches.
// Only use things in foundation. There is a special exception for UIImage and UIColor which are handled specially
- (void)logToChannel:(NSString*)channelName withRows:(NSArray*)params;
- (void)logToChannel:(NSString*)channelName withImage:(UIImage*)image;

@end
