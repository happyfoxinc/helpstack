//  HAKBGearImpl.h
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


#import <Foundation/Foundation.h>
#import "HSGear.h"

typedef NS_OPTIONS(NSUInteger, HAGearTableType)
{
    HAGearTableTypeDefault = 0,
    HAGearTableTypeSearch = 1
};


@interface HSKBSource : NSObject

/**
    Provides an instance with gear set in HSHelpStack.
 */
+ (instancetype)createInstance;
- (id)initWithGear:(HSGear*)gear;

/**
    Gear to use.
 */
@property(nonatomic, strong, readonly) HSGear* gear;

/**
 Section from which KB articles should be fetched.
 nil section are allowed.
 */
@property(nonatomic, strong) HSKBItem* section;



/**
    Fetches KB articles from given gear.
    Note: You should call this on viewDidAppear or anytime you need fresh data from server.
 */
- (void)prepareKB:(void (^)(void))success failure:(void (^)(NSError*))failure;


/**
    Read KB articles.
    Note: Call prepareKB:success:failure else this method with return zero articles.
 */
- (HSKBItem *)table:(HAGearTableType)type kbAtPosition:(NSInteger)position;

- (NSInteger)kbCount:(HAGearTableType)type;


/**
    Seach for KB articles in given gear
 */
- (void)filterKBforSearchString:(NSString *)string success:(void (^)(void))success failure:(void (^)(NSError*))failure;


/**
    Get new HAKBSource for selected section.
 */
- (HSKBSource*)sourceForSection:(HSKBItem *)section;
@end
