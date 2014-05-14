//  HSUser.h
//
//Copyright (c) 2014 HelpStack (http://helpstack.io)
//
//Permission is hereby granted, free of charge, to any person obtaining a cop
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

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
