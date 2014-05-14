//  HSGear.h
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
#import "HSAppearance.h"
#import "HSKBitem.h"
#import "HSTicket.h"
#import "HSUpdate.h"
#import "HSNewTicket.h"
#import "HSAttachment.h"
#import "HSTicketReply.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>



/**
 
 HSGear helps you implement your own favorite HelpDesk solution at ease.
 
 We have integrated AFNetworking for you to use.
 
 Note: We are doing caching for you -> Only important fields are cached and stored in 'HelpStack' directory.
 
 */

#define HALog(fmt, ...) NSLog((@"HelpApp:- " fmt),  ##__VA_ARGS__)

@protocol HSGearProtocol <NSObject>

///-------------------------------------
/// @name Fetch KB articles from server
///-------------------------------------
/**
 
 Fetch KB articles for given section and return an array to display. Section will be nil for first time, and after that user selection section will be sent.
 
 @params section The sub-section for which KB is to be fetch. Can be nil to get first set of sections.
 
 @return, array of type HSKBItem when operation is success.

 Note: Make sure, to set if the given KB is of type section or article.

 Note: Call success even if you are not doing anything here.
 
 */
- (void)fetchKBForSection:(HSKBItem*)section success:(void (^)(NSMutableArray* kbarray))success failure:(void(^)(NSError* e))failure;


///------------------------------------------
/// @name Fetch all ticket
///-------------------------------------------
/**
 
 Fetch Ticket for the user.
 
 @params user The user object that is formed when ticket is created.

 @return, array of type HSTicket when operation is success.
 
 */
- (void)fetchAllTicketForUser:(HSUser *)user success:(void (^)(NSMutableArray* ticketarray))success failure:(void (^)(NSError* e))failure;


///------------------------------------------
/// @name Create a ticket
///-------------------------------------------

/**
 This is called before creating a ticket so validation on user information can be done.
 
 @params user user object that contains name and email of user
 
 @return valid user object, this object will be send back during ticket creation.
 */
- (void)checkAndFetchValidUser:(HSUser*)user withSuccess:(void (^)(HSUser* validUser))success failure:(void(^)(NSError* e))failure;

/**
 Create ticket with given params
 
 @params newTicket The properties for new ticket that has to be created.
 @params user The user object that is received in `checkAndFetchValidUser:user`

 @return ticket object for the given ticket creation request when operation is success.
 @return updated user object for tickets when operation is success.
 
 */
- (void)createNewTicket:(HSNewTicket *)newTicket byUser:(HSUser *)user success:(void (^)(HSTicket* ticket, HSUser * updatedUserInfo))success failure:(void (^)(NSError* e))failure;


///------------------------------------------
/// @name Fetch all updates on ticket
///-------------------------------------------
/**
 
    Fetch Updates on given Ticket.
 
    @params ticket The ticket for which the update has to be fetched.
    @params user The user object that is formed when ticket is created.
 
    @return array of HSUpdate object when operation is success
 
 */
- (void)fetchAllUpdateForTicket:(HSTicket *)ticket forUser:(HSUser *)user success:(void (^)(NSMutableArray* updateArray))success failure:(void (^)(NSError* e))failure;

///------------------------------------------
/// @name Add reply to a ticket
///-------------------------------------------

/*
 Add reply to update

 @params reply The reply to be added to a given ticket.
 @params ticket The ticket for which the update has to be fetched.
 @params user The user object that is formed when ticket is created.
 
 @return update object when operation is success
 */
- (void)addReply:(HSTicketReply *)reply forTicket:(HSTicket *)ticket byUser:(HSUser *)user success:(void (^)(HSUpdate* update))success failure:(void (^)(NSError* e))failure;




@optional
///------------------------------------------
/// @name Search KB articles for given String
///-------------------------------------------
/**
 Filter your KB articles and return an array to display. 
 Default implementation, filters array within sections.
 */
- (void)searchKB:(NSString*)searchString success:(void (^)(NSMutableArray* kbarray))success failure:(void(^)(NSError* e))failure;


// To let email handle issue creation return yes. emailgear return yes. default is no.
- (BOOL)doLetEmailHandleIssueCreation;

@end



@interface HSGear : NSObject <HSGearProtocol>

@property (nonatomic, strong) NSString* supportEmailAddress;
@property (nonatomic, strong) NSString* localArticlePath;
@property (nonatomic, strong) AFHTTPRequestOperationManager* networkManager;


@end





