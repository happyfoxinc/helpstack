//
//  HAAttachment.h
//  HelpApp
//
//  Created by Santhana Amuthan on 31/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>

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
