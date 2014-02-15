//
//  HAKBGearImpl.h
//  HelpApp
//
//  Created by Tenmiles on 31/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

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
