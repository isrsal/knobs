//
//  EKNKnobSliderEditor.m
//  Knobs
//
//  Created by Akiva Leffert on 5/17/13.
//  Copyright (c) 2013 Akiva Leffert. All rights reserved.
//

#import "EKNKnobSliderEditor.h"

#import "EKNPropertyDescription.h"
#import "EKNPropertyInfo.h"

@interface EKNKnobSliderEditor ()

@property (strong, nonatomic) IBOutlet NSSlider* slider;
@property (strong, nonatomic) IBOutlet NSTextField* fieldName;
@property (strong, nonatomic) IBOutlet NSTextField* currentValue;
@property (strong, nonatomic) IBOutlet NSTextField* minValue;
@property (strong, nonatomic) IBOutlet NSTextField* maxValue;

@end

@implementation EKNKnobSliderEditor

@synthesize info = _info;
@synthesize delegate = _delegate;

- (void)setInfo:(EKNPropertyInfo *)info {
    _info = info;
    self.slider.minValue = [[info.propertyDescription.parameters objectForKey:@(EKNPropertySliderMin)] floatValue];
    self.slider.maxValue = [[info.propertyDescription.parameters objectForKey:@(EKNPropertySliderMax)] floatValue];
    self.slider.continuous = [[info.propertyDescription.parameters objectForKey:@(EKNPropertySliderContinuous)] boolValue];
    self.slider.floatValue = [info.value floatValue];
    self.minValue.floatValue = self.slider.minValue;
    self.maxValue.floatValue = self.slider.maxValue;
    self.fieldName.stringValue = info.propertyDescription.name;
    self.currentValue.floatValue = self.slider.floatValue;
}

- (IBAction)changedSlider:(id)sender {
    [self.delegate propertyEditor:self changedProperty:self.info.propertyDescription toValue:@(self.slider.floatValue)];
    self.currentValue.floatValue = self.slider.floatValue;
}

@end
