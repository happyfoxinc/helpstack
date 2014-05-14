//  HAGear.m
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


#import "HSGear.h"

/**
    HAGear is helper class that does all heavy lifting for you. HAGear is responsible for handling data models and caching for you. It integrate KB and ticket for you.
 
 
    It uses HAKBGearImpl, which implements KB model and HSTicketGearImpl to implement Ticket model
 */

@interface  HSGear ()

@end

@implementation HSGear

- (void)fetchKBForSection:(HSKBItem *)section success:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure {
    success(nil);
}


- (void)fetchAllTicketForUser:(HSUser *)user success:(void (^)(NSMutableArray* ticketarray))success failure:(void (^)(NSError* e))failure;
{
    success(nil);
}


///------------------------------------------
/// @name Create a ticket
///-------------------------------------------
/**
 Create ticket with given params

 Note: If you need us to ask user details, send yes on shouldShowUserDetailsFormWhenCreatingTicket

 Note: Call success even if you are not doing anything here.

 Note: The created ticket is added at first position, in the array created. So you dont have to do anything.
 */
- (void)createNewTicket:(HSNewTicket *)newTicket byUser:(HSUser *)user success:(void (^)(HSTicket *, HSUser *))success failure:(void (^)(NSError *))failure
{
    success(nil, nil);
}

///------------------------------------------
/// @name Fetch all updates on ticket
///-------------------------------------------
/**
 Fetch Updates on given Ticket.

 Note: Call success even if you are not doing anything here.
 */
- (void)fetchAllUpdateForTicket:(HSTicket *)ticket forUser:(HSUser *)user success:(void (^)(NSMutableArray* updateArray))success failure:(void (^)(NSError* e))failure
{
    success(nil);
}

///------------------------------------------
/// @name Add reply to a ticket
///-------------------------------------------

/*
 Add reply to update

 Note: Call success even if you are not doing anything here.
 */
- (void)addReply:(HSTicketReply *)reply forTicket:(HSTicket *)ticket byUser:(HSUser *)user success:(void (^)(HSUpdate* update))success failure:(void (^)(NSError* e))failure
{
    success(nil);
}

- (void)checkAndFetchValidUser:(HSUser*)user withSuccess:(void (^)(HSUser* validUser))success failure:(void(^)(NSError* e))failure {

    //do nothing by default
    //subclasses can override this and check with the server for a valid user.
    //return nil in success block if no valid user can be supplied by the user.
    success(user);
}

- (BOOL)doLetEmailHandleIssueCreation {
    return NO;
}


@end
