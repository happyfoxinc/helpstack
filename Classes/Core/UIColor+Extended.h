//
//  UIColor+Extended.h
//  HelpApp
//
//  Created by Anand on 25/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    This category adds methods to the UIKit Framework's `UIColor` class. The method added in this category provides a UIColor from a R,G,B
    values provided as String.
 */
@interface UIColor (Extended)

///-----------------------------------------
/// @name Getting UIColor from Custom values
///-----------------------------------------

/**
    Provides a UIColor from R,G,B,alpha values provided as a String
    @param colorString The R,G,B,alpha values provided as string separated by commas
 */

+ (UIColor *)colorFromRGBString:(NSString *)colorString;

@end
