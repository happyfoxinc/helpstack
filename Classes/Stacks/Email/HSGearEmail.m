//
//  HAGearDefault.m
//  HelpApp
//
//  Created by Tenmiles on 26/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSGearEmail.h"

@interface HSGearEmail ()

@end

@implementation HSGearEmail

- (id)initWithSupportEmailAddress:(NSString*)emailAddress articlePath:(NSString *)articlePath
{
    if(self = [super init]) {
        self.supportEmailAddress = emailAddress;
        self.localArticlePath = articlePath;
    }
    return self;
}

- (BOOL)doLetEmailHandleIssueCreation {
    return YES;
}

@end
