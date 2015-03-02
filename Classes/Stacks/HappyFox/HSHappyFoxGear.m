//  HAGearHappyFox.m
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

#import "HSHappyFoxGear.h"
#import "HSAttachment.h"
#import "UIImage+Extended.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface HSHappyFoxGear ()

@property (nonatomic, strong) NSString *api_key;
@property (nonatomic, strong) NSString *auth_code;
@property (nonatomic, strong) NSString *instanceUrl;
@property (nonatomic, strong) NSDictionary *articleSections;
@property (nonatomic, strong) NSString *hfPriorityID;
@property (nonatomic, strong) NSString *hfCategoryID;

@end

@implementation HSHappyFoxGear

- (id)initWithInstanceUrl:(NSString*) instanceUrl apiKey:(NSString *)api_key authCode:(NSString *)auth_code priorityID: (NSString *)priority_ID categoryID: (NSString *) category_ID{
    if ( (self = [super init]) ) {
        self.api_key = api_key;
        self.auth_code = auth_code;
        self.instanceUrl = instanceUrl;
        self.hfCategoryID = category_ID;
        self.hfPriorityID = priority_ID;
        self.networkManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:instanceUrl]];
        [self.networkManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [self.networkManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [self.networkManager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.api_key password:self.auth_code];
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

- (void)fetchKBForSection:(HSKBItem*)section success:(void (^)(NSMutableArray* kbarray))success failure:(void(^)(NSError*))failure{
    
    if (section == nil){
        NSString *url = @"api/1.1/json/kb/sections/";
        if(self.hfSectionID){
            url = @"api/1.1/json/kb/section/";
            url = [url stringByAppendingString:self.hfSectionID];
            url = [url stringByAppendingString:@"/"];
        }
        [self.networkManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.articleSections = responseObject;
            if(self.hfSectionID){
                NSMutableArray *articles = [self getArticlesFromSection:responseObject];
                success(articles);
            }else{
                NSMutableArray *sections = [self getSectionsFromData:responseObject];
                success(sections);
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    } else {
        NSString *section_id = section.kb_id;
        for(id section in self.articleSections){
            if([[[section objectForKey:@"id"] stringValue] isEqualToString:section_id]){
                NSMutableArray *kbArticles = [self getArticlesFromSection:section];
                success(kbArticles);
            }
        }
    }
}

-(NSMutableArray *)getArticlesFromSection:(NSDictionary *)section{
    NSMutableArray *articles = [[NSMutableArray alloc] init];
    NSArray *fetchedarticles = [section objectForKey:@"articles"];
    for(id article in fetchedarticles){
        HSKBItem *kbarticle = [[HSKBItem alloc] initAsArticle:[article objectForKey:@"title"] htmlContent:[article objectForKey:@"contents"] baseUrl:self.instanceUrl kbID:nil];
        [articles addObject:kbarticle];
    }
    return articles;
}

-(NSMutableArray *)getSectionsFromData:(NSDictionary *)responseData{
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    for(id section in responseData){
        if([[section objectForKey:@"articles"] count]>0){
            HSKBItem *type = [[HSKBItem alloc] initAsSection:[section objectForKey:@"name"] kbID:[[section objectForKey:@"id"] stringValue]];
            [sections addObject:type];
        }
    }
    return sections;
}

- (void)fetchAllUpdateForTicket:(HSTicket *)ticket forUser:(HSUser *)user success:(void (^)(NSMutableArray* updateArray))success failure:(void (^)(NSError* e))failure {
    NSString *getString = @"api/1.1/json/ticket/";
    getString = [getString stringByAppendingString:ticket.ticketID];
    [self.networkManager GET:getString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tickUpdates = [self getTicketUpdatesFromResponseData:responseObject];
        success(tickUpdates);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(NSMutableArray *)getTicketUpdatesFromResponseData:(NSDictionary *)responseData{
    NSArray *updates = [responseData objectForKey:@"updates"];
    NSMutableArray *tickUpdates = [[NSMutableArray alloc] init];
    for(id updateDict in updates){
        if([updateDict objectForKey:@"message"] != [NSNull null]){
            HSUpdate *tick_update = [[HSUpdate alloc] init];
            NSDictionary *by = [updateDict objectForKey:@"by"];
            if ([by objectForKey:@"name"] != [NSNull null]) {
                tick_update.from = [by objectForKey:@"name"];
            }
            
            NSDictionary *message = [updateDict objectForKey:@"message"];
            tick_update.content = [message objectForKey:@"text"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSDate *date = [dateFormat dateFromString:[updateDict objectForKey:@"timestamp"]];
            tick_update.updatedAt = date;
            
            NSString *type = [by objectForKey:@"type"];
            if([type isEqualToString:@"user"]){
                tick_update.updateType = HATypeUserReply;
            }else{
                tick_update.updateType = HATypeStaffReply;
            }
            
            if([message objectForKey:@"attachments"] != [NSNull null]){
                NSMutableArray *attachments = [[NSMutableArray alloc] init];
                for(NSDictionary *attachmentDict in [message objectForKey:@"attachments"]){
                    HSAttachment *attachment = [[HSAttachment alloc] init];
                    attachment.fileName = [attachmentDict objectForKey:@"filename"];
                    attachment.url = [attachmentDict objectForKey:@"url"];
                    [attachments addObject:attachment];
                }
                tick_update.attachments = attachments;
            }
            [tickUpdates addObject:tick_update];
        }
    }
    return tickUpdates;
}

- (void)createNewTicket:(HSNewTicket *)newTicket byUser:(HSUser *)user success:(void (^)(HSTicket* ticket, HSUser * user))success failure:(void (^)(NSError* e))failure {
    HSUser* hfUser = user;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:hfUser.name forKey:@"name"];
    [parameters setObject:hfUser.email forKey:@"email"];
    [parameters setObject:self.hfCategoryID forKey:@"category"];
    [parameters setObject:self.hfPriorityID forKey:@"priority"];
    [parameters setObject:newTicket.subject forKey:@"subject"];
    [parameters setObject:newTicket.content forKey:@"text"];
    NSArray *attachments = newTicket.attachments;
    
    [self.networkManager POST:@"api/1.1/json/new_ticket/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        if(attachments != nil && (attachments.count > 0)){
            for(HSAttachment *attachment in attachments){
                [formData appendPartWithFileData:attachment.attachmentData name:@"attachments" fileName:((HSAttachment *)attachment).fileName mimeType:((HSAttachment *)attachment).mimeType];
            }
        }
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HSTicket *issue = [[HSTicket alloc] init];
        issue.subject = [responseObject objectForKey:@"subject"];
        issue.ticketID = [[responseObject objectForKey:@"id"] stringValue];
        
        // Parsing user id
        NSString* userId = [[[responseObject objectForKey:@"user"] objectForKey:@"id"] stringValue];
        hfUser.apiHref = userId;
        success(issue, hfUser);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        HALog(@"Failed to create a ticket %@", error);
        if (operation.responseString) {
            HALog(@"Error Description %@", operation.responseString);
        }
        failure(error);
    }];
}

- (void)addReply:(HSTicketReply *)reply forTicket:(HSTicket *)ticket byUser:(HSUser *)user success:(void (^)(HSUpdate* update))success failure:(void (^)(NSError* e))failure {
    
    NSString *qString = @"api/1.1/json/ticket/";
    qString = [qString stringByAppendingString:ticket.ticketID];
    qString = [qString stringByAppendingString:@"/user_reply/"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:user.apiHref forKey:@"user"];
    [parameters setObject:reply.content forKey:@"text"];
    
    NSArray *attachments = reply.attachments;
    
    [self.networkManager POST:qString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        for(HSAttachment *attachment in attachments){
            [formData appendPartWithFileData:attachment.attachmentData name:@"attachments" fileName:attachment.fileName mimeType:attachment.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        HSUpdate *recentUpdate = [[HSUpdate alloc] init];
        recentUpdate.from = user.name;
        recentUpdate.content = reply.content;
        recentUpdate.attachments = [[NSArray alloc] initWithArray:attachments];
        recentUpdate.updatedAt = [NSDate date];
        recentUpdate.updateType = HATypeUserReply;
        success(recentUpdate);
        //Send all the updates
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HALog(@"Failed to update Ticket %@", error);
        if (operation.responseString) {
            HALog(@"Error Description %@", operation.responseString);
        }
        failure(error);
    }];
}

@end
