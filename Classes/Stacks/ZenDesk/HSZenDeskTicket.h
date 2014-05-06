//
//  HAZenDeskTicket.h
//  HelpApp
//
//  Created by Tenmiles on 23/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSTicket.h"

@interface HSZenDeskTicket : HSTicket

- (id)initWithRequestFields:(NSDictionary*)fields;
- (id)initWithTicketFields:(NSDictionary*)fields;

@end
