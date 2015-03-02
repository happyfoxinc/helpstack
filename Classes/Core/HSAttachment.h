//  HSAttachment.h
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

#import <UIKit/UIKit.h>

/**
    `HSAttachment` class is used to hold ticket attachment information.
 */

@interface HSAttachment : NSObject

///---------------------
/// @name Initialization
///---------------------

/**
    Initialized and created a `HSAttachment` object
    @param url The url of the attachment
    @param fileName file name of the selected attachment
    @param mimeType mime type denoting the type of attachment
 */
- (id)initWithUrl:(NSString *)url fileName:(NSString *)fileName mimeType:(NSString *)mimeType;


/**
    The attachment as a png image
 */
@property (nonatomic, strong) UIImage *attachmentImage;

/**
    The attachment data
 */
@property (nonatomic, strong) NSData  *attachmentData;

/**
    The attachment type
 */
@property (nonatomic, strong) NSString *mimeType;

/**
    url of the attachment
 */
@property (nonatomic, strong) NSString *url;

/**
    Name of the attachment
 */
@property (nonatomic, strong) NSString *fileName;

@end
