//
//  HATypeTicket.h
//  HelpApp
//
//  Created by Tenmiles on 30/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 ### Subclassing notes:
 Make sure you implement initWithCoder and encodeWithCoder which saves custom object created by you.
 */
@interface HSTicket : NSObject<NSCoding>

//required
@property(nonatomic, strong) NSString* subject;

//optional
@property (nonatomic, strong) NSString *ticketID;




// Note: call super
- (void)encodeWithCoder:(NSCoder *)aCoder;
// Note: call super
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
