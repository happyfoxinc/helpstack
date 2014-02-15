//
//  HSUser.h
//  HelpApp
//
//  Created by Anand on 28/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    `HFUser` class is to hold information about the App User. The Name and Email information of the user is always obtained from the App customer who uses HelpStack for the first time. This user information is used to register this user with the selected helpdesk solution. The registered user information is cached along with any additional user information after registration required by the selected helpdesk solution used.
 */

@interface HSUser : NSObject <NSCoding>

///-----------------------
/// @name User Information
///-----------------------

/**
    The first name of the user
 */
@property (nonatomic, strong) NSString* firstName;

/**
    The last name of the user
 */
@property (nonatomic, strong) NSString* lastName;

/**
    The email of the user with which the user is registered with the selected help desk solution
 */
@property (nonatomic, strong) NSString* email;

/**
    Additional user information such as User ID obtained after the user is registered in the selected help desk solution.
 */
@property (nonatomic, strong) NSString* apiHref;

@property (nonatomic, strong, readonly) NSString* name;

@end
