//
//  HelpStack.h
//  HelpApp
//
//  Created by Tenmiles on 26/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGear.h"


@protocol HSGearProtocol;


@interface HSHelpStack : NSObject

+ (id)instance;

/**
    Set the type of gear to be used.
 */
@property (nonatomic, strong, readwrite) HSGear* gear;

@property (nonatomic, strong, readonly) HSAppearance* appearance;

@property (nonatomic, assign) BOOL requiresNetwork;

/*
    Setting showCredits to false will disable the credit text shown at the bottom
    of the main HelpStack screen
 */

@property (nonatomic, assign) BOOL showCredits;

/**
    Whenever you want to display HelpDesk screen, call this. This will open help screen as a modal view controller for iPhone and as a form sheet on ipad.
 
    Note: There should be a gear set, otherwise gear initialization will fail.
 */
- (void)showHelp:(UIViewController*)controller;
- (void)showHelp:(UIViewController*)controller completion:(void (^)(void))completion;
- (void)setThemeFrompList:(NSString*)pListPath;

@end






