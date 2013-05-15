//
//  EKNPanelWindowController.m
//  Knobs
//
//  Created by Akiva Leffert on 5/13/13.
//  Copyright (c) 2013 Akiva Leffert. All rights reserved.
//

#import "EKNPanelWindowController.h"

#import "EKNConsoleControllerContextDispatcher.h"
#import "EKNConsolePlugin.h"
#import "EKNConsolePluginRegistry.h"
#import "EKNDevice.h"
#import "EKNDeviceConnection.h"
#import "EKNDeviceFinder.h"
#import "EKNDeviceFinderView.h"
#import "EKNNamedChannel.h"

@interface EKNPanelWindowController () <EKNDeviceFinderViewDelegate, EKNDeviceConnectionDelegate, EKNConsoleControllerContext>

@property (strong, nonatomic) EKNDevice* activeDevice;

@property (strong, nonatomic) EKNDeviceFinder* deviceFinder;
@property (strong, nonatomic) EKNDeviceConnection* deviceConnection;
@property (strong, nonatomic) EKNConsolePluginRegistry* pluginRegistry;
@property (strong, nonatomic) EKNConsoleControllerContextDispatcher* pluginContext;
@property (strong, nonatomic) IBOutlet NSPanel* devicePickerSheet;
@property (strong, nonatomic) IBOutlet EKNDeviceFinderView* finderView;

@property (assign, nonatomic) BOOL showingDeviceFinder;

@property (strong, nonatomic) NSMutableDictionary* activeChannels;

@end

@implementation EKNPanelWindowController

- (id)initWithPluginRegistry:(EKNConsolePluginRegistry*)pluginRegistry {
    self = [super init];
    if(self != nil) {
        self.pluginRegistry = pluginRegistry;
        self.pluginContext = [[EKNConsoleControllerContextDispatcher alloc] init];
        self.pluginContext.delegate = self;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString*)windowNibName {
    return @"EKNPanelWindowController";
}

- (void)windowDidLoad
{
    self.activeChannels = [[NSMutableDictionary alloc] init];
    [super windowDidLoad];
    self.window.delegate = self;
    [self showDevicePicker];
}

- (void)showDevicePicker {
    NSAssert([NSThread isMainThread], @"Not on main thread");
    self.showingDeviceFinder = YES;
    [[NSBundle mainBundle] loadNibNamed:@"EKNDeviceFinderSheet" owner:self topLevelObjects:nil];
    [NSApp beginSheet:self.devicePickerSheet modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (void)deviceFinderViewCancelled:(EKNDeviceFinderView *)view {
    [NSApp endSheet:self.devicePickerSheet];
    [self.window orderOut:nil];
    [self.delegate willCloseWindowWithController:self];
}

- (void)deviceFinderView:(EKNDeviceFinderView *)view choseDevice:(EKNDevice *)device {
    self.deviceConnection = [[EKNDeviceConnection alloc] init];
    self.deviceConnection.delegate = self;
    [self.deviceConnection connectToDevice:device];
    [NSApp endSheet:self.devicePickerSheet];
    [self.devicePickerSheet orderOut:nil];
}

- (void)deviceConnection:(EKNDeviceConnection *)connection receivedMessage:(NSData *)data onChannel:(EKNNamedChannel *)channel {
    NSViewController<EKNConsoleController>* controller = [self.activeChannels objectForKey:channel];
    if(controller == nil) {
        id <EKNConsolePlugin> plugin = [self.pluginRegistry pluginWithName:channel.ownerName];
        controller = [plugin viewControllerWithChannel:channel];
        [controller connectedToDeviceWithContext:self.pluginContext onChannel:channel];
    }
    [controller receivedMessage:data onChannel:channel];
}

- (void)sendMessage:(NSData *)data onChannel:(EKNNamedChannel*)channel {
    [self.deviceConnection sendMessage:data onChannel:channel];
}

@end
