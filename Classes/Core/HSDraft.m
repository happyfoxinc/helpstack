//
//  HSDraft.m
//  Pods
//
//  Created by Anirudh S on 09/01/15.
//
//

#import "HSDraft.h"

@implementation HSDraft

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.draftSubject forKey:@"draftSubject"];
    [aCoder encodeObject:self.draftMessage forKey:@"draftMessage"];
    
    [aCoder encodeObject:self.draftUserFirstName forKey:@"draftUserFirstName"];
    [aCoder encodeObject:self.draftUserLastName forKey:@"draftUserLastName"];
    [aCoder encodeObject:self.draftUserEmail forKey:@"draftUserEmail"];
    
    [aCoder encodeObject:self.draftReplyMessage forKey:@"draftReplyMessage"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.draftSubject = [aDecoder decodeObjectForKey:@"draftSubject"];
        self.draftMessage = [aDecoder decodeObjectForKey:@"draftMessage"];
        
        self.draftUserFirstName = [aDecoder decodeObjectForKey:@"draftUserFirstName"];
        self.draftUserLastName = [aDecoder decodeObjectForKey:@"draftUserLastName"];
        self.draftUserEmail = [aDecoder decodeObjectForKey:@"draftUserEmail"];
        
        self.draftReplyMessage = [aDecoder decodeObjectForKey:@"draftReplyMessage"];
    }
    
    return self;
}




@end
