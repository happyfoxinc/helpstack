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
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"dd-MM-yy HH:mm"];
//    NSString *dateString = [formatter stringFromDate:self.updatedAt];
//    return dateString;

   return [self stringFortimeSinceDateFull:self.updatedAt];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nUpdate -> From: %@ \nContent: %@\nUpdatedTime: %@\nType: %@", _from, _content, [self updatedAtString], [self updateTypeString]];
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

- (NSString*)stringFortimeSinceDateFull:(NSDate*)date
{
    NSString* timeString;
    NSTimeInterval secondsSinceUpdate = abs([date timeIntervalSinceNow]);
    if (secondsSinceUpdate < 60) {
        int seconds = abs(round(secondsSinceUpdate));
        NSString* str = (seconds == 1)? @"sec":@"secs";
        timeString = [NSString stringWithFormat:@"%d %@", seconds,str];
        
    }else if (secondsSinceUpdate > 60 && secondsSinceUpdate < 3600){
        int minutes = abs(round(secondsSinceUpdate/60.0));
        NSString* str = (minutes == 1)? @"min":@"mins";
        timeString = [NSString stringWithFormat:@"%d %@", minutes,str];
        
    }else if (secondsSinceUpdate > 3600 && secondsSinceUpdate < 86400){
        int hours = abs(round(secondsSinceUpdate/3600.0));
        NSString* str = (hours == 1)? @"hour":@"hours";
        timeString = [NSString stringWithFormat:@"%d %@", hours,str];
        
    }else{
        int days = abs(floor(secondsSinceUpdate/86400.0));
        NSString* str = (days == 1)? @"day":@"days";
        timeString = [NSString stringWithFormat:@"%d %@", days,str];
    }
    
    return timeString;
}

@end
