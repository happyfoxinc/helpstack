//  HATypeUpdate.m
//
//Copyright (c) 2014 HelpStack (http://helpstack.io)
//
//Permission is hereby granted, free of charge, to any person obtaining a cop
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

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
