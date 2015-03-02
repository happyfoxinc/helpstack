//  HAGearDeskCom.m
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
#import "HSDeskGear.h"
#import "HSDeskKBItem.h"
#import "HSDeskCase.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "UIImage+Extended.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface HSDeskGear ()


@end

@implementation HSDeskGear

- (instancetype)initWithInstanceBaseUrl:(NSString*)instanceBaseURL toHelpEmail:(NSString*)helpEmail staffLoginEmail:(NSString*)loginEmail AndStaffLoginPassword:(NSString*)password
{
    if (self = [super init]) {
        
        self.instanceBaseURL = instanceBaseURL;
        self.toHelpEmail = helpEmail;
        self.staffLoginEmail = loginEmail;
        self.staffLoginPassword = password;
        
        
        NSURL* baseURL = [[NSURL alloc] initWithString:instanceBaseURL];
        AFHTTPRequestOperationManager* operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        
        [operationManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [operationManager.requestSerializer setAuthorizationHeaderFieldWithUsername:loginEmail password:password];
        [operationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [operationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        self.networkManager = operationManager;
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    }
    return self;
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
- (void)createNewTicket:(HSNewTicket *)newTicket byUser:(HSUser *)user success:(void (^)(HSTicket* ticket, HSUser * user))success failure:(void (^)(NSError* e))failure {

    if (!user.apiHref) {
        NSLog(@"Cannot create ticket for NULL customer");
        failure(nil);
        return;
    }

    NSDictionary* messageFields = @{@"direction": @"in", @"from":user.email, @"to":self.toHelpEmail, @"subject":newTicket.subject, @"body":newTicket.content};
    NSDictionary* customerLinks = @{@"customer": @{@"href": user.apiHref, @"class": @"customer"}};
    NSDictionary* params = @{ @"type":@"email", @"subject": newTicket.subject, @"_links":customerLinks, @"message":messageFields};


    [self.networkManager POST:@"api/v2/cases" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responsedata = (NSDictionary*)responseObject;

        NSString* subject = [responsedata objectForKey:@"subject"];
        NSString* caseLink = [[[responsedata objectForKey:@"_links"] objectForKey:@"self"] objectForKey:@"href"];

        //report success
        HSDeskCase* deskCase = [[HSDeskCase alloc] init];
        deskCase.subject = subject;
        deskCase.apiHref = caseLink;

        if (newTicket.attachments && [newTicket.attachments count] > 0) {

            HSAttachment* attachment = [newTicket.attachments objectAtIndex:0];

            //add an attachment
            NSString* attachmentPostURL = [caseLink stringByAppendingPathComponent:@"attachments"];
            NSDictionary* attachmentParams = @{ @"file_name": attachment.fileName, @"content_type":@"image/png", @"content": attachment.attachmentImage.base64EncodedString };

            [self.networkManager POST:attachmentPostURL parameters:attachmentParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
                success(deskCase, user);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Case created. But Error creating attachment %@", error.localizedDescription);
                success(deskCase, user);
            }];

        }else{
            success(deskCase, user);
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error creating case %@", error.localizedDescription);
        
        failure(error);
        
    }];
}


///------------------------------------------
/// @name Fetch all updates on ticket
///-------------------------------------------
/**
 Fetch Updates on given Ticket.

 Note: Call success even if you are not doing anything here.
 */
- (void)fetchAllUpdateForTicket:(HSTicket *)ticket forUser:(HSUser *)user success:(void (^)(NSMutableArray* updateArray))success failure:(void (^)(NSError* e))failure {

    HSDeskCase* deskCase = (HSDeskCase*)ticket;

    __block NSMutableArray* allReplies = [[NSMutableArray alloc] init];

    NSString* messageURL = [NSString stringWithFormat:@"%@/message", deskCase.apiHref];

    [self.networkManager GET:messageURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        HSUpdate* originalMessage = [[HSUpdate alloc] init];
        originalMessage.content = [responseObject objectForKey:@"body"];
        originalMessage.updateType = HATypeUserReply;
        originalMessage.from = [responseObject objectForKey:@"from"];

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-ddThh:mm:ssZ"];
        originalMessage.updatedAt = [dateFormatter dateFromString:[responseObject objectForKey:@"updated_at"]];

        [allReplies addObject:originalMessage];

        NSString* repliesURL = [NSString stringWithFormat:@"%@/replies", deskCase.apiHref];
        
        NSDictionary* params = @{@"sort_field": @"updated_at", @"sort_direction": @"asc"};
        
        [self.networkManager GET:repliesURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

            //got the replies

            NSArray* entries = [[responseObject objectForKey:@"_embedded"] objectForKey:@"entries"];

            for (NSDictionary* reply in entries) {
                HSUpdate* update = [[HSUpdate alloc] init];

                if ([reply objectForKey:@"from"] != [NSNull null] )  {
                    update.from = [reply objectForKey:@"from"];
                };
                
                update.content = [reply objectForKey:@"body"];
                

                if ([[reply objectForKey:@"direction"] isEqualToString:@"out"]) {
                    update.updateType = HATypeStaffReply;
                }else{
                    update.updateType = HATypeUserReply;
                }

                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-ddThh:mm:ssZ"];
                update.updatedAt = [dateFormatter dateFromString:[reply objectForKey:@"updated_at"]];

                [allReplies addObject:update];
            }
            
            success(allReplies);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            failure(error);
        }];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        failure(error);
    }];


}

///------------------------------------------
/// @name Add reply to a ticket
///-------------------------------------------

/*
 Add reply to update

 Note: Call success even if you are not doing anything here.
 */
- (void)addReply:(HSTicketReply *)reply forTicket:(HSTicket *)ticket byUser:(HSUser *)user success:(void (^)(HSUpdate* update))success failure:(void (^)(NSError* e))failure {

    HSDeskCase* deskCase = (HSDeskCase*)ticket;

    if (!deskCase.apiHref) {
        NSLog(@"Cannot create replies for NULL ticket");
        failure(nil);
        return;
    }

    NSDictionary* messageFields = @{@"direction": @"in", @"body":reply.content, @"to": self.toHelpEmail}; //creating a user reply.

    [self.networkManager POST:[NSString stringWithFormat:@"%@/replies", deskCase.apiHref] parameters:messageFields success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary* responsedata = (NSDictionary*)responseObject;

        HSUpdate* userReply = [[HSUpdate alloc] init];
        [userReply setUpdateType:HATypeUserReply];
        [userReply setContent:[responsedata objectForKey:@"body"]];

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-ddThh:mm:ssZ"];
        userReply.updatedAt = [dateFormatter dateFromString:[responsedata objectForKey:@"updated_at"]];

        //Now Attachments for reply.
        if (reply.attachments && [reply.attachments count] > 0) {

            HSAttachment* attachment = [reply.attachments objectAtIndex:0];

            if (attachment.attachmentImage) {
                NSString* attachmentPostURL = [deskCase.apiHref stringByAppendingPathComponent:@"attachments"];
                NSDictionary* attachmentParams = @{ @"file_name": @"Screenshot", @"content_type":@"image/png", @"content": attachment.attachmentImage.base64EncodedString };

                [self.networkManager POST:attachmentPostURL parameters:attachmentParams success:^(AFHTTPRequestOperation *operation, id responseObject) {

                    userReply.attachments = reply.attachments;

                    success(userReply);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Case created. But Error creating attachment %@", error.localizedDescription);
                    success(userReply);
                }];
            }else {
                NSLog(@"Couldnt attach the image to reply");
                success(userReply);

            }
            //add an attachment

        }else{
            success(userReply);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Error replying to case %@", error.localizedDescription);
        failure(error);
    }];

}


///---------------------------------------------------------
/// @name Should show User detail form when creating ticket
///---------------------------------------------------------
/*
 @return YES -> we will ask for username and email address of user
 NO -> if you have username and email of user, and don't want to ask again and again.
 */
- (BOOL)shouldShowUserDetailsFormWhenCreatingTicket {
    return YES;
}

//KB Source delegate.

- (void)fetchKBForSection:(HSKBItem*)section success:(void (^)(NSMutableArray* kbarray))success failure:(void(^)(NSError* e))failure {

    if (!section) {

        // GET ALL SUPPORT CENTER TOPICS
        [self.networkManager GET:@"/api/v2/topics" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* response = (NSDictionary*)responseObject;
            NSNumber* numOfTopics = [response objectForKey:@"total_entries"];

            if ([numOfTopics integerValue] > 0) {

                NSDictionary* embedded = [response objectForKey:@"_embedded"];
                NSArray* topics = [embedded objectForKey:@"entries"];

                NSArray* supportCenterTopics = [topics filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    NSDictionary* top = (NSDictionary*)evaluatedObject;
                    return [[top objectForKey:@"in_support_center"] boolValue];
                }]]; // show just support center topics

                NSMutableArray* topicsToShow = [[NSMutableArray alloc] init];

                for (NSDictionary* topic in supportCenterTopics) {
                    HSDeskKBItem* kbItem = [[HSDeskKBItem alloc] init];
                    [kbItem setItemType:HSKBItemTypeSection]; //type is Section
                    [kbItem setTitle:[topic objectForKey:@"name"]]; //name of topic
                    [kbItem setApiLinks:[topic objectForKey:@"_links"]]; //links to fetch other objects

                    [topicsToShow addObject:kbItem];
                }

                success(topicsToShow);

            }else{
                success(nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];

    }else{

        // GET ARTICLES FOR A SPECIFIC TOPIC

        HSDeskKBItem* deskTopic = (HSDeskKBItem*)section;

        NSDictionary* articlesLinks = [deskTopic.apiLinks objectForKey:@"articles"];

        [self.networkManager GET:[articlesLinks objectForKey:@"href"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSDictionary* response = (NSDictionary*)responseObject;
            NSNumber* numEntries = [response objectForKey:@"total_entries"];

            if ([numEntries integerValue] > 0) {

                NSDictionary* embedded = [response objectForKey:@"_embedded"];
                NSArray* articles = [embedded objectForKey:@"entries"];

                NSArray* supportArticles = [articles filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {

                    NSDictionary* article = (NSDictionary*)evaluatedObject;
                    return [[article objectForKey:@"in_support_center"] boolValue];

                }]]; // show just support center articles


                NSMutableArray* articlesToShow = [[NSMutableArray alloc] init];

                for (NSDictionary* art in supportArticles) {

                    HSDeskKBItem* deskArticle = [[HSDeskKBItem alloc] init];
                    [deskArticle setItemType:HSKBItemTypeArticle]; //type is article
                    [deskArticle setTitle:[art objectForKey:@"subject"]]; //article title
                    [deskArticle setHtmlContent:[art objectForKey:@"body"]]; //html content

                    [articlesToShow addObject:deskArticle];
                }

                success(articlesToShow);

            }else{
                success(nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
    
}

- (void)checkAndFetchValidUser:(HSUser*)user withSuccess:(void (^)(HSUser* validUser))success failure:(void(^)(NSError* e))failure {


    //First search the desk account for customers with same email address.
    //if yes - pick it up and return
    //otherwise - create a new customer and return it with success(validUser)


    NSDictionary* params = @{@"email": user.email};

    [self.networkManager GET:@"api/v2/customers/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSNumber* totalEntries = [responseObject objectForKey:@"total_entries"];

        if (totalEntries.integerValue == 1) {
            NSDictionary* validUserDetails = [[[responseObject objectForKey:@"_embedded"] objectForKey:@"entries"] objectAtIndex:0];

            HSUser* validUser = nil;
            validUser = [[HSUser alloc] init];
            validUser.firstName = [validUserDetails objectForKey:@"first_name"];
            validUser.lastName = [validUserDetails objectForKey:@"last_name"];
            validUser.apiHref = [[[validUserDetails objectForKey:@"_links"] objectForKey:@"self"] objectForKey:@"href"];

            for (NSDictionary* emailDetails in [validUserDetails objectForKey:@"emails"]) {

                if ([[emailDetails objectForKey:@"value"] caseInsensitiveCompare:user.email] == NSOrderedSame) {
                    validUser.email = [emailDetails objectForKey:@"value"];
                }

            }

            success(validUser);


        }else if (totalEntries.integerValue > 1){

            NSArray* couldBeValidUsers = [[responseObject objectForKey:@"_embedded"] objectForKey:@"entries"];

            NSDictionary* validUserDetail = nil;

            for (NSDictionary* userDetail in couldBeValidUsers) {
                for (NSDictionary* emailDetails in [userDetail objectForKey:@"emails"]) {
                    if ([[emailDetails objectForKey:@"value"] isEqualToString:user.email]) {
                        validUserDetail = userDetail;
                    }
                }
            }


            if (validUserDetail) {
                HSUser* validUser = [[HSUser alloc] init];
                validUser.firstName = [validUserDetail objectForKey:@"first_name"];
                validUser.lastName = [validUserDetail objectForKey:@"last_name"];
                validUser.email = [[[validUserDetail objectForKey:@"emails"] objectAtIndex:0] objectForKey:@"value"];
                validUser.apiHref = [[[validUserDetail objectForKey:@"_links"] objectForKey:@"self"] objectForKey:@"href"];


                success(validUser);

            }else {

                failure(nil);
            }

        }else{

            //not found in search.
            //create a new user and send it as valid user.

            NSArray* emails = @[@{@"type": @"home", @"value":user.email}];
            NSDictionary* params = @{@"first_name": user.firstName, @"last_name":user.lastName, @"emails":emails };

            [self.networkManager POST:@"api/v2/customers" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

                HSUser* validUser = nil;
                validUser = [[HSUser alloc] init];
                validUser.firstName = [responseObject objectForKey:@"first_name"];
                validUser.lastName = [responseObject objectForKey:@"last_name"];
                validUser.apiHref = [[[responseObject objectForKey:@"_links"] objectForKey:@"self"] objectForKey:@"href"];


                for (NSDictionary* emailField in [responseObject objectForKey:@"emails"]) {
                    if ([[emailField objectForKey:@"type"] isEqualToString:@"home"]) {
                        validUser.email = [emailField objectForKey:@"value"];
                    }
                }

                success(validUser);

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                NSLog(@"Error while creating customer record.");
                failure(error);
            }];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Error while searching customer record.");
        failure(error);
    }];

}




@end
