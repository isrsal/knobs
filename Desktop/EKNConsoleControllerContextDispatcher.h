//
//  EKNConsoleControllerContextDispatcher.h
//  Knobs
//
//  Created by Akiva Leffert on 5/15/13.
//  Copyright (c) 2013 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EKNConsolePlugin.h"

// Simple bouncer to prevent a retain cycle

@interface EKNConsoleControllerContextDispatcher : NSObject <EKNConsoleControllerContext>

@property (weak, nonatomic) id <EKNConsoleControllerContext> delegate;

@end
