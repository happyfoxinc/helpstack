//  HAGearDeskCom.h
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
#import "HSGear.h"

/**
 TODO: 
 1. Explain toHelpEmail
 2. No need for making it singleton
 
 */
@interface HSDeskGear : HSGear

// Specify the properties required for this Gear.
@property (nonatomic, strong) NSString* instanceBaseURL;
@property (nonatomic, strong) NSString* toHelpEmail;
@property (nonatomic, strong) NSString* staffLoginEmail;
@property (nonatomic, strong) NSString* staffLoginPassword;

- (instancetype)initWithInstanceBaseUrl:(NSString*)instanceBaseURL toHelpEmail:(NSString*)helpEmail staffLoginEmail:(NSString*)loginEmail AndStaffLoginPassword:(NSString*)password;

@end
