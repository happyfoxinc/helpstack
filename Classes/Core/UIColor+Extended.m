//
//  UIColor+Extended.m
//  HelpApp
//
//  Created by Anand on 25/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "UIColor+Extended.h"

@implementation UIColor (Extended)

+ (UIColor *)colorFromRGBString:(NSString *)colorString {

    if(!colorString){
        return nil;
    }

    NSArray *subStrings = [colorString componentsSeparatedByString:@","];
    if(subStrings.count < 4){
        return nil;
    }

    float rString = [[subStrings objectAtIndex:0] floatValue];
    float gString = [[subStrings objectAtIndex:1] floatValue];
    float bString = [[subStrings objectAtIndex:2] floatValue];
    float alphaString = [[subStrings objectAtIndex:3] floatValue];

    return [UIColor colorWithRed:rString/255.0f green:gString/255.0f blue:bString/255.0f alpha:alphaString];
}

@end
