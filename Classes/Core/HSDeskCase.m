//
//  HSDeskCase.m
//  HelpApp
//
//  Created by Anand on 13/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSDeskCase.h"

@implementation HSDeskCase

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.apiHref forKey:@"apiHref"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.apiHref = [aDecoder decodeObjectForKey:@"apiHref"];
    }

    return self;
}

@end
