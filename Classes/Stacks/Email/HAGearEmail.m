//
//  HAGearDefault.m
//  HelpApp
//
//  Created by Tenmiles on 26/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HAGearEmail.h"


@interface HAGearEmail ()

@end

@implementation HAGearEmail

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
