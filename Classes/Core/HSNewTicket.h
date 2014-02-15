//
//  HATypeNewTicket.h
//  HelpApp
//
//  Created by Tenmiles on 30/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSUser.h"

@interface HSNewTicket : NSObject

// required
@property(nonatomic, strong) NSString* subject;
@property(nonatomic, strong) NSString* content;

// optional
@property(nonatomic, strong) NSArray* attachments;


@end
