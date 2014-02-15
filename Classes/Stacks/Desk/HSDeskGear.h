//
//  HAGearDeskCom.h
//  HelpApp
//
//  Created by Anand on 11/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGear.h"

/**
 TODO: 
 1. Explain toHelpEmail
 2. No need for making it singleton
 
 */
@interface HSDeskGear : HSGear

// Specify the properties required for this Gear.
@property (nonatomic, strong) NSString* instanceBaseURL;
@property (nonatomic, strong) NSString* toHelpEmail;
@property (nonatomic, strong) NSString* staffLoginEmail;
@property (nonatomic, strong) NSString* staffLoginPassword;

- (instancetype)initWithInstanceBaseUrl:(NSString*)instanceBaseURL toHelpEmail:(NSString*)helpEmail staffLoginEmail:(NSString*)loginEmail AndStaffLoginPassword:(NSString*)password;

@end
