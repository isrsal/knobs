//
//  EKNPropertyDescription.h
//  Knobs-iOS
//
//  Created by Akiva Leffert on 5/17/13.
//  Copyright (c) 2013 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* EKNPropertyTypeColor;
NSString* EKNPropertyTypeToggle;
NSString* EKNPropertyTypeSlider;

//TODO decide whether it's actually a good idea to use int keys
enum {
    EKNPropertySliderMin,
    EKNPropertySliderMax,
    EKNPropertySliderContinuous,
};

@interface EKNPropertyDescription : NSObject <NSCoding>

+ (EKNPropertyDescription*)propertyWithName:(NSString*)name type:(NSString*)type parameters:(NSDictionary*)parameters;
+ (EKNPropertyDescription*)colorPropertyWithName:(NSString*)name;
+ (EKNPropertyDescription*)togglePropertyWithName:(NSString*)name;
+ (EKNPropertyDescription*)continuousSliderPropertyWithName:(NSString*)name min:(CGFloat)min max:(CGFloat)max;

@property (readonly, copy) NSString* name;
@property (readonly, copy) NSString* type;
@property (readonly, copy) NSDictionary* parameters;

- (id)getValueFromSource:(id)source;
- (void)setValue:(id)value ofSource:(id)source;

@end
