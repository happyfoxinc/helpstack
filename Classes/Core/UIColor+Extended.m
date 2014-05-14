//  UIColor+Extended.m
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
