//
//  HATypeAddReply.h
//  HelpApp
//
//  Created by Tenmiles on 30/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSTicketReply : NSObject

// required
@property (nonatomic, strong) NSString* content;

//optional
@property (nonatomic, strong) NSArray* attachments;

@end
