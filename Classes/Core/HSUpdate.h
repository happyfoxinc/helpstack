//
//  HATypeUpdate.h
//  HelpApp
//
//  Created by Tenmiles on 30/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, HAUpdateType) {
    HATypeUserReply = 0,
    HATypeStaffReply = 1
};

@interface HSUpdate : NSObject

//required
@property(nonatomic, strong) NSString* from;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSDate* updatedAt;
@property(nonatomic) HAUpdateType updateType;

//optional
@property (nonatomic, strong) NSArray* attachments;

-(NSString*) updatedAtString;

@end
