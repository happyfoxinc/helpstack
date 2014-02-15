//
//  HSUser.m
//  HelpApp
//
//  Created by Anand on 28/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSUser.h"

@implementation HSUser

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.apiHref forKey:@"apiHref"];

}
- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super init]) {

        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.apiHref = [aDecoder decodeObjectForKey:@"apiHref"];
    }

    return self;
}

- (NSString *)name {
    if (self.firstName == nil && self.lastName == nil) return nil;
    if (self.lastName == nil) return self.firstName;
    if (self.firstName == nil) return self.lastName;
    return [NSString stringWithFormat:@"%@ %@",self.firstName, self.lastName];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nUser Name: %@ \nEmail: %@\nApiHref = %@", self.name, _email, _apiHref];
}

@end
