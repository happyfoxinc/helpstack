//  HAGearZenDesk.m
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

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "HSZenDeskGear.h"
#import "HSZenDeskTicket.h"
#import "HSZenDeskTicketUpdate.h"

/**
 Zendesk implementation. It implements HAGear and self assign HAGearProtocol.
 
 Zendesk api, doesnot support KB articles, so have override method to call HAKBGearLocal.
 
 user_name and email are saved in preference, so it is not necessary to ask for name and email again and again.
 
 Tickets are fetched based on user email address.
 
 */
@interface HSZenDeskGear ()

@property (nonatomic, strong) NSString* instanceUrl;

@end

@implementation HSZenDeskGear

- (id)initWithInstanceUrl:(NSString*)instanceUrl staffEmailAddress:(NSString *)staffEmailAddress
                 apiToken:(NSString *)apiToken{
    if (self = [super init]) {
        
        self.instanceUrl = instanceUrl;
        self.staffEmailAddress = staffEmailAddress;
        self.apiToken = apiToken;
        
        self.networkManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:instanceUrl]];
        
        [self.networkManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [self.networkManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

- (void)showArticlesInSection:(NSString *)sectionID failure:(void (^)(NSError *))failure success:(void (^)(NSMutableArray *))success
{
    [self.networkManager GET:[NSString stringWithFormat:@"/api/v2/help_center/sections/%@/articles.json", sectionID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        NSNumber *numEntries = [response objectForKey:@"count"];
        
        if ([numEntries integerValue] > 0) {
            NSArray *articles = [responseObject objectForKey:@"articles"];
            NSMutableArray *articlesToShow = [[NSMutableArray alloc] init];
            
            for (NSDictionary *article in articles) {
                HSKBItem *kbItem = [[HSKBItem alloc] init];
                [kbItem setItemType:HSKBItemTypeArticle];
                [kbItem setTitle:[article objectForKey:@"name"]];
                [kbItem setHtmlContent:[article objectForKey:@"body"]];
                
                [articlesToShow addObject:kbItem];
            }
            
            success(articlesToShow);
            
        } else {
            success(nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

#pragma mark - Get KB Sections, Articles
- (void)fetchKBForSection:(HSKBItem *)section success:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure
{
    
    if (!section) {
        
        if(!self.sectionID) {
            NSString *url = @"/api/v2/help_center/sections.json";
            [self.networkManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *response = (NSDictionary *)responseObject;
                NSNumber *numOfTopics = [response objectForKey:@"count"];
                
                if ([numOfTopics integerValue] > 0) {
                    NSDictionary *sections = [response objectForKey:@"sections"];
                    NSMutableArray *sectionsToShow = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *section in sections) {
                        HSKBItem *kbItem = [[HSKBItem alloc] init];
                        [kbItem setItemType:HSKBItemTypeSection];
                        [kbItem setKb_id:[section objectForKey:@"id"]];
                        [kbItem setTitle:[section objectForKey:@"name"]];
                        
                        [sectionsToShow addObject:kbItem];
                    }
                    
                    success(sectionsToShow);
                } else {
                    success(nil);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(error);
            }];
        } else {
            [self showArticlesInSection:self.sectionID failure:failure success:success];
        }
    } else {
        [self showArticlesInSection:section.kb_id failure:failure success:success];
    }
}



#pragma mark - HAGearProtocol implementation


/**
    Creating ticket, if user email and name are not provided, using it from prefs.
 */
- (void)createNewTicket:(HSNewTicket *)newTicket byUser:(HSUser *)user success:(void (^)(HSTicket* ticket, HSUser * user))success failure:(void (^)(NSError* e))failure {
    
    [self createNewZendeskTicket:newTicket forUser:user success:^(HSZenDeskTicket *ticket) {
        
        success(ticket, user);
        
    } failure:failure];
    
}

/**
    Fetching all update based on ticket id
 */
- (void)fetchAllUpdateForTicket:(HSTicket *)ticket forUser:(HSUser *)user success:(void (^)(NSMutableArray* updateArray))success failure:(void (^)(NSError* e))failure {
    
    HSZenDeskTicket* zenticket = (HSZenDeskTicket*)ticket;
    
    [self reloadTicket:zenticket.ticketID success:^(NSMutableArray *ticketUpdate) {
        
        success(ticketUpdate);
        
    } failure:failure];
    
}

/**
    Adding reply to a ticket
 */
- (void)addReply:(HSTicketReply *)reply forTicket:(HSTicket *)ticket byUser:(HSUser *)user success:(void (^)(HSUpdate* update))success failure:(void (^)(NSError* e))failure {
    
    HSZenDeskTicket* zenticket = (HSZenDeskTicket*)ticket;
    
    [self addReply:reply.content ticketId:zenticket.ticketID attachments:reply.attachments forUser:(HSUser *)user success:^(HSZenDeskTicketUpdate *ticketUpdate) {
        
        success(ticketUpdate);
        
    } failure:failure];
    
}

#pragma mark- helper methods


- (void) createNewZendeskTicket:(HSNewTicket *)newTicket forUser:(HSUser *)user success:(void (^)(HSZenDeskTicket* ticket))operationSuccess failure:(void (^)(NSError *))operationFailure {
    // If attachments are there convert attachments to string token
    // Perform action
    [self uploadAttachments:newTicket.attachments success:^(NSArray *attachmentTokens){
        
        // Uploading tickets
        NSString* url = @"api/v2/tickets.json";
        [self.networkManager.requestSerializer setAuthorizationHeaderFieldWithUsername:[self.staffEmailAddress stringByAppendingString:@"/token"] password:self.apiToken];
        NSDictionary* ticketDictionary = @{
                                           @"ticket": @{
                                                   @"requester":@{@"name":user.name,@"email":user.email,@"verified":@true},
                                                   @"subject":newTicket.subject,
                                                   @"comment":@{@"body":newTicket.content, @"uploads":attachmentTokens}
                                                   }
                                           };
        
        
        [self.networkManager POST:url parameters:ticketDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Save ticket details so next time it is ready for user to use.
            HSZenDeskTicket* ticket = [[HSZenDeskTicket alloc] initWithTicketFields:responseObject];
            operationSuccess(ticket);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            operationFailure(error);
        }];
    } failure:^(NSError* error) {
        operationFailure(error);
    }];
    
    
}

- (void) uploadAttachments:(NSArray *)attachments success:(void (^)(NSArray *attachmentTokens))success failure:(void (^)(NSError *))operationFailure {
    
    // return success after uploading all attachments
    if (attachments == nil || [attachments count]==0) {
        success(@[]);
        return;
    }
    
    HSAttachment* attachment = [attachments objectAtIndex:0]; // only 1 attachments upload
    
    NSString* URLString = [[NSURL URLWithString:[NSString stringWithFormat:@"api/v2/uploads.json?filename=%@", attachment.fileName] relativeToURL:[NSURL URLWithString:self.instanceUrl]] absoluteString];
    
    AFHTTPRequestOperationManager* attachmentnetworkManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:self.instanceUrl]];
    
    [attachmentnetworkManager.requestSerializer setAuthorizationHeaderFieldWithUsername:[self.staffEmailAddress stringByAppendingString:@"/token"] password:self.apiToken];
    
    // Create NSURLRequest
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [attachmentnetworkManager.requestSerializer.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        [request setValue:value forHTTPHeaderField:field];
    }];
    
    [request setValue:@"application/binary" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:attachment.attachmentData];
    
    [attachmentnetworkManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    
    // Use [self.networkManager HTTPRequestOperationWithRequest
    AFHTTPRequestOperation *operation = [attachmentnetworkManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* uploadDict = [responseObject objectForKey:@"upload"];
        success(@[[uploadDict objectForKey:@"token"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        operationFailure(error);
    }];
    
    [operation start];
    
}

- (void)reloadTicket:(NSString*)ticketId success:(void (^) (NSMutableArray* ticketUpdate))success failure:(void (^)(NSError *))failure {
    
    NSString* url = [NSString stringWithFormat:@"api/v2/tickets/%@/audits.json", ticketId];
    NSDictionary* parameter = @{@"include":@"users"};
    [self.networkManager.requestSerializer setAuthorizationHeaderFieldWithUsername:[self.staffEmailAddress stringByAppendingString:@"/token"] password:self.apiToken];
    
    [self.networkManager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Read all data
        NSArray* auditsDictionary = [responseObject objectForKey:@"audits"];
        NSArray* usersDictionary = [responseObject objectForKey:@"users"];
        
        NSMutableArray* ticketUpdateArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *object in auditsDictionary) {
            HSZenDeskTicketUpdate* update = [[HSZenDeskTicketUpdate alloc] initWithAudit:object usersDictionary:usersDictionary];
            [ticketUpdateArray addObject:update];
        }
        
        // TODO: filter only public update
        NSMutableArray* filteredArray = [[NSMutableArray alloc] initWithArray:[ticketUpdateArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            HSZenDeskTicketUpdate* update = evaluatedObject;
            return [update publicNote];
        }]]];
        
        
        success(filteredArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
    }];
    
}

- (void)addReply:(NSString *)message ticketId:(NSString *)ticketId attachments:(NSArray *)attachments forUser:(HSUser *)user success:(void (^) (HSZenDeskTicketUpdate* ticketUpdate))success failure:(void (^)(NSError *))failure {

    
    // If attachments are there convert attachments to string token
    // Perform action
    [self uploadAttachments:attachments success:^(NSArray *attachmentTokens){
        
        NSString* url = [NSString stringWithFormat:@"api/v2/requests/%@.json", ticketId];
        NSDictionary* parameter = @{@"request":@{ @"comment":@{ @"body":message, @"uploads":attachmentTokens } }};
        [self.networkManager.requestSerializer setAuthorizationHeaderFieldWithUsername:[user.email stringByAppendingString:@"/token"] password:self.apiToken];
        [self.networkManager PUT:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            HSZenDeskTicketUpdate* update = [[HSZenDeskTicketUpdate alloc] initUserReplyWithAuthorName:user.name message:message attachments:attachments];
            success(update);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            failure(error);
            
        }];
    } failure:^(NSError* error) {
        
        failure(error);
        
    }];
    
}

@end
