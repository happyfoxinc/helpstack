//
//  HATypeTicket.m
//  HelpApp
//
//  Created by Tenmiles on 30/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSTicket.h"

@implementation HSTicket

#pragma mark - NSCoding methods
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.subject forKey:@"subject"];
    [aCoder encodeObject:self.ticketID forKey:@"ticketID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.subject = [aDecoder decodeObjectForKey:@"subject"];
        self.ticketID = [aDecoder decodeObjectForKey:@"ticketID"];
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nTicket Subject: %@ \nTicketId: %@\n", _subject, _ticketID];
}

@end
