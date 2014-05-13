//
//  HAZenDeskTicketUpdate.m
//  HelpApp
//
//  Created by Tenmiles on 23/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSZenDeskTicketUpdate.h"
#import "HSAttachment.h"

@interface HSZenDeskTicketUpdate ()

@end

@implementation HSZenDeskTicketUpdate

- (id)initWithAudit:(NSDictionary *) audit usersDictionary:(NSArray *) usersDictionary {
    if(self = [super init]) {
        NSArray* array = [audit objectForKey:@"events"];
        for (NSDictionary *eventObject in array) {
            if([[eventObject objectForKey:@"type"] isEqualToString:@"Comment"]) {
                self.content = [eventObject objectForKey:@"body"];
                NSInteger author_id = [[eventObject objectForKey:@"author_id"] integerValue];
                NSDictionary* author = [self searchForUser:author_id array:usersDictionary];
                
                if ([author objectForKey:@"name"] != [NSNull null]) {
                    self.from = [author objectForKey:@"name"];
                }
                
                self.publicNote = [[eventObject objectForKey:@"public"] boolValue];
                
                // updated time
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'Z'"];
                [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                NSDate *date = [dateFormat dateFromString:[audit objectForKey:@"created_at"]];
                self.updatedAt = date;
                
                self.updateType = HATypeStaffReply;
                NSString* role = [author objectForKey:@"role"];
                if ([role isEqualToString:@"end-user"]) {
                    self.updateType = HATypeUserReply;
                }
                
                // Attachments
                NSArray* attachments = [eventObject objectForKey:@"attachments"];
                NSMutableArray* localAttachmnets = [[NSMutableArray alloc] init];
                for (NSDictionary* attchmentObject in attachments) {
                    HSAttachment* localAttach = [[HSAttachment alloc] init];
                    localAttach.url = [attchmentObject objectForKey:@"content_url"];
                    localAttach.fileName = [attchmentObject objectForKey:@"file_name"];
                    localAttach.mimeType = [attchmentObject objectForKey:@"content_type"];
                    
                    [localAttachmnets addObject:localAttach];
                }
                self.attachments = localAttachmnets;
                
                break;
            }
        }
    }
    return self;
}

- (NSDictionary *) searchForUser:(NSInteger) user_id array:(NSArray *) dictionary {
    for (NSDictionary *object in dictionary) {
        if([[object objectForKey:@"id"] integerValue] == user_id) {
            return object;
        }
    }
    return nil;
}

- (id)initUserReplyWithAuthorName:(NSString *)authorname message:(NSString *)message attachments:(NSArray *)attachments {
    if(self = [super init]) {
        self.from = authorname;
        self.content = message;
        self.publicNote = true;
        self.updatedAt = [[NSDate alloc] init];
        self.attachments = [[NSArray alloc] initWithArray:attachments];
        self.updateType = HATypeUserReply;
    }
    return self;
}


@end
