//
//  HSUtility.h
//  Pods
//
//  Created by Nalin on 16/05/14.
//
//

#import <Foundation/Foundation.h>

@interface HSUtility : NSObject

+ (Boolean) isValidEmail: (NSString*) email;

+ (NSString*) stringFortimeSinceDateFull: (NSDate*) date;

+ (NSString*) deviceInformation;

@end
