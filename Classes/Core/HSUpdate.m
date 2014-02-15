//
//  HATypeUpdate.m
//  HelpApp
//
//  Created by Tenmiles on 30/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSUpdate.h"

@implementation HSUpdate

- (NSString *)updatedAtString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yy HH:mm"];
    NSString *dateString = [formatter stringFromDate:self.updatedAt];
    return dateString;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Update From: %@ \nContent: %@\nUpdatedTime: %@\nType: %@", _from, _content, [self updatedAtString], [self updateTypeString]];
}

- (NSString *)updateTypeString {
    if (_updateType == 0) {
        return @"User";
    }
    else if (_updateType == 1) {
        return @"Staff";
    }
    return nil;
}

@end
