//
//  HAZenDeskTicket.m
//  HelpApp
//
//  Created by Tenmiles on 23/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HAZenDeskTicket.h"
#import "HAZenDeskTicketUpdate.h"

@interface HAZenDeskTicket()

@end

@implementation HAZenDeskTicket

- (id)initWithRequestFields:(NSDictionary*)fields {
    if (self = [super init]) {
        self.ticketID = [[fields objectForKey:@"id"] stringValue];
        self.subject = [fields objectForKey:@"subject"];
    }
    return self;
}

- (id)initWithTicketFields:(NSDictionary *)fields {
    if (self = [super init]) {
        NSDictionary* ticketDictionary = [fields objectForKey:@"ticket"];
        self.ticketID = [ticketDictionary objectForKey:@"id"];
        self.subject = [ticketDictionary objectForKey:@"subject"];
    }
    return self;
}


@end
