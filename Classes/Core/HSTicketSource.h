//
//  HATicketGearImpl.h
//  HelpApp
//
//  Created by Tenmiles on 01/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGear.h"
#import "HSUser.h"

@interface HSTicketSource : NSObject

/**
 Provides an instance with gear set in HSHelpStack.
 */
+ (instancetype)createInstance;

// Initialize with gear to use
- (id)initWithGear:(HSGear *)gear;

@property(nonatomic, strong, readonly) HSGear *gear;


/**
 Fetches ticket properties from given gear.
 Note: You should call this on viewDidAppear or anytime you need fresh data from server.
 */
- (void)prepareTicket:(void (^)(void))success failure:(void (^)(NSError *))failure;
- (void)prepareUpdate:(HSTicket *)ticketDict success:(void (^)(void))success failure:(void (^)(NSError *))failure;

/**
 Read Ticket properties.
 Note: Call prepareKB:success:failure else this method with return zero articles.
 */
- (NSInteger)ticketCount;
- (HSTicket *) ticketAtPosition:(NSInteger)position;
- (NSInteger)updateCount;
- (HSUpdate *)updateAtPosition:(NSInteger)position;

// Creating new ticket
- (BOOL)shouldShowUserDetailsFormWhenCreatingTicket;
// Registers user, but save user details only after first ticket is created successfully
- (void)registerUserWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email success:(void (^)(void))success failure:(void (^)(NSError *error))failure;



- (void)createNewTicket:(HSNewTicket *)details success:(void (^)(void))success failure:(void (^)(NSError *))failure;

// Add reply on ticket
- (void)addReply:(HSTicketReply *)details ticket:(HSTicket *)ticketDict success:(void (^)(void))success failure:(void (^)(NSError *))failure;


// Ticket Protocol properties
- (BOOL) isTicketProtocolImplemented;
- (NSString *) supportEmailAddress;

@end
