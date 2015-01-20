//  HATicketGearImpl.h
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
#import "HSUser.h"
#import "HSDraft.h"

@interface HSTicketSource : NSObject

/**
 Provides an instance with gear set in HSHelpStack.
 */
+ (instancetype)createInstance;

// Initialize with gear to use
- (id)initWithGear:(HSGear *)gear;

@property(nonatomic, strong, readonly) HSGear *gear;

@property (nonatomic, strong, readwrite) HSDraft* draft;


/**
 Fetches ticket properties from given gear.
 Note: You should call this on viewDidAppear or anytime you need fresh data from server.
 */
- (void)prepareTicket:(void (^)(void))success failure:(void (^)(NSError *))failure;
- (void)prepareUpdate:(HSTicket *)ticketDict success:(void (^)(void))success failure:(void (^)(NSError *))failure;

- (void)saveTicketDraft:(NSString *)subject message:(NSString *)message;
- (void)saveUserDraft:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email;
- (void)saveReplyDraft:(NSString *)message;

- (NSString *) draftSubject;
- (NSString *) draftMessage;
- (NSString *) draftUserFirstName;
- (NSString *) draftUserLastName;
- (NSString *) draftUserEmail;
- (NSString *) draftReplyMessage;

- (void) clearTicketDraft;
- (void) clearUserDraft;
- (void) clearReplyDraft;

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
