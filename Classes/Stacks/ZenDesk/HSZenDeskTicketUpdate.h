//
//  HAZenDeskTicketUpdate.h
//  HelpApp
//
//  Created by Tenmiles on 23/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSUpdate.h"

@interface HSZenDeskTicketUpdate : HSUpdate

@property (nonatomic, assign) Boolean publicNote;

- (id)initWithAudit:(NSDictionary*) audit usersDictionary:(NSArray*) usersDictionary;
- (id)initWithAuthorName:(NSString*)authorname message:(NSString*)message;

@end
