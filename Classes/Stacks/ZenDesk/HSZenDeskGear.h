//
//  HAGearZenDesk.h
//  HelpApp
//
//  Created by Tenmiles on 27/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSGear.h"

@interface HSZenDeskGear : HSGear

- (id)initWithInstanceUrl:(NSString*)instanceUrl staffEmailAddress:(NSString *)staffEmailAddress
                 apiToken:(NSString *)apiToken localArticlePath:(NSString *)localArticlePath;

@property (nonatomic, strong) NSString* staffEmailAddress;
@property (nonatomic, strong) NSString* apiToken;
@property (nonatomic, strong) NSString* localArticlePath;

@end
